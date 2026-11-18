-- lua/custom/plugins/mason.lua
--
-- This host gets its language tooling from nixpkgs (`stylua`,
-- `markdownlint-cli2`, `clang-tools`, `pyright` in
-- ~/source/nix/home/common.nix). Mason's installers need npm, go and unzip on
-- PATH and then drop prebuilt binaries outside the Nix store, which is both
-- fragile here and duplicates what Nix already provides.
--
-- Keep Mason for the two things nixpkgs does not ship usefully:
--   * lua-language-server  (already installed under ~/.local/share/nvim/mason)
--   * codelldb             (installed on demand by lua/custom/plugins/cpp-debug.lua)

-- init.lua asks mason-tool-installer to install every key of its `servers`
-- table, `stylua` included. `stylua` is a Nix package here, its Mason install
-- fails ("unzip ENOENT") and the failure surfaces as an error on every start.
-- VimEnter is where mason-tool-installer fires, so clearing the list here wins.
require('mason-tool-installer').setup { ensure_installed = {}, run_on_start = false }

-- Adapters are installed explicitly where they are used (see cpp-debug.lua), so
-- automatic installation has nothing to do; it would otherwise reach for a
-- Go toolchain through nvim-dap-go.
require('mason-nvim-dap').setup { automatic_installation = false }
