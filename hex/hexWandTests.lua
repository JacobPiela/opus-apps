print("Loading hex.wand")
local hex = require('hex.wand')

print("running get lock")
hex.getLock()
print("wand locked")


print("testing hex.cast with number 1")
print(textutils.serialize(hex.cast(
    {
        {
            angles = "aqaaw",
            ["iota$serde"] = "hextweaks:pattern",
            startDir = "SOUTH_EAST"
        },
        ["iota$serde"] = "hextweaks:list"
    }
)))



print("testing hex.runPattern with number 2")
hex.runPattern('SOUTH_EAST','aqaaww')
print(hex.popStack())


print("testing hex.getMedia depends on hexical")
print(hex.getMedia())



print("testing hex.getPos")
print(textutils.serialize(hex.getPos()))




print("testing hex.iotaserde")
print(textutils.serialize(hex.iotaserde(
    {
        {
            angles = "aqaaw",
            startDir = "SOUTH_EAST"
        }
    }
)))



print("testing hex.deIotaserde")
print(textutils.serialize(hex.deIotaserde(
    {
        {
            angles = "aqaaw",
            ["iota$serde"] = "hextweaks:pattern",
            startDir = "SOUTH_EAST"
        },
        ["iota$serde"] = "hextweaks:list"
    }
)))

print("testing hex.compile")
print(textutils.serialize(hex.compile("Mind's Reflection\nCompass' Purification\n")))


print("testing hex.runHexFile")
print(textutils.serialize(hex.runHexFile("/test.hex")))


print("testing hex.runPatternFile")
print(textutils.serialize(hex.runPatternFile("/test.hexpattern")))

print("running free lock")
hex.freeLock()
