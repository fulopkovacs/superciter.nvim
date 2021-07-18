" TODO: delete after testing
" Returns the line
function superciter#test()
  echo luaeval(
    \ 'require("test").Test(_A)',
    \ getline(1)
    \ )
endfunction

function superciter#find_bib_file()
  let l:bibfile = systemlist("find . -name \"*.bib\"")

  return l:bibfile
  "/home/fulop/dev-projects/neovim-plugins/superciter.nvim/papers.bib"
endfunction

function superciter#get_papers()
  if ! exists('g:superciter#bibfile')
    let l:bibfile_list = superciter#find_bib_file()

    if len(l:bibfile_list) > 1
      echo "Too many bib files:"
      echo l:bibfile_list
      echo "Please set g:superciter#bibfile to an existing file!"
      return
    elseif len(l:bibfile_list) == 0
      echo "No bibfiles found."
      echo "Please set g:superciter#bibfile to an existing file!"
      return
    else
      let g:superciter#bibfile = l:bibfile_list[0]
    end
  endif

  let l:paper_id = luaeval(
    \ 'require("superciter").get_papers(_A)',
    \ g:superciter#bibfile
    \ )

  if ! empty(l:paper_id)
    let l:line = getline('.')
    call setline('.', strpart(l:line, 0, col('.') - 1) . l:paper_id . strpart(l:line, col('.') - 1))
  endif
endfunction
