# Superciter

## TODO

### Short term

- [ ] Add documentation
- [ ] Discover bib files in the current directory automagically
- [x] Use fzf to display the files
- [x] Load bib file into a scratch (nvim-only)
- [x] Display results and make them selectable
- [x] Add a user-friendly way to select bib files (suggestions from workspace?)

### Improvement ideas

- Id selection:
  - display results in a new split buffer (scratch buffer)
  - Capture Enter with `buffer-local autocommands`

### Long term

Use `emmy` for docs: [guide](https://github.com/tjdevries/tree-sitter-lua/blob/master/HOWTO.md)

Create and run tests.

Use this this bib file for the examples: [link](https://github.com/latex-lsp/tree-sitter-bibtex/blob/master/examples/biblatex-examples.bib)

## Development

## Docs

- Dependencies
  - nvim with treesitter support
    - configured for `tree-sitter-bibtex`
  - `fzf` and `fzf.vim` (?)
