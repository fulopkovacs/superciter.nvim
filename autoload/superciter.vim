" TODO: delete after testing
" Returns the line
function superciter#test()
  echo luaeval(
    \ 'require("test").say_something()',
    \ )
endfunction

" Load the bib file into a buffer
" and returns the last buffer's number
function superciter#load_bib_file(bib_file_path)
  execute "badd " . a:bib_file_path
  let l:bib_file_buffer_num = bufnr("$")
  return bib_file_buffer_num
endfunction

" Get all the relevant pieces of information
" about the bib file entries.
function superciter#get_bib_entries_info(bib_file_buffer_num)
  let l:bib_info = luaeval('require("create-bib-table").get_bib_info(_A)', a:bib_file_buffer_num)
  return l:bib_info
endfunction
