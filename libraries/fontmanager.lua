if not isfile or not writefile or not delfile or not getcustomasset then error("executor not supported") return end

local fontmanager = {}

local Http = game:GetService("HttpService")

local function RegisterFont(Name: string, Asset)
    local Id = Asset.Id
    if isfile(Id) then return end
    writefile(Id, Asset.Font)
    local Data = {
        name = Name,
        faces = {
            {
                name = "Regular",
                weight = 200,
                style = normal,
                assetId = getcustomasset(Id),
            },
        },
    }
    writefile(Id, Http:JSONEncode(Data))
    return getcustomasset(Id);
end

function fontmanager.create(name)
    local fontdata = game:HttpGet("https://raw.githubusercontent.com/Neural0/base64fonts/main/" .. name)
    if not fontdata then error("name not found in repository") end

    local font = Font.new(RegisterFont({
        Id = name .. ".ttf",
        Font = crypt.base64.decode(fontdata)
    }))

    return font
end
function fontmanager.delete(name)
    if not isfile(name .. ".ttf") then error("no file found") end
    delfile(name .. ".ttf")
end

return fontmanager
