local iota
local args = {...}

local wand = peripheral.find("wand")
if wand then
    local hex = require('hex.wand')
    hex.getLock()
    hex.runPattern("EAST","aqqqqq")
    iota = hex.popStack()
    hex.freeLock()
    iota = hex.deIotaserde(iota)
else
    local focal_port = peripheral.find('focal_port')
    if not focal_port then error("Need a wand or focal port connected") end
    iota = focal_port.readIota()
end
if args[1] then
    print("Writing to file...")
    local file = fs.open(shell.resolve(args[1]),"w")
    if not not shell.resolve(args[1]):match(".hex$")then
        print("Decompiling hex")
        require('hexmanager/hexconvert')
        print("Decompiling hex program...")
        local status,program_lines_or_err = pcall(function()
            return HexConvert.decompile_to_lines(iota)
        end)
        if status then
            print('Decompiled hex program.')
        else
            print('Error: '..program_lines_or_err)
            return 1
        end
        for _,line in ipairs(program_lines_or_err) do
            file.writeLine(line)
        end
    else
        file.write(textutils.serialize(iota))
    end
    file.close()
    print("Done")
else
    print("Spell:")
    print(textutils.serialize(iota))
end

