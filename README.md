## Script
```lua
if Import then return end

local owner, branch = "Neural0", "main"

function Import(file) return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Lutra/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')() end
```
<i> Lua code storage solutions for optimized and more readable code enthusiasts. </i>
