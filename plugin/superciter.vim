if exists('g:superciter_loaded')
  finish
endif
let g:superciter_loaded = 1

" TODO: Automatically search for the bib files in the current directory
let s:bib_file_manjaro = expand("~/dev-projects/neovim-plugins/superciter.nvim/test.bib")
let s:bibfile_macbook = expand("~/dev-projects/nvim-plugins/superciter/test.bib")

if filereadable(s:bib_file_manjaro)
  " Assume that I'm using my Desktop PC
  let g:superciter_bibfile = s:bib_file_manjaro
else
  " Assume that I'm using my MacBook
  let g:superciter_bibfile = s:bibfile_macbook
endif


" TODO: delete after testing
command TestGetBibInfo :echo superciter#get_bib_entries_info(g:superciter_bibfile_bufnr)
command TestDisplayBibInfo :call superciter#display_entry_selection_buffer(g:superciter_bibfile)


command Cite :call superciter#display_entry_selection_buffer(g:superciter_bibfile)

if !hasmapto('<Plug>Cite')
  map <LocalLeader>ct <Plug>Cite
endif

noremap <silent> <script> <Plug>Cite :call superciter#display_entry_selection_buffer(g:superciter_bibfile)<CR>
