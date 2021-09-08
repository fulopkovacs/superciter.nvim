-- INFO: run this file with: `:luafile%`
local bufnr = 6
local ts = vim.treesitter
local ts_utils = require 'nvim-treesitter.ts_utils'

-- Parse a bibtex file
local parser = ts.get_parser(bufnr, 'bibtex')

local tstree = parser:parse()[1]

local document = tstree:root()

-- read document
local start_range, _, end_range, _ = document:range()

local query = [[
((identifier)@i (value)@v (#eq? @i "title"))
]]
-- local query = [[
-- ((value)@v)
-- ]]

local parsed_query = ts.parse_query('bibtex', query)

-- print(start_range, end_range) -- test if the document is read

-- print the keys and values from the parsed query
-- for k,v in pairs(parsed_query) do
--   print(k,v)
-- end

local ids = {}
local titles = {}

-- Get text value from the file
local function get_text_value(bufnr, row1, col1, row2, col2)
    local lines = vim.api.nvim_buf_get_lines(bufnr, row1, row2 + 1, 1)
    lines[1] = string.sub(lines[1], col1 + 1, -1)
    lines[#lines] = string.sub(lines[#lines], 0, col2 - 2)
    local text = table.concat(lines, ' ')
    return text
end

-- Collect the nodes
for id, node, metadata in parsed_query:iter_captures(document, bufnr, start_range, end_range) do
    local captured_name = parsed_query.captures[id] -- name of the capture in the query
    local type = node:type()
    local text = get_text_value(bufnr, node:range())
    if type == "value" then table.insert(titles, text) end
end

-- if #ids == #titles then for i = 1, #titles do print(ids[i], titles[i]) end end
-- print(#ids)
print(#titles)
print(titles[3])
for i in 1,#titles do print(titles[i]) end