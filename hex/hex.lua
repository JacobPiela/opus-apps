local wand = _G.peripheral.find('wand')
if not wand then
    error('No mind splice staff installed')
end


if not _G.wandLock then
    _G.wandLock = false
end

local Hex = {
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

function Hex.constructSpell(patternlist)--TODO
    local spell = {
        ["iota$serde"] = "hextweaks:list"
    }
    for key, pattern in ipairs(patternlist) do
        if type(pattern) == "string" and patterns[pattern] then
            spell[key] = {
                angles = patterns[pattern]["angles"],
                startDir = patterns[pattern]["startDir"],
                ["iota$serde"] = "hextweaks:pattern"
            }
        else
            spell[key] = pattern
        end
    end
    return spell
end



return Hex
