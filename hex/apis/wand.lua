local wand = _G.peripheral.find('wand')
local hexmanager = require('hexmanager/hexconvert')

if not wand then
    error('No mind splice staff installed')
end


if not _G.wandLock then
    _G.wandLock = false
end

local Hex = {
    _TYPE='module',
    _NAME='hex.wand',
    _VERSION='0.1.0',
    patterns = patterns
}

function Hex.getLock()
    local timeout = os.startTimer(7)
    while _G.wandLock do
        event, id = os.pullEvent()
        if event == "timer" and id == timeout then
            _G.wandLock = false
            error('Wand timeout are too many apps tyring to use it')
        end
    end
    os.cancelTimer(timeout)
    _G.wandLock = true
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

function Hex.runPattern(arg1,arg2,arg3)
    return wand.runPattern(arg1,arg2,arg3)--TODO check count works
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
    return Hex.cast({angles = "ddew",["iota$serde"] = "hextweaks:pattern",startDir = "WEST"})[1]--? test this
end

function Hex.getPos()--TODO test
    wand.pushStack({
        {angles = "qaq",["iota$serde"] = "hextweaks:pattern",startDir = "SOUTH_WEST"},
        {angles = "aa",["iota$serde"] = "hextweaks:pattern",startDir = "SOUTH_WEST"},
        ["iota$serde"] = "hextweaks:list"
    })
    wand.runPattern()
    return wand.popStack()
end

function Hex.iotaserde(spell)--TODO test
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
        end
    end

    return spell
end

function Hex.deIotaserde(spell)--TODO test
    for key, iota in ipairs(spell) do
        if key == "iota$serde" then
            iota = nil
        elseif type(iota) == "table" then
            Hex.iotaserde(iota)
        end
    end

    return spell
end


return Hex
