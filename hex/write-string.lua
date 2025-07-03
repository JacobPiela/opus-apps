local args = {...}
local outString = ""

if args[1] then
    for , word in ipairs(args) do
        outString = outString .. " " .. word
    end
    local wand = peripheral.find("wand")
    if wand then
        local hex = require('hex.wand')
        hex.getLock()
        hex.pushStack(outString)
        hex.runPattern("EAST","deeeee")
        hex.freeLock()
    else
        local focal_port = peripheral.find('focal_port')
        if not focal_port then error("Need a wand or focal port connected") end
        iota = focal_port.writeIota(outString)
    end
else
    error("No input String")
end

