local iota
local args = {...}

local wand = peripheral.find("wand")
if wand then
    local hex = require('hex.wand')
    hex.getLock()
    hex.runPattern("EAST","aqqqqq")
    iota = hex.popStack()
    hex.freeLock()
else
    local focal_port = peripheral.find('focal_port')
    if not focal_port then error("Need a wand or focal port connected") end
    iota = focal_port.readIota()
end
if args[1] then
    print("Writing to file...")
    local file = fs.open(shell.resolve(args[1]),"w")
    file.write(textutils.serialize(iota))
    file.close()
    print("Done")
else
    print(textutils.serialize(iota))
end

