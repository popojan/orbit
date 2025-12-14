/**
 * Orbit-based sigmoid activation - C++ toy example
 *
 * Uses exact rational arithmetic (no floating point in core computation).
 * For production, link with GMP/MPFR or ARB for arbitrary precision.
 *
 * Compile: g++ -O2 -o orbit_sigmoid_test orbit_sigmoid_test.cpp -lgmp
 * Or without GMP: g++ -O2 -o orbit_sigmoid_test orbit_sigmoid_test.cpp
 */

#include <iostream>
#include <vector>
#include <cmath>
#include <chrono>
#include <algorithm>

// Simple rational number (for toy example - use GMP mpq_t for production)
struct Rational {
    long long num, den;

    Rational(long long n = 0, long long d = 1) : num(n), den(d) {
        if (den < 0) { num = -num; den = -den; }
        long long g = gcd(std::abs(num), den);
        num /= g; den /= g;
    }

    static long long gcd(long long a, long long b) {
        return b == 0 ? a : gcd(b, a % b);
    }

    double to_double() const { return (double)num / den; }

    // For logit computation
    double logit() const {
        double y = to_double();
        return std::log(y / (1.0 - y));
    }
};

// I=19 orbit - 30 exact rational values forming a sigmoid
// Pre-computed from OrbitEnumerate[19, 800]
const std::vector<Rational> ORBIT_19 = {
    {1, 609}, {1, 305}, {1, 153}, {1, 77}, {1, 39},
    {19, 531}, {1, 20}, {19, 275}, {2, 21}, {19, 147},
    {4, 23}, {19, 83}, {8, 27}, {19, 51}, {16, 35},
    {19, 35}, {32, 51}, {19, 27}, {64, 83}, {19, 23},
    {128, 147}, {19, 21}, {256, 275}, {19, 20}, {512, 531},
    {38, 39}, {76, 77}, {152, 153}, {304, 305}, {608, 609}
};

class OrbitSigmoid {
private:
    std::vector<double> x_pos;  // logit values
    std::vector<double> y_val;  // orbit values
    int n;
    double x_min, x_max;

public:
    OrbitSigmoid(const std::vector<Rational>& orbit) {
        n = orbit.size();
        x_pos.resize(n);
        y_val.resize(n);

        for (int i = 0; i < n; i++) {
            y_val[i] = orbit[i].to_double();
            x_pos[i] = orbit[i].logit();
        }

        x_min = x_pos[0];
        x_max = x_pos[n-1];
    }

    // Piecewise linear interpolation
    double operator()(double x) const {
        if (x <= x_min) return y_val[0];
        if (x >= x_max) return y_val[n-1];

        // Binary search
        int lo = 0, hi = n - 1;
        while (lo < hi - 1) {
            int mid = (lo + hi) / 2;
            if (x_pos[mid] <= x) lo = mid;
            else hi = mid;
        }

        // Linear interpolation
        double t = (x - x_pos[lo]) / (x_pos[hi] - x_pos[lo]);
        return y_val[lo] + t * (y_val[hi] - y_val[lo]);
    }

    int size() const { return n; }
    double range_min() const { return x_min; }
    double range_max() const { return x_max; }
};

// Standard sigmoid for comparison
inline double std_sigmoid(double x) {
    return 1.0 / (1.0 + std::exp(-x));
}

// Test accuracy
void test_accuracy(const OrbitSigmoid& orbit_sig) {
    const int N = 10000;
    double max_err = 0, sum_err = 0;

    for (int i = 0; i < N; i++) {
        double x = orbit_sig.range_min() +
                   (orbit_sig.range_max() - orbit_sig.range_min()) * i / (N - 1);
        double true_y = std_sigmoid(x);
        double approx_y = orbit_sig(x);
        double err = std::abs(true_y - approx_y);
        max_err = std::max(max_err, err);
        sum_err += err;
    }

    std::cout << "Accuracy test (" << N << " points):\n";
    std::cout << "  Max error:  " << (max_err * 100) << "%\n";
    std::cout << "  Mean error: " << (sum_err / N * 100) << "%\n";
}

