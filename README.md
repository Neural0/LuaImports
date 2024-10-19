## Script
```lua
if Import then return end

local owner, branch = "Neural0", "main"

function Import(file) return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/LuaImports/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')() end

Import("ui/main")
```
<i> Lua code storage solutions for optimized and more readable code enthusiasts. </i>
