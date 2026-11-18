-- lua/custom/plugins/lint.lua
--
-- No linting on prose. kickstart's lint plugin lints markdown with
-- `markdownlint` (the deprecated npm markdownlint-cli binary) on every BufEnter
-- and write, which is not wanted here: markdown is the only filetype nvim-lint
-- is configured for, so clearing it turns linting off altogether. Markdown keeps
-- treesitter highlighting and LSP diagnostics.
require('lint').linters_by_ft.markdown = nil

