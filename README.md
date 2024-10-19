<i> -- File management/readme inspired by hydroxide https://github.com/Upbolt/Hydroxide </i>
## Script
```lua
if webImport then return end

local owner, branch = "Neural0", "main"

local function webImport(file) return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/LuaImports/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')() end

webImport("ui/main")
```

# Lua Imports
<i> Lua code storage solutions for optimized and more readable code enthusiasts. </i>
