" TODO: uncomment after the development have stopped
" if exists('g:superciter_loaded')
"   finish
" endif
" let g:superciter_loaded = 1

" TODO: remove the line below after testing
if ! exists('g:superciter_bibfile')
  let  g:superciter_bibfile = "~/dev-projects/nvim-plugins/superciter/test.bib"
  let  g:superciter_bibfile_bufnr = superciter#load_bib_file(g:superciter_bibfile)
endif

" TODO: delete after testing
command TestSuperCiter :call superciter#test()

" TODO: delete after testing
command TestGetBibInfo :echo superciter#get_bib_entries_info(g:superciter_bibfile_bufnr)


command Cite :call superciter#get_papers()

if !hasmapto('<Plug>Cite')
  map <LocalLeader>ct <Plug>Cite
endif

noremap <silent> <script> <Plug>Cite :call superciter#get_papers()<CR>
