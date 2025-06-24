
local wand = _G.peripheral.find('wand')

if not wand then
    error('No mind splice staff installed')
end

local Util  = require('opus.util')
require('/packages/hex/hexmanager/hexconvert')


if not _G.wandLock then
    _G.wandLock = false
end

local Hex = {
    _TYPE='module',
    _NAME='hex.wand',
    _VERSION='0.1.0',
    patterns = patterns
}

function Hex.getLock()--broken after crash
    local timeout = os.startTimer(3)
    while _G.wandLock do
        event, id = os.pullEvent()
        if event == "timer" and id == timeout then
            _G.wandLock = false
            return false
        end
    end
    os.cancelTimer(timeout)
    _G.wandLock = true
    return true
end

function Hex.freeLock()
    wand.clearStack()
    _G.wandLock = false
    os.queueEvent("wand_unlock")
end

function Hex.cast(pattren)
    local stack
    wand.pushStack(pattren)
    wand.runPattern()
    stack = wand.getStack()
    wand.clearStack()
    return stack
end

function Hex.runPattern(...)
    return wand.runPattern(...)
end
function Hex.getStack()
    return wand.getStack()
end
function Hex.pushStack(iota)
    wand.pushStack(iota)
end
function Hex.popStack()
    return wand.popStack()
end
function Hex.clearStack()
    return wand.clearStack()
end
function Hex.setStack(iotas)
    return wand.setStack(iotas)
end
function Hex.enlightened()
    return wand.enlightened()
end

function Hex.getMedia()--depends on hexical
    return Hex.cast({{angles = "qaq",["iota$serde"] = "hextweaks:pattern",startDir = "SOUTH_WEST"},
        {angles = "ddew",["iota$serde"] = "hextweaks:pattern",startDir = "WEST"},
        ["iota$serde"] = "hextweaks:list"})[1]
end

function Hex.getPos()
    wand.pushStack({
        {angles = "qaq",["iota$serde"] = "hextweaks:pattern",startDir = "SOUTH_WEST"},
        {angles = "aa",["iota$serde"] = "hextweaks:pattern",startDir = "SOUTH_WEST"},
        ["iota$serde"] = "hextweaks:list"
    })
    wand.runPattern()
    return wand.popStack()
end

function Hex.iotaserde(spell)
    if type(spell) == "table" then
        if spell["angles"] then
            spell["iota$serde"] = "hextweaks:pattern"
        elseif spell["x"] then
            spell["iota$serde"] = "hextweaks:vec3"
        elseif spell["uuid"] then
            spell["iota$serde"] = "hextweaks:entity"
        else
            for key, iota in ipairs(spell) do
                    Hex.iotaserde(iota)
            end
            spell["iota$serde"] = "hextweaks:list"
        end
    end

    return spell
end

function Hex.deIotaserde(spell)
    if type(spell) == "table" then
        if spell["iota$serde"] then
            spell["iota$serde"] = nil
        end
        for key, iota in ipairs(spell) do
            Hex.deIotaserde(iota)
        end
    end
    return spell
end


function Hex.compile(spell)
    return HexConvert.compile(spell)
end

function Hex.runHexFile(file)
    local f = Util.readFile(file, 'rb')
    if not f then
		return false
	end
    local spell = HexConvert.compile(f)
    spell = Hex.iotaserde(spell)
    return Hex.cast(spell)
end

function Hex.runPatternFile(file)
    local f = Util.readFile(file, 'rb')
    if not f then
		return false
	end
    spell = Hex.iotaserde(textutils.unserialize(f))
    return Hex.cast(spell)
end

return Hex
