#!/usr/bin/env python

import subprocess
from pathlib import Path

import pytest

# Absolute paths
TESTS_DIR = Path(__file__).parent
ROOT_DIR = TESTS_DIR.parent
SRC_DIR = ROOT_DIR / "src"
BUILD_DIR = ROOT_DIR / "build"
TEST_DIRS = sorted(d for d in TESTS_DIR.glob("test_*") if d.is_dir())
DESIGN_SV = sorted(SRC_DIR.glob("*.sv"))

# Mkdir if missing ../build/
BUILD_DIR.mkdir(exist_ok=True)


@pytest.mark.parametrize("test_dir", TEST_DIRS, ids=[d.name for d in TEST_DIRS])
def test_hdl_simulation(test_dir: Path) -> None:
    expected_file = test_dir / "expected.txt"
    tb_files = list(test_dir.glob("tb_*.sv"))

    if not expected_file.exists():
        pytest.skip(f"Missing expected.txt in {test_dir.name}.")
    if not tb_files:
        pytest.skip(f"Missing tb_*.sv in {test_dir.name}.")

    tb_file = tb_files[0]
    vvp_output = BUILD_DIR / f"{test_dir.name}.vvp"
    vcd_output = BUILD_DIR / f"{test_dir.name}.vcd"

    compile_cmd = [
        "iverilog",
        "-Wall",
        "-o",
        str(vvp_output),
        *map(str, DESIGN_SV),
        str(tb_file),
    ]

    compile_result = subprocess.run(
        compile_cmd,
        capture_output=True,
        encoding="utf-8",
        text=True,
        timeout=5,
        check=False,
    )
    assert compile_result.returncode == 0, (
        f"Compilation failed for {test_dir.name}:\n{compile_result.stderr}."
    )

    sim_result = subprocess.run(
        ["vvp", str(vvp_output)],
        capture_output=True,
        encoding="utf-8",
        text=True,
        timeout=5,
        check=False,
    )
    assert sim_result.returncode == 0, (
        f"Simulation crashed for {test_dir.name}:\n{sim_result.stderr}"
    )

    with open(expected_file, encoding="utf-8") as f:
        expected_output = f.read()

    clean_sim_result: list[str] = []
    for line in sim_result.stdout.splitlines(keepends=True):
        if line.startswith("VCD info:") or "finish called at" in line:
            continue
        clean_sim_result.append(line)

    clean_sim_output = "".join(clean_sim_result)
    assert clean_sim_output == expected_output

    vvp_output.unlink(missing_ok=True)
    vcd_output.unlink(missing_ok=True)
