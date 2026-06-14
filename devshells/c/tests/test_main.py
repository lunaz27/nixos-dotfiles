#!/usr/bin/env python

import subprocess
from pathlib import Path

import pytest

# Absolute paths
TESTS_DIR = Path(__file__).parent
ROOT_DIR = TESTS_DIR.parent
BINARY_PATH = ROOT_DIR / "build" / "debug" / "main"
TEST_DIRS = sorted(
    [d for d in TESTS_DIR.iterdir() if d.is_dir() and d.name.startswith("test_")]
)

# pytest logic
@pytest.mark.parametrize(
    "test_dir",
    TEST_DIRS,
    ids=[d.name for d in TEST_DIRS]
)
def test_c_simulation(test_dir: Path) -> None:
    expected_file = test_dir / "expected.txt"

    if not expected_file.exists():
        pytest.skip(f"Missing expected.txt in {test_dir.name}")

    result = subprocess.run(
        [str(BINARY_PATH), test_dir.name],
        capture_output=True,
        encoding="utf-8",
        text=True,
        timeout=5
    )

    assert result.returncode == 0, (
        f"C crashed (Code: {result.returncode})\n"
        f"STDOUT:\n{result.stdout}\n"
        f"STDERR:\n{result.stderr}"
    )

    with open(expected_file, encoding="utf-8") as f:
        expected_output = f.read()

    assert result.stdout == expected_output


@pytest.mark.parametrize(
    "test_dir",
    TEST_DIRS,
    ids=[d.name for d in TEST_DIRS]
)
def test_memory_leaks(test_dir: Path) -> None:
    expected_file = test_dir / "expected.txt"

    if not expected_file.exists():
        pytest.skip(f"Missing expected.txt in {test_dir.name}")

    result = subprocess.run(
        [
            "valgrind",
            "--leak-check=full",
            "--show-leak-kinds=all",
            "--error-exitcode=1",
            str(BINARY_PATH),
            test_dir.name
        ],
        capture_output=True,
        text=True,
        encoding="utf-8",
        timeout=10
    )

    assert result.returncode == 0, (
        f"MEMORY LEAK DETECTED in {test_dir.name}!\n"
        f"Valgrind Output:\n{result.stderr}"
    )
