-- Plan: use TreeSitter query to extract information about the bib file
-- load the bib file into a buffer
-- INFO: run this file with: `:luafile %`
local bufnr = 5
local ts = vim.treesitter
local ts_utils = require 'nvim-treesitter.ts_utils'

--[[
entry [0, 0] - [0, 229]
  ty: entry_type [0, 0] - [0, 8]
  key: key_brace [0, 10] - [0, 15]
  field: field [0, 17] - [0, 81]
    name: identifier [0, 17] - [0, 23]
    value: value [0, 24] - [0, 81]
]] --

-- TODO: bib file must be loaded to a buffer (named buffer?/register)

local parser = ts.get_parser(bufnr, 'bibtex') -- todo:bibtex might not be correct

local tstree = parser:parse()[1] -- TODO: not sure why the `[1]` is needed...

local document = tstree:root() -- this is the document

local start_range, _, end_range, _ = document:range()

--[[
Get the keys:
(entry ty:(entry_type) key:(key_brace)@key)

Get all the identifiers and their values
(field name:(identifier) @id value:(value) @val (#eq? @id "title")) @fld

Get all the keys and titles for the entries that do have a title:
(entry ty:(entry_type) key:(key_brace)@key field:(field ((identifier) @id (value) @val (#eq? @id "title"))))

Get all the keys where there are no title
]] --

-- local query = [[
--   (entry ty:(entry_type) key:(key_brace)@key field:(field ((identifier) @id (value) @val (#eq? @id "title"))))
-- ]]
-- local query = [[
-- ((identifier)@i (value)@v (#eq? @i "title"))
-- ]]
-- local query = [[
-- (entry (key_brace) @kk (field ((identifier)@ii (value)@vv (#eq? @ii "title"))))
-- ]]
-- local query = [[
-- (entry (key_brace) @kk (field ((identifier)@t (value)@vt (#eq? @t "title"))))
-- ]]
local query = [[
(entry (key_brace) @key (field ((identifier)@i (value) @t)))
]]

local parsed_query = ts.parse_query('bibtex', query)

local ids = {}
local titles = {}

local function get_text_value(bufnr, row1, col1, row2, col2)
    local lines = vim.api.nvim_buf_get_lines(bufnr, row1, row2 + 1, 1)
    lines[1] = string.sub(lines[1], col1 + 1, -1)
    lines[#lines] = string.sub(lines[#lines], 0, col2 - 2)
    local text = table.concat(lines, ' ')
    return text
end

for id, node, metadata in parsed_query:iter_captures(document, bufnr, start_range, end_range) do
    local captured_name = parsed_query.captures[id] -- name of the capture in the query
    local type = node:type()
    local text = get_text_value(bufnr, node:range())
    -- print(type, captured_name, text)

    if captured_name == 'key' then
        ids[#ids + 1] = text
    elseif captured_name == 'val' then
        titles[#titles + 1] = text
    else
        print(text)
    end

    -- print(captured_name, type, row1, col1, row2, col2)
end

if #ids == #titles then for i = 1, #titles do print(ids[i], titles[i]) end end
-- for i = 1, #ids do print(ids[i]) end
print(#ids)
print(#titles)
