# lefthook.yml

pre-commit:
  parallel: true
  commands:
    format-c:
      glob: "*.{c,h}"
      run: just format-c {staged_files} && git add {staged_files}

    lint-c:
      glob: "*.{c,h}"
      run: just lint-c {staged_files}

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
