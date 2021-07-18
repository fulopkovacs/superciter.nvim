# Test lua patterns

## Setup

```lua
S = "@article{something_2222,"
S_title = "  title={Processing capacity: \"and\" the's frontal P3!?.},"
print(S)
print(S_title)
```

## Find pattern

```lua
string.find(S, "@%l*")
```

```lua
pair = "name = Anna"
_, _, key, value = string.find(pair, "(%a+)%s*=%s*(%a+)")
print(key, value)
```

### Find ids

```lua
--[[

EXPLANATION
`*` 0 or more repetitions
`%a` letters
`%s` space character
`()` capture group
`[]` char set (anything that is in the set)

]]--
_, _, id = string.find(S, "%s*@%a*%s*{%s*([%w_]*)%s*,")
print(id)
```

### Find titles

```lua
_, _, title = string.find(S_title, "%s*title%s*=%s*{%s*([%w%s-,_%+%%:\"'!/%.%?]+)%s*}")
print(title)
```

```lua
Hard_title = "  title={Animal and human faces in natural scenes: How specific to human faces is the N170 {ERP} component?}"
-- title_pattern = "%w:,%?%+%*%- {}"
title_pattern = "%w%s-,_%+%%:\"'!/%.%?{}"

_, _, hard_title = string.find(Hard_title, "%s*title={([" .. title_pattern .. "]+)%s*}")
print(hard_title)
```

## Lists

```lua
Titles = {}
Titles[0] = "hello"
print(Titles[0])
```

### iterate through lines

```lua
for i=1,#Lines do
  print(lines)
end
```
