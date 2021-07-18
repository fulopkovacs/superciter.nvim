-- USE COMPLETE LIST OF BIBTEX ENTRY TYPES
-- The examples are from: https://www.economics.utoronto.ca/osborne/latex/BIBTEX.HTM
Bib_file = "./test.bib"

--[[
STRATEGY

1. enter an entry
2. extract ID
3. search for title
4. leave entry

]] --

S_full = "@book"
-- list from https://www.bibtex.com/g/bibtex-format/
Entry_types = {
    -- lowercase
    "article", "book", "booklet", "conference", "inbook", "incollection", "inproceedings", "manual", "mastersthesis", "misc", "phdthesis",
    "proceedings", "techreport", "unpublished", -- uppercase
    "ARTICLE", "BOOK", "BOOKLET", "CONFERENCE", "INBOOK", "INCOLLECTION", "INPROCEEDINGS", "MANUAL", "MASTERSTHESIS", "MISC", "PHDTHESIS",
    "PROCEEDINGS", "TECHREPORT", "UNPUBLISHED", -- Title case
    "Article", "Book", "Booklet", "Conference", "Inbook", "Incollection", "Inproceedings", "Manual", "Mastersthesis", "Misc", "Phdthesis",
    "Proceedings", "Techreport", "Unpublished"
}

local id_pattern = "%s*@%a*%s*{%s*([%w_]*)%s*,"
local title_start_pattern = '^%s*title%s*=%s[{"]'
local title_end_pattern = '[}"]%s*,%s*$'

local ids = {}
local titles = {}

local function read_lines_from(file)
    local lines = {}
    for line in io.lines(file) do lines[#lines + 1] = line end
    return lines
end

local function get_title(line)
    local _, title_start_index = string.find(line, title_start_pattern)
    local title_end_index = string.find(line, title_end_pattern)

    -- NOTE: whitespaces can occur between the words in  any number (even 0 is possible)
    if title_start_index ~= nil and title_end_index ~= nil then
        -- line = string.sub(line, a, b)
        line = string.sub(line, title_start_index + 1, title_end_index - 1)
        return line
    end
    return nil
end

local function get_id(line)
    local _, _, id = string.find(line, id_pattern)
    return id -- nil if the id was not found
end

local function detect_entry(lines)
    for i = 1, #lines do
        for j = 1, #Entry_types do
            if string.find(lines[i], "@" .. Entry_types[j]) then
                --[[
        TODO:
        if there are more id-s, that title-s,
        then a title for the previous id could not be found,
        so an empty string should be inserted in the title's table
        ]] --
                -- search for id
                local _, _, id = string.find(lines[i], id_pattern)
                if id ~= nil then
                    ids[#ids + 1] = id
                else
                    local title = get_title(lines[i])
                    if title ~= nil then
                        if #ids > #titles then titles[#titles + 1] = '<title-not-found>' end
                        titles[#titles + 1] = title
                    end
                end
                -- print(lines[i])
                break
            end
        end
    end
end

-- TESTING
Lines = read_lines_from(Bib_file)
detect_entry(Lines)
print(#ids, #titles)

if #ids == #titles then for i = 1, #titles do print(ids[i] .. ':  ' .. titles[i]) end end

local function get_ids_and_titles(lines)
    local ids_table = {}
    local titles_table = {}

    -- iterate through lines
    for i = 1, #lines do
        local line = lines[i]
        local id = get_id(line)
        if id == nil then
            local title = get_title(line)
            if title ~= nil then print(title) end
        else
            print(id)
        end
    end
end

get_ids_and_titles(Lines)

print(get_title('title = {Infinite {Dimensional} Analysis},'))
print(get_title('title = "Infinite Dimensional Analysis",'))
