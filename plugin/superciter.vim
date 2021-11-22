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


command Cite :call superciter#select_entry(g:superciter_bibfile)

if !hasmapto('<Plug>Cite')
  map <LocalLeader>ct <Plug>Cite
endif

noremap <silent> <script> <Plug>Cite :call superciter#select_entry(g:superciter_bibfile)<CR>
