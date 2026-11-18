-- lua/custom/plugins/lint.lua
--
-- kickstart's lint plugin lints markdown with `markdownlint`, the deprecated npm
-- markdownlint-cli binary. nixpkgs ships markdownlint-cli2, which nvim-lint also
-- knows about, so point the filetype at that instead of shelling out to
-- something that is not installed (it used to fail on every markdown buffer with
-- "Error running markdownlint: ENOENT").
require('lint').linters_by_ft.markdown = { 'markdownlint-cli2' }
