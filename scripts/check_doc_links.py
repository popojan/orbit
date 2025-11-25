#!/usr/bin/env python3
"""
Check markdown documentation links.

Validates internal links (to other markdown files, code files, configs)
and identifies broken references. External HTTP(S) links are not checked.

Usage:
    python scripts/check_doc_links.py
    python scripts/check_doc_links.py docs/proofs/chebyshev-egypt-connection.md  # Check single file
"""

import re
import subprocess
import sys
from pathlib import Path
from typing import List, Tuple, Set
from urllib.parse import unquote, urlparse

# Project root
ROOT = Path(__file__).parent.parent


def is_git_tracked(file_path: Path) -> bool:
    """
    Check if a file is tracked by git.

    Returns:
        True if file is tracked, False if untracked or gitignored
    """
    try:
        # Check if file is tracked (returns 0 if tracked)
        result = subprocess.run(
            ['git', 'ls-files', '--error-unmatch', str(file_path)],
            cwd=ROOT,
            capture_output=True,
            text=True
        )
        return result.returncode == 0
    except (subprocess.SubprocessError, FileNotFoundError):
        return False


def extract_links(markdown_file: Path) -> List[Tuple[str, int]]:
    """
    Extract all links from markdown file.

    Returns:
        List of (link_url, line_number) tuples
    """
    links = []
    content = markdown_file.read_text(encoding='utf-8')

    # Match markdown links: [text](url) and reference-style links
    # Match both inline [text](url) and reference [text]: url
    patterns = [
        r'\[([^\]]+)\]\(([^\)]+)\)',  # [text](url)
        r'^\[([^\]]+)\]:\s*(.+)$',     # [ref]: url (at line start)
    ]

    for line_no, line in enumerate(content.split('\n'), 1):
        for pattern in patterns:
            for match in re.finditer(pattern, line, re.MULTILINE):
                url = match.group(2).strip()
                # Skip footnote references (e.g., [^1]: text)
                if match.group(1).startswith('^'):
                    continue
                # Remove anchor fragments
                url = url.split('#')[0]
                if url:  # Skip empty links (pure anchors)
                    links.append((url, line_no))

    return links


def is_external_link(url: str) -> bool:
    """Check if link is external (HTTP/HTTPS)."""
    parsed = urlparse(url)
    return parsed.scheme in ('http', 'https')


def resolve_link(markdown_file: Path, link_url: str) -> Path:
    """
    Resolve relative link to absolute path.

    Args:
        markdown_file: Source markdown file containing the link
        link_url: Link URL (relative or absolute from repo root)

    Returns:
        Absolute Path object
    """
    link_url = unquote(link_url)  # Decode %20 etc

    # Absolute from repo root (starts with /)
    if link_url.startswith('/'):
        return ROOT / link_url.lstrip('/')

    # Relative to current file
    return (markdown_file.parent / link_url).resolve()


def check_file_links(markdown_file: Path) -> List[Tuple[str, int, str]]:
    """
    Check all local file links in markdown file.

    Returns:
        List of (link_url, line_number, error_message) for broken/untracked links
    """
    broken = []
    links = extract_links(markdown_file)

    for link_url, line_no in links:
        # Skip external links (not checked)
        if is_external_link(link_url):
            continue

        # Resolve to absolute path
        target = resolve_link(markdown_file, link_url)

        # Check if target exists
        if not target.exists():
            error = f"Target does not exist: {target}"
            broken.append((link_url, line_no, error))
        # Warn if target exists but is not tracked by git
        elif not is_git_tracked(target):
            error = f"WARNING: Target exists but is not tracked by git (gitignored or untracked): {target}"
            broken.append((link_url, line_no, error))

    return broken


def check_all_docs(doc_dirs: List[Path] = None) -> int:
    """
    Check all markdown files in documentation directories.

    Args:
        doc_dirs: List of directories to check (default: docs/ and root *.md)

    Returns:
        Number of broken links found
    """
    if doc_dirs is None:
        doc_dirs = [ROOT / 'docs']

    # Find all markdown files
    markdown_files: Set[Path] = set()
    for doc_dir in doc_dirs:
        if doc_dir.is_dir():
            markdown_files.update(doc_dir.rglob('*.md'))
        elif doc_dir.suffix == '.md':
            markdown_files.add(doc_dir)

    # Also check root-level markdown files
    markdown_files.update(ROOT.glob('*.md'))

    total_errors = 0
    total_warnings = 0
    total_checked = 0

    for md_file in sorted(markdown_files):
        broken_links = check_file_links(md_file)
        total_checked += 1

        if broken_links:
            rel_path = md_file.relative_to(ROOT)
            print(f"\n{rel_path}:")
            for link_url, line_no, error in broken_links:
                print(f"  Line {line_no}: {link_url}")
                print(f"    → {error}")
                if error.startswith("WARNING:"):
                    total_warnings += 1
                else:
                    total_errors += 1

    # Summary (only print if there are issues - Unix convention)
    if total_errors > 0 or total_warnings > 0:
        print(f"\n{'='*60}")
        print(f"Checked {total_checked} markdown files")
        if total_errors > 0:
            print(f"Found {total_errors} broken links")
        if total_warnings > 0:
            print(f"Found {total_warnings} warnings (untracked files)")

    return total_errors


def main():
    """Main entry point."""
    if len(sys.argv) > 1:
        # Check specific files provided as arguments
        files = [Path(arg) for arg in sys.argv[1:]]
        broken_count = check_all_docs(files)
    else:
        # Check all docs
        broken_count = check_all_docs()

    sys.exit(1 if broken_count > 0 else 0)


if __name__ == '__main__':
    main()
