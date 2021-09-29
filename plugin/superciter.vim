if exists('g:superciter_loaded')
  finish
endif
let g:superciter_loaded = 1
let  g:superciter_bibfile = expand("~/dev-projects/nvim-plugins/superciter/test.bib")

" TODO: delete after testing
command TestSuperCiter :call superciter#test()

" TODO: delete after testing
command TestGetBibInfo :echo superciter#get_bib_entries_info(g:superciter_bibfile_bufnr)
command TestDisplayBibInfo :call superciter#display_entry_selection_buffer(g:superciter_bibfile)


command Cite :call superciter#get_papers()

if !hasmapto('<Plug>Cite')
  map <LocalLeader>ct <Plug>Cite
endif

noremap <silent> <script> <Plug>Cite :call superciter#get_papers()<CR>
