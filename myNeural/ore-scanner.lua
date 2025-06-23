local modules = peripheral.find("neuralInterface")
if not modules then error("Must have a neural interface", 0) end
if not modules.hasModule("plethora:scanner") then error("The block scanner is missing", 0) end
if not modules.hasModule("plethora:glasses") then error("The overlay glasses are missing", 0) end

local scanInterval = 0.2
local renderInterval = 0.05
local scannerRange = 8
local scannerWidth = scannerRange * 2 + 1
local size = 0.3
local cellSize = 16
local width, height = modules.canvas().getSize()
local offsetX = width - 50
local offsetY = 50
 
local ores = {
    ["minecraft:lava"] = 0.9,

    ["minecraft:budding_amethyst"] = 6.1,
    ["spectrum:budding_moonstone"] = 6.2,
    ["spectrum:budding_citrine"] = 6.3,
    ["lootr:lootr_chest"] = 16,
    ["lootr:lootr_barrel"] = 17,

    ["minecraft:nether_quartz_ore"] = 1,
    ["minecraft:nether_gold_ore"] = 2,
    ["minecraft:ancient_debris"] = 3,

    ["minecraft:coal_ore"] = 4,
    ["minecraft:copper_ore"] = 4.1,
    ["minecraft:lapis_ore"] = 5,
    ["minecraft:redstone_ore"] = 6,
    ["minecraft:iron_ore"] = 7,
    ["minecraft:gold_ore"] = 8,
    ["minecraft:diamond_ore"] = 9,

    ["minecraft:deepslate_coal_ore"] = 10,
    ["minecraft:deepslate_copper_ore"] = 4.1,
    ["minecraft:deepslate_lapis_ore"] = 11,
    ["minecraft:deepslate_redstone_ore"] = 12,
    ["minecraft:deepslate_iron_ore"] = 13,
    ["minecraft:deepslate_gold_ore"] = 14,
    ["minecraft:deepslate_diamond_ore"] = 15
}
 
local colours = {
    ["minecraft:lava"] = { 150, 75, 0 },

    ["minecraft:budding_amethyst"] = { 136, 0, 255},
    ["spectrum:budding_moonstone"] = { 136, 0, 255 },
    ["spectrum:budding_citrine"] = { 136, 0, 255 },
    ["lootr:lootr_chest"] = { 0, 0, 0 },
    ["lootr:lootr_barrel"] = { 0, 0, 0 },

    ["minecraft:nether_quartz_ore"] = { 200, 200, 200},
    ["minecraft:nether_gold_ore"] = { 255, 255, 0 },
    ["minecraft:ancient_debris"] = { 71, 34, 3},

    ["minecraft:coal_ore"] = { 150, 150, 150 },
    ["minecraft:copper_ore"] = { 255, 154, 69 },
    ["minecraft:lapis_ore"] = { 0, 50, 255 },
    ["minecraft:redstone_ore"] = { 255, 0, 0 },
	["minecraft:iron_ore"] = { 255, 150, 50 },
	["minecraft:gold_ore"] = { 255, 255, 0 },
	["minecraft:diamond_ore"] = { 0, 255, 255 },

    ["minecraft:deepslate_coal_ore"] = { 150, 150, 150 },
    ["minecraft:deepslate_copper_ore"] = { 255, 154, 69 },
	["minecraft:deepslate_iron_ore"] = { 255, 150, 50 },
	["minecraft:deepslate_gold_ore"] = { 255, 255, 0 },
	["minecraft:deepslate_diamond_ore"] = { 0, 255, 255 },
	["minecraft:deepslate_redstone_ore"] = { 255, 0, 0 },
	["minecraft:deepslate_lapis_ore"] = { 0, 50, 255 }
}
 
 
local canvas = modules.canvas()
canvas.clear()
 
local block_text = {}
local blocks = {}
for x = -scannerRange, scannerRange, 1 do
    block_text[x] = {}
    blocks[x] = {}
    
    for z = -scannerRange, scannerRange, 1 do
        block_text[x][z] = canvas.addText({ 0, 0 }, " ", 0xFFFFFFFF, size)
        blocks[x][z] = { y = nil, block = nil }
    end
end
 
canvas.addText({ offsetX, offsetY }, "^", 0xFFFFFFFF, size * 2)
local function scan()
    while true do
        local scanned_blocks = modules.scan()
        for x = -scannerRange, scannerRange do
            for z = -scannerRange, scannerRange do
                local best_score, best_block, best_y = -1
                for y = -scannerRange, scannerRange do
                    local scanned = scanned_blocks[scannerWidth ^ 2 * (x + scannerRange) + scannerWidth * (y + scannerRange) + (z + scannerRange) + 1]
                    if scanned then
                        local new_score = ores[scanned.name]
                        if new_score and new_score > best_score then
                            best_block = scanned.name
                            best_score = new_score
                            best_y = y
                        end
                    end
                end
                
                blocks[x][z].block = best_block
                blocks[x][z].y = best_y
            end
        end
        
        sleep(scanInterval)
    end
end
 
local function render()
    while true do
        local meta = modules.getMetaOwner and modules.getMetaOwner()
        local angle = meta and math.rad(-meta.yaw % 360) or math.rad(180)
        for x = -scannerRange, scannerRange do
            for z = -scannerRange, scannerRange do
                local text = block_text[x][z]
                local block = blocks[x][z]
                
                if block.block then
                    local px = math.cos(angle) * -x - math.sin(angle) * -z
                    local py = math.sin(angle) * -x + math.cos(angle) * -z
                    
                    local sx = math.floor(px * size * cellSize)
                    local sy = math.floor(py * size * cellSize)
                    text.setPosition(offsetX + sx, offsetY + sy)
                    text.setText(tostring(block.y))
                    text.setShadow(true)
                    text.setColor(table.unpack(colours[block.block]))
                else
                    text.setText(" ")
                end
            end
        end
        sleep(renderInterval)
    end
end
 
parallel.waitForAll(render, scan)
                    