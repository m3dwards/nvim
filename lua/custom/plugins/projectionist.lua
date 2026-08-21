-- lua/custom/plugins/projectionist.lua
-- Alternate-file navigation via tpope/vim-projectionist.
-- Provides :A / :AV / :AS / :AT to jump between related files
-- (source <-> header <-> unit test), plus :Esource, :Eheader, :Etest.

vim.pack.add { 'https://github.com/tpope/vim-projectionist' }

-- Global heuristics: activate for CMake C/C++ projects that keep code under
-- src/ (e.g. Bitcoin Core). Rooted at the ancestor holding both a top-level
-- CMakeLists.txt and a src/ directory, so paths below are relative to that
-- root. `{}` captures the wildcard and is reused in the alternates.
--
-- Note: unit tests are expected at src/test/<name>_tests.cpp, matching the
-- top-level src layout. Deeply nested tests (e.g. src/wallet/test/) won't be
-- auto-detected; extend the globs or add a project-local .projections.json if
-- you need those.
vim.g.projectionist_heuristics = {
  ['CMakeLists.txt&src/'] = {
    ['src/*.cpp'] = {
      alternate = { 'src/{}.h', 'src/test/{}_tests.cpp' },
      type = 'source',
    },
    ['src/*.h'] = {
      alternate = { 'src/{}.cpp', 'src/test/{}_tests.cpp' },
      type = 'header',
    },
    ['src/test/*_tests.cpp'] = {
      alternate = { 'src/{}.cpp', 'src/{}.h' },
      type = 'test',
    },
  },
}
