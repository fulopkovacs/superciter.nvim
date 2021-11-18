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


command Cite :call superciter#select_entry(g:superciter_bibfile)

if !hasmapto('<Plug>Cite')
  map <LocalLeader>ct <Plug>Cite
endif

noremap <silent> <script> <Plug>Cite :call superciter#select_entry(g:superciter_bibfile)<CR>

" Try using FZF for selection


" Format of the list
" nr | year | title | author(s)
" Get the key_brace from the list of key_braces
" [ key_brace_1, kb2, kb3, kb4 ]
let s:test_source_list = [ "first entry | 1 | 2", "second entry | 3 | 4", "third entry | 5 | 6"]

function! FZFInsertKeyword(word)
  " TODO: Extract keyword
  " TODO: Insert only the extracted keyword
  " exe 'normal! "a" . a:word . "\<Esc>"'
  exe "normal! a" . a:word . "\<Esc>"
endfunction

function! FzfKeyword()
  return fzf#run({'source': s:test_source_list,
            \ 'sink': function("FZFInsertKeyword")})
  " return fzf#run(fzf#wrap({
  "  \    'source': s:test_source_list,
  "  \    'sink': function("FZFInsertKeyword")
  "  \ }))
endfunction


command TT :call FzfKeyword()