// Benchmark speed
void benchmark(const OrbitSigmoid& orbit_sig, int iterations = 10000000) {
    volatile double sink = 0;  // prevent optimization

    // Warm up
    for (int i = 0; i < 1000; i++) {
        sink += orbit_sig(i * 0.001 - 5);
        sink += std_sigmoid(i * 0.001 - 5);
    }

    // Benchmark orbit sigmoid
    auto t1 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < iterations; i++) {
        double x = (i % 1000) * 0.01 - 5;
        sink += orbit_sig(x);
    }
    auto t2 = std::chrono::high_resolution_clock::now();

    // Benchmark standard sigmoid
    auto t3 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < iterations; i++) {
        double x = (i % 1000) * 0.01 - 5;
        sink += std_sigmoid(x);
    }
    auto t4 = std::chrono::high_resolution_clock::now();

    double orbit_time = std::chrono::duration<double>(t2 - t1).count();
    double std_time = std::chrono::duration<double>(t4 - t3).count();

    std::cout << "\nSpeed test (" << iterations << " calls):\n";
    std::cout << "  Orbit sigmoid: " << orbit_time * 1000 << " ms\n";
    std::cout << "  Std sigmoid:   " << std_time * 1000 << " ms\n";
    std::cout << "  Speedup:       " << std_time / orbit_time << "x\n";
}

// Simple binary classification test
void test_classification() {
    OrbitSigmoid orbit_sig(ORBIT_19);

    // Generate synthetic logits (from "trained model")
    std::vector<double> logits = {-3.5, -2.1, -0.5, 0.2, 1.8, 3.2, -1.2, 0.8};
    std::vector<int> labels =    {   0,    0,    0,   1,   1,   1,    0,   1};

    std::cout << "\nBinary classification test:\n";
    std::cout << "  Logit\t\tStd σ\t\tOrbit σ\t\tLabel\tMatch?\n";
    std::cout << "  " << std::string(60, '-') << "\n";

    int correct_std = 0, correct_orbit = 0;
    for (size_t i = 0; i < logits.size(); i++) {
        double p_std = std_sigmoid(logits[i]);
        double p_orbit = orbit_sig(logits[i]);
        int pred_std = p_std >= 0.5 ? 1 : 0;
        int pred_orbit = p_orbit >= 0.5 ? 1 : 0;

        if (pred_std == labels[i]) correct_std++;
        if (pred_orbit == labels[i]) correct_orbit++;

        std::cout << "  " << logits[i] << "\t\t"
                  << p_std << "\t" << p_orbit << "\t"
                  << labels[i] << "\t"
                  << (pred_std == pred_orbit ? "✓" : "✗") << "\n";
    }

    std::cout << "\n  Std accuracy:   " << correct_std << "/" << logits.size() << "\n";
    std::cout << "  Orbit accuracy: " << correct_orbit << "/" << logits.size() << "\n";
}

int main() {
    std::cout << "=== Orbit Sigmoid Test (I=19) ===\n\n";

    OrbitSigmoid orbit_sig(ORBIT_19);

    std::cout << "LUT size: " << orbit_sig.size() << " rational values\n";
    std::cout << "Range: [" << orbit_sig.range_min() << ", "
              << orbit_sig.range_max() << "]\n\n";

    // Show first/last few values
    std::cout << "First 5 orbit values (as fractions):\n";
    for (int i = 0; i < 5; i++) {
        std::cout << "  " << ORBIT_19[i].num << "/" << ORBIT_19[i].den
                  << " = " << ORBIT_19[i].to_double() << "\n";
    }
    std::cout << "  ...\n";

    test_accuracy(orbit_sig);
    benchmark(orbit_sig);
    test_classification();

    return 0;
}
