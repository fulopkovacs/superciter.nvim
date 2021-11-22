--[[
Return a table with the relevant information for every entry in the bib file..
]] --
-- Remove enclosing "-s and {}-s
local function strip_value(value)
    if value:sub(1, 1) == '"' or value:sub(1, 1) == '{' then value = string.sub(value, 2, #value - 1) end
    return value
end

-- Get text value from the node
local function get_text_value(bufnr, node)
    local row1, col1, row2, col2 = node:range()
    local lines = vim.api.nvim_buf_get_lines(bufnr, row1, row2 + 1, 0)
    local text = ''
    if row1 == row2 then
        -- Every word in the title is on the same line
        text = string.sub(lines[1], col1 + 1, col2)
    else
        -- The title is broken into multiple lines
        lines[1] = string.sub(lines[1], col1 + 1, -1)
        lines[#lines] = string.sub(lines[#lines], 0, col2)
        text = table.concat(lines, ' ')
    end
    return strip_value(text)
end

-- Update the bib table with the key_brace values
local function update_bib_table(bib_table)
    local updated_bib_table = {}
    local i = 0
    for k, v in pairs(bib_table) do
        i = i + 1
        updated_bib_table[i] = {key_brace = k}
        for kk, vv in pairs(v) do updated_bib_table[i][kk] = vv end
    end
    return updated_bib_table
end

-- Sort the table of the bib entries by the name of the first authors
local function sort_by_author(entry_1, entry_2)
    -- Make sure that the entries without titles will be ranked lower than
    -- the entries with titles
    if entry_1["author"] == nil and entry_2 then return false end
    if entry_2["author"] == nil and entry_1 then return true end
    if entry_1 == nil and entry_2 == nil then return true end

    if entry_1['author'] < entry_2['author'] then
        return true
    else
        return false
    end
end

-- Get all the relevant info from the bib file nodes
local function get_bib_info(parsed_query, document, bufnr, start_range, end_range)
    local bib_table = {}
    -- Collect the nodes
    local match_id = 0
    local captured_key_braces = {}
    for _, match, _ in parsed_query:iter_matches(document, bufnr, start_range, end_range) do
        match_id = match_id + 1
        local matched_value = ''
        local matched_identifier = ''
        for _, node in pairs(match) do
            local type = node:type()
            local text = get_text_value(bufnr, node)
            if type == "value" then matched_value = text end
            if type == "identifier" then matched_identifier = text end
            if type == "key_brace" then table.insert(captured_key_braces, text) end
        end
        local matched_key_brace = captured_key_braces[match_id]
        if bib_table[matched_key_brace] == nil then bib_table[matched_key_brace] = {} end
        bib_table[matched_key_brace][matched_identifier] = matched_value
    end
    return bib_table
end

local function create_bib_table(bufnr)

    local ts = vim.treesitter
    local ts_utils = require 'nvim-treesitter.ts_utils'

    -- Parse a bibtex file
    local parser = ts.get_parser(bufnr, 'bibtex')

    local tstree = parser:parse()[1]

    local document = tstree:root()

    -- read document
    local start_range, _, end_range, _ = document:range()

    local query = [[
  (
    (key_brace)@k
    (field (
      (identifier) @i
      (value) @v
      (#any-of? @i "title" "author" "year")
    ))
  )
  ]]

    local parsed_query = ts.parse_query('bibtex', query)

    local bib_table = get_bib_info(parsed_query, document, bufnr, start_range, end_range)

    bib_table = update_bib_table(bib_table)

    table.sort(bib_table, sort_by_author)

    return bib_table
end

return {get_bib_info = create_bib_table}
