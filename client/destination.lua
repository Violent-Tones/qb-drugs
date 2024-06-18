local Utils = exports['violent-utils']:GetCoreObject()
local blip
local mission
SetThisScriptCanRemoveBlipsCreatedByAnyScript(true)
function Destination(text, coords)
    if blip then
        RemoveBlip(blip)
    end
    if not text then
        return
    end
    blip = Utils.Blip:CreateBlip({
        coords = coords,
        title = text,
        sprite = 1,
        display = 4,
        colour = 5,
        scale = 0.75,
    })
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 5)
    return blip
end
