# Set default tab length to 4 spaces(?)

default to spaces

# Research

- why python debugger quits immediately after tests fail.
- for a plugin "better%" to change jumping to external/internal brackets.
- if pinning dependencies makes sense.
- nvim neotest better then DAPUI
- "mini" debug mode just for test running. (no left panel)
- running all tests in a file (or a directory)
- How to make ([{}]) less annoying when adding a function before a variable: `process()"message"` (treesitter?)
  - Is it a case really?
- UP\DOWN scrolling window offset dynamic
  - Can I have the "virtual" lines on top of the buffer?
- "better" map of the file. Layout with listed methods/classes, type signatures, etc... ex:
  main.py
  - class CDE
    - connect(a: str, b: int)
    - close()
  - connection(path: str) -> CDE
- Storing output of previous runs
- "Move" functionality.
  - pick a function
  - move to a new file
  - update imports
- Rainbow variables
- checkout: https://github.com/hrsh7th/nvim-cmp
- checkout: https://github.com/ast-grep/ast-grep
- checkout: https://github.com/nvim-lualine/lualine.nvim
- folke/noice.nvim

# Refactor

- Use `init` in plugin manager to setup the colorscheme
- Check if one can exclusively use `keys` property from lazy to setup mappings.
