" Load the bib file into a buffer
" and returns the last buffer's number
function superciter#load_bib_file(bib_file_path)

  if ! exists('g:superciter_bibfile')
    throw "The `g:superciter_bibfile` is unset"
  end

  if ! filereadable(a:bib_file_path)
    throw "`" . a:bib_file_path . "` doesn't exists."
  end

  let l:bib_file_buffer_num = bufadd(a:bib_file_path)
  return bib_file_buffer_num
endfunction

" Get all the relevant pieces of information
" about the bib file entries.
function superciter#get_bib_entries_info(bib_file_buffer_num)
  let l:bib_info = luaeval('require("create-bib-table").get_bib_info(_A)', a:bib_file_buffer_num)
  return l:bib_info
endfunction

" Pad or truncate strings based on a desired length
function! s:trunc_str(str_value, goal_length)
  let l:str_value_len = len(a:str_value)
  let l:str_value = a:str_value
  if l:str_value_len < a:goal_length
    let l:i = 0
    while l:i < a:goal_length - l:str_value_len
      let l:i = l:i + 1
      let l:str_value = l:str_value . " "
    endwhile
  elseif l:str_value_len > a:goal_length
    let l:str_value = a:str_value[:a:goal_length-4] . "..."
  endif
  return l:str_value
endfunction

" Truncate the elements in the entry list using a config
function! s:trunc_list_entries(entry_list,  entry_len)
  for entry in a:entry_list
    for key_type in ["year", "author", "title"]
      if ! has_key(entry,  key_type)
        let entry[key_type] = ''
      endif
      let entry[key_type] = s:trunc_str(entry[key_type], a:entry_len[key_type])
    endfor
  endfor

  return a:entry_list
endfunction

" Insert the keybrace of the bibtex entry after the current position of the
" cursor
function! superciter#insert_key_brace(line)
  " TODO: 1. Get the index
  " TODO: 2. Insert the selected keybrace from the index
  exe "normal! a" . a:line . "\<Esc>"
endfunction

" Use fzf to display information about the entries and select one
function superciter#select_entry(superciter_bib_file)

  let l:bib_file_buffer_num = superciter#load_bib_file(a:superciter_bibfile)
  let l:bib_file_entries_list = superciter#get_bib_entries_info(l:bib_file_buffer_num)

  let l:entry_len = { "title": 40, "author": 25, "year": 4 }
  " Truncate the entries in the list using the config above (l:entry_len)
  let l:bib_entry_info_list_trunc = s:trunc_list_entries(l:bib_file_entries_list, l:entry_len)

  let l:bib_entry_info_to_display = []

  let l:i = 0
  for entry in l:bib_entry_info_list_trunc
    let l:i = l:i + 1
    let l:i_str = string(l:i)
    if len(l:i_str) == 1
      let l:i_str = " " . l:i_str
    endif
    call add(l:bib_entry_info_to_display[l:i], l:i_str . " | " . entry["year"] . " | " . entry["author"] . " | " . entry["title"])
  endfor

  return fzf#run({'source': l:bib_entry_info_to_display,
            \ 'sink': function("superciter#insert_key_brace")})
endfunction


" TODO: DELETE THE FUNCTION BELOW AFTER THE `superciter#select_entry()` function is ready
" Display the entry infos in a new buffer
function superciter#display_entry_selection_buffer(superciter_bibfile)

  let l:bib_file_buffer_num = superciter#load_bib_file(a:superciter_bibfile)

  let l:bib_file_entries_list = superciter#get_bib_entries_info(l:bib_file_buffer_num)
  let l:entry_len = { "title": 40, "author": 25, "year": 4 }
  " Truncate the entries in the list using the config above (l:entry_len)
  let l:bib_file_entries_list = s:trunc_list_entries(l:bib_file_entries_list, l:entry_len)


  let l:i = 0
  for entry in l:bib_file_entries_list
    let l:i = l:i + 1
    let l:i_str = string(l:i)
    if len(l:i_str) == 1
      let l:i_str = " " . l:i_str
    endif
    echo l:i_str . " | " . entry["year"] . " | " . entry["author"] . " | " . entry["title"]
  endfor

  " Display an input for the user to select an entry
  " and return the key_brace of the entry
  function! s:select_entry(entry_list)
    let l:selected_entry = str2nr(input('Please select an entry (empty cancels): '))
    if  l:selected_entry > 0 && l:selected_entry <= len(a:entry_list)
      return a:entry_list[l:selected_entry-1]["key_brace"]
    else
      return ""
    endif
  endfunction

  " Insert the selected key_brace into the current cursor position
  function! s:insert_key_brace(key_brace, full_notation)
    if a:key_brace != ""
      let l:line = getline('.')
      let l:key_brace_text = a:key_brace
      if a:full_notation
        let l:key_brace_text =  "[@" . a:key_brace . "]"
      endif
      call setline('.', strpart(l:line, 0, col('.')) . l:key_brace_text . strpart(l:line, col('.')))
      return l:line
    endif
  endfunction

  let l:key_brace = s:select_entry(l:bib_file_entries_list)
  eval s:insert_key_brace(l:key_brace, 2)
endfunction
