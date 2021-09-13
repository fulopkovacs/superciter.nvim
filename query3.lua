-- INFO: run this file with: `:luafile%`
local bufnr = 11
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
-- ((identifier)@i (value)@v (#any-of? @i "title" "author"))
-- ]]

-- SOME VALID QUERIES
--[[
((identifier)@i (value)@v (#eq? @i "title"))

(key_brace) @k

(
  (key_brace)@k
  (field (
    (identifier) @i
    (value) @v
  ))@f
)


(
  (key_brace)@k
  (field (
    (identifier) @i
    (value) @v
    (#any-of? @i "title" "author")
  ))@f
)

]] --

local parsed_query = ts.parse_query('bibtex', query)

-- print(start_range, end_range) -- test if the document is read

-- print the keys and values from the parsed query
-- for k,v in pairs(parsed_query) do
--   print(k,v)
-- end

local ids = {}
local titles = {}
local authors = {}

--[[
1. set id in metadata
2. then we  can have entreis like this:
local entries = {ab94= {author, title, year}}
--]]

-- Remove enclosing "-s and {}-s
local function strip_value(value)
    if value:sub(1, 1) == '"' or value:sub(1, 1) == '{' then value = string.sub(value, 2, #value - 2) end
    return value
end

-- Get text value from the file
local function get_text_value(bufnr, node)
    local row1, col1, row2, col2 = node:range()
    local lines = vim.api.nvim_buf_get_lines(bufnr, row1, row2 + 1, 0)
    local text = ''
    if row1 == row2 then
        -- Every word in the title is on the same line
        text = string.sub(lines[1], col1 + 1, col2 + 1)
    else
        -- The title is broken into multiple lines
        lines[1] = string.sub(lines[1], col1 + 1, -1)
        lines[#lines] = string.sub(lines[#lines], 0, col2 + 1)
        text = table.concat(lines, ' ')
    end
    return strip_value(text)
end

-- Collect the nodes
for id, node, metadata in parsed_query:iter_captures(document, bufnr, start_range, end_range) do
    local captured_name = parsed_query.captures[id] -- name of the capture in the query
    local type = node:type()
    local text = get_text_value(bufnr, node)
    if type == "value" then table.insert(titles, text) end
    -- if id ~= 1 then break end -- TODO: remove after testing
end

-- if #ids == #titles then for i = 1, #titles do print(ids[i], titles[i]) end end
-- print(#ids)
print(#titles)
-- print(titles[3])
-- print(vim.inspect(titles))
for i = 1, #titles do print(titles[i]) end
-- print(titles[1])
