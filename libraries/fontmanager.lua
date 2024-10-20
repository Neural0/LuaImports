if not isfile or not writefile or not delfile or not getcustomasset then error("executor not supported") return end

local fontmanager = {}

local HttpService = cloneref(game:GetService("HttpService"));
local function register(Name, Asset)
    if not isfile(Asset.Id) then writefile(Asset.Id, Asset.Font) end

    local Data = {
        name = Name,
        faces = {{
            name = "Regular",
            weight = 400,
            style = "normal",
            assetId = getcustomasset(Asset.Id)
        }}
    }
    
    writefile(Name .. ".font", HttpService:JSONEncode(Data))
    return getcustomasset(Name .. ".font")
end

function fontmanager.create(name)
	local decoded = request({Url = "https://raw.githubusercontent.com/neuralls/Lutra/refs/heads/main/Fonts/" .. name}).Body
    local font = register(name,{
        Id = name .. ".ttf", Font = crypt.base64.decode(decoded)
    })
end
function fontmanager.get(Name)
    if isfile(Name .. ".font") then
        return Font.new(getcustomasset(Name .. ".font"))
    else warning("Font" .. Name .. "Not Found")
    end;
end

return fontmanager
