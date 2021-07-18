--[[
STRATEGY
Assumptions:
  - properly formatted bibtex file

1. read the lines of the input file into a variable
2. loop through the lines and find an id
  - if an id is found: search for title
  - if a title is not found continue the search for an id
  - if there are no more lines: exit the process
Patterns:
_, _, id = string.find(S, "%s*@%a*%s*{%s*([%w_]*)%s*,")
_, _, title = string.find(S_title, "%s*title%s*=%s*{%s*([%w%s-,_%+%%:\"'!/%.%?]+)%s*}")
]] --
-- get all lines from the bib file
local function lines_from(file)
    local lines = {}
    for line in io.lines(file) do lines[#lines + 1] = line end
    return lines
end

-- WARNING: The function below is incomplete!
local function get_ids_and_titles(lines)
    local ids = {}
    local titles = {}

    --[[
    current_line: int - the line we're currently processing
    lines: table - contains the lines of the bibtex file
  ]] --
    -- TODO:  use the line id to iterate
    -- search for an id or title
    for i = 1, #lines do
        _, _, Id = string.find(lines[i], "%s*@%a*%s*{%s*([%w_]*)%s*,")
        if Id ~= nil then
            if #ids > #titles then titles[#titles + 1] = "" end
            -- save the id
            ids[#ids + 1] = Id
        else
            local title_pattern = "%w%s-,_%+%%:\"'!/%.%?{}"
            _, _, Title = string.find(lines[i], "%s*title%s*=%s*{([" .. title_pattern .. "]+)%s*}")
            if Title ~= nil then
                -- save the title
                titles[#titles + 1] = Title
            end
        end
    end

    if #ids > #titles then titles[#titles + 1] = "" end

    return ids, titles
end

-- format lines for output
local function generate_output(ids, titles)

    local output = {}
    for i = 1, #ids do output[i] = i .. ". " .. ids[i] .. ": " .. titles[i] end

    for i = 1, #output do print(output[i]) end
    return output
end

-- ask for input and handle it
local function get_papers(bibfile)
    local lines = lines_from(bibfile)
    local ids, titles = get_ids_and_titles(lines)

    -- print the list of papers
    generate_output(ids, titles)
    -- ask for input
    local choice = vim.fn.input("Please choose a number (leave it empty to cancel): ", "")

    local chosen_id = ""

    if tonumber(choice) and tonumber(choice) >= 1 and tonumber(choice) <= #ids then chosen_id = ids[tonumber(choice)] end

    return chosen_id

end

return {get_papers = get_papers}

-- Lines = Lines_from(Bib_path) -- got the lines for this file

-- Ids, Titles = Get_ids_and_titles(Lines)

-- Get_papers()
