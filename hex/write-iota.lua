local args = {...}
local spell = {}

local Util     = require('opus.util')

if args[1] then
    print("Reading file...")
    local path = shell.resolve(args[1])
    local f = Util.readFile(path, 'rb')
    if not f then
        print('Failed to open file')
		return 1
	end
    if not not path:match(".hex$") then
        print("Compiling hex")
        require('hexmanager/hexconvert')
        local status
        status,spell = pcall(function()
            local processing_environment = { current_file_path = path }
            return HexConvert.compile(f, processing_environment)
        end)
        if status then
            print('Compiled hex program.')
        else
            print('Error: '.. spell)
            return 1
        end
    else
        spell = textutils.unserialize(f)
    end

    print("Writing spell...")
    local wand = peripheral.find("wand")
    if wand then
        local hex = require('hex.wand')
        hex.getLock()
        hex.pushStack(hex.iotaserde(spell))
        hex.runPattern("EAST","deeeee")
        hex.freeLock()
    else
        local focal_port = peripheral.find('focal_port')
        if not focal_port then error("Need a wand or focal port connected") end
        iota = focal_port.writeIota(spell)
    end
    print("Done")
else
    error("No input file selected")
end

