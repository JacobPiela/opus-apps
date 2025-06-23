local modules = peripheral.find("neuralInterface")
local wand = peripheral.find("wand")


if not wand then error("Must have a mindsplice staff", 0) end
if not modules then error("Must have a neural interface", 0) end

local updatespeed = 0.5
local wandlock = false
local activeSpell = {}

local spells = {
    brake_block = {
        type = "castNow",
        spell = {
            {
                startDir = "SOUTH_WEST",
                [ "iota$serde" ] = "hextweaks:pattern",
                angles = "qaq",
            },
            {
                startDir = "SOUTH_WEST",
                [ "iota$serde" ] = "hextweaks:pattern",
                angles = "aa",
            },
            {
                startDir = "SOUTH_WEST",
                [ "iota$serde" ] = "hextweaks:pattern",
                angles = "qaq",
            },
            {
                startDir = "NORTH_EAST",
                [ "iota$serde" ] = "hextweaks:pattern",
                angles = "wa",
            },
            {
                startDir = "EAST",
                [ "iota$serde" ] = "hextweaks:pattern",
                angles = "wqaawdd",
            },
            {
                startDir = "EAST",
                [ "iota$serde" ] = "hextweaks:pattern",
                angles = "qaqqqqq",
            },
            [ "iota$serde" ] = "hextweaks:list",
        }
    },
    place_block = {
        type = "castNow",
        spell = {
  {
    startDir = "SOUTH_WEST",
    [ "iota$serde" ] = "hextweaks:pattern",
    angles = "qaq",
  },
  {
    startDir = "SOUTH_WEST",
    [ "iota$serde" ] = "hextweaks:pattern",
    angles = "aa",
  },
  {
    startDir = "SOUTH_WEST",
    [ "iota$serde" ] = "hextweaks:pattern",
    angles = "qaq",
  },
  {
    startDir = "NORTH_EAST",
    [ "iota$serde" ] = "hextweaks:pattern",
    angles = "wa",
  },
  {
    startDir = "EAST",
    [ "iota$serde" ] = "hextweaks:pattern",
    angles = "wqaawdd",
  },
  {
    startDir = "SOUTH_WEST",
    [ "iota$serde" ] = "hextweaks:pattern",
    angles = "qaq",
  },
  {
    startDir = "SOUTH_WEST",
    [ "iota$serde" ] = "hextweaks:pattern",
    angles = "aa",
  },
  {
    startDir = "SOUTH_WEST",
    [ "iota$serde" ] = "hextweaks:pattern",
    angles = "qaq",
  },
  {
    startDir = "NORTH_EAST",
    [ "iota$serde" ] = "hextweaks:pattern",
    angles = "wa",
  },
  {
    startDir = "EAST",
    [ "iota$serde" ] = "hextweaks:pattern",
    angles = "weddwaa",
  },
  {
    startDir = "NORTH_EAST",
    [ "iota$serde" ] = "hextweaks:pattern",
    angles = "waaw",
  },
  {
    startDir = "SOUTH_WEST",
    [ "iota$serde" ] = "hextweaks:pattern",
    angles = "eeeeede",
  },
  [ "iota$serde" ] = "hextweaks:list",
}
    }
}

local function input()
    while true do
        local event, key, isHeld = os.pullEvent("key")
        if key == 81 and not isHeld and not wandlock then
            wandlock = true
            wand.clearStack()
            wand.pushStack(activeSpell.spell)
            wand.runPattern()
            wandlock = false
            print("casting")
        end


    end
end



local function chatcasting()
    while true do
        if not wandlock then
            wand.clearStack()
            wand.runPattern("EAST","waqa")
            msg = wand.getStack()[1]
            print(msg)
            if spells[msg] then
                print("Setting spell to "..msg)
                activeSpell = spells[msg]
            end
            sleep(updatespeed)
        else
            sleep(0)
        end
    end
end


parallel.waitForAll(chatcasting,input)