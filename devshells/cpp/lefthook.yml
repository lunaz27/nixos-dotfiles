# lefthook.yml

pre-commit:
  parallel: true
  commands:
    format-cpp:
      glob: "*.{cpp,h,hpp}"
      run: just format-cpp {staged_files} && git add {staged_files}

    lint-cpp:
      glob: "*.{cpp,h,cpp}"
      run: just lint-cpp {staged_files}

    format-py:
      glob: "*.py"
      run: just format-py {staged_files} && git add {staged_files}

    lint-py:
      glob: "*.py"
      run: just lint-py {staged_files}

pre-push:
  parallel: false
  commands:
    test:
      run: just test
