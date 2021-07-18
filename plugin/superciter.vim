if exists('g:superciter_loaded')
  finish
endif
let g:superciter_loaded = 1

" TODO: delete after testing
command TestSuperCiter :call superciter#test()


command Cite :call superciter#get_papers()

if !hasmapto('<Plug>Cite')
  map <LocalLeader>ct <Plug>Cite
endif

noremap <silent> <script> <Plug>Cite :call superciter#get_papers()<CR>
