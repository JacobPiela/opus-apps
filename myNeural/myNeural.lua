local hex = require('hex.wand')
local UI       = require('opus.ui')
local Util     = require('opus.util')
local Config   = require('opus.config')

local modules = peripheral.find("neuralInterface")
if not modules then error("Must have a neural interface", 0) end
if not modules.hasModule("plethora:glasses") then error("The overlay glasses are missing", 0) end
if not modules.hasModule("plethora:scanner") then error("The block scanner is missing", 0) end

local config = Config.load('myNeural')

local canvas = modules.canvas()
local width, height = canvas.getSize()
canvas.clear()

local libraryPos = { ["iota$serde"] = "hextweaks:vec3", x=-2271.5, y=69.5, z=-1668.5}

local scanInterval = 0.2
local renderInterval = 0.05
local scannerRange = 8
local scannerWidth = scannerRange * 2 + 1
local size = 0.3
local cellSize = 16
local offsetX = width - 50
local offsetY = 50
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
local mapPointer = canvas.addText({ offsetX, offsetY }, " ", 0xFFFFFFFF, size * 2)


config.mapEnabled = config.mapEnabled or false

config.mapOres = config.mapOres or false
config.mapChests = config.mapChests or false
config.mapChrystals = config.mapChrystals or false
config.mapLava = config.mapLava or false

Config.update('myNeural', config)


local scanBlocks = {}

function updateBlockList()
	scanBlocks = {}
	if config.mapOres then
		scanBlocks["minecraft:nether_quartz_ore"] = 1
		scanBlocks["minecraft:nether_gold_ore"] = 2
		scanBlocks["minecraft:ancient_debris"] = 3

		scanBlocks["minecraft:coal_ore"] = 4
		scanBlocks["minecraft:copper_ore"] = 4.1
		scanBlocks["minecraft:lapis_ore"] = 5
		scanBlocks["minecraft:redstone_ore"] = 6
		scanBlocks["minecraft:iron_ore"] = 7
		scanBlocks["minecraft:gold_ore"] = 8
		scanBlocks["minecraft:diamond_ore"] = 9

		scanBlocks["minecraft:deepslate_coal_ore"] = 10
		scanBlocks["minecraft:deepslate_copper_ore"] = 4.1
		scanBlocks["minecraft:deepslate_lapis_ore"] = 11
		scanBlocks["minecraft:deepslate_redstone_ore"] = 12
		scanBlocks["minecraft:deepslate_iron_ore"] = 13
		scanBlocks["minecraft:deepslate_gold_ore"] = 14
		scanBlocks["minecraft:deepslate_diamond_ore"] = 1
	end
	if config.mapChests then
		scanBlocks["lootr:lootr_chest"] = 16
		scanBlocks["lootr:lootr_barrel"] = 17
	end
	if config.mapChrystals then
		scanBlocks["minecraft:budding_amethyst"] = 6.1
		scanBlocks["spectrum:budding_moonstone"] = 6.2
		scanBlocks["spectrum:budding_citrine"] = 6.3
	end
	if config.lava then
		scanBlocks["minecraft:lava"] = 0.9
	end

end
updateBlockList()

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



local activeSpell = config.activeSpell or "none"
local activeSpellType = config.activeSpellType or "none"

local actitons = {
	mineores = function()
		if config.mapEnabled then
			local blocksToBrake = {}
			for x = -scannerRange, scannerRange do
				for z = -scannerRange, scannerRange do
					local block = blocks[x][z]		
					if block.block then
						table.insert(blocksToBrake, { ["iota$serde"] = "hextweaks:vec3", x=x, y=block.y, z=z})
					end
				end
			end
			blocksToBrake["iota$serde"]="hextweaks:list"
			hex.clearStack()
			hex.pushStack(libraryPos)
			hex.pushStack({
					angles = "ddqaawq",
					["iota$serde"] = "hextweaks:pattern",
					startDir = "EAST"
				})
			hex.runPattern("WEST","qqqwqqqqqaq")
			hex.pushStack(hex.iotaserde({
				{angles = "qaq",startDir = "SOUTH_WEST"},
				{angles = "aa",startDir = "SOUTH_WEST"},
				{angles = "waaw",startDir = "NORTH_EAST"},
				{angles = "aadaa",startDir = "EAST"},
				{angles = "qaqqqqq",startDir = "EAST"},
				{angles = "qqq",startDir = "WEST"},
				{angles = "qaqeede",startDir = "WEST"},
				{angles = "eee",startDir = "EAST"},
				{angles = "aawdd",startDir = "EAST"},
				{angles = "aqaaw",startDir = "SOUTH_EAST"},
				{angles = "qqqqqwdeddww",startDir = "SOUTH_EAST"},
				{angles = "dadad",startDir = "NORTH_EAST"}
			}))
			hex.pushStack(blocksToBrake)
			hex.runPattern("NORTH_EAST","dadad")
			hex.runPattern("SOUTH_EAST","a")
			hex.runPattern("WEST","qqqwwqqqwqqawdedw")
		end
	end
}

--media total setup
local mediaText = canvas.addGroup({ 0, 0 })
mediaText.addRectangle(0, 0, 110, 30, 0xAA00FFAA)

local activeSpellName = mediaText.addText({ 5, 5 }, "Spell: none")
activeSpellName.setScale(1)
local mediaTotal = mediaText.addText({ 5, 20 }, "")
mediaTotal.setScale(1)

mediaText.setPosition(width - 110, height - 30)


local programRunning = true

local page = UI.Page {
	add = UI.Button {
		x = 2, y = -3,
		text = ' + ',
		event = 'action',
		help = 'Install or update',
	},
	UI.Checkbox {
		x = -15, y = 2,
		label = 'Map Enable',
		textColor = 'yellow',
		backgroundColor = 'primary',
		value = config.mapEnabled,
		event = "mapOn",
		help = 'Enable/Disable miniMap',
	},
	UI.Checkbox {
		x = -15, y = 4,
		label = 'Ores',
		textColor = 'yellow',
		backgroundColor = 'primary',
		value = config.mapOres,
		event = "oresOn",
		help = 'Enable/Disable ore view',
	},
	UI.Checkbox {
		x = -15, y = 6,
		label = 'Chests',
		textColor = 'yellow',
		backgroundColor = 'primary',
		value = config.mapChests,
		event = "chestsOn",
		help = 'Enable/Disable chest view',
	},
	UI.Checkbox {
		x = -15, y = 8,
		label = 'Chrystals',
		textColor = 'yellow',
		backgroundColor = 'primary',
		value = config.mapChrystals,
		event = "chrystalsOn",
		help = 'Enable/Disable chrystal view',
	},
	UI.Checkbox {
		x = -15, y = 10,
		label = 'Lava',
		textColor = 'yellow',
		backgroundColor = 'primary',
		value = config.mapLava,
		event = "lavaOn",
		help = 'Enable/Disable lava view',
	},
	action = UI.SlideOut {
		titleBar = UI.TitleBar {
			event = 'hide-action',
		},
		button = UI.Button {
			x = -10, y = 3,
			text = ' Begin ', event = 'begin',
		},
		output = UI.Embedded {
			y = 5, ey = -2, x = 2, ex = -2,
			visible = true,
		},
	},
	statusBar = UI.StatusBar { },
	accelerators = {
		[ 'control-q' ] = 'quit',
	},
}


function page:eventHandler(event)
	if event.type == 'focus_change' then
		self.statusBar:setStatus(event.focused.help)

	elseif event.type == 'mapOn' then
		config.mapEnabled = not config.mapEnabled
		Config.update('myNeural', config)
		if config.mapEnabled then
			mapPointer.setText("^")
		else
			mapPointer.setText(" ")
			for x = -scannerRange, scannerRange do
				for z = -scannerRange, scannerRange do
					local text = block_text[x][z]
					text.setText(" ")
				end
			end
		end
	elseif event.type == 'oresOn' then
		config.mapOres = not config.mapOres
		Config.update('myNeural', config)
		updateBlockList()
	elseif event.type == 'chestsOn' then
		config.mapChests = not config.mapChests
		Config.update('myNeural', config)
		updateBlockList()
	elseif event.type == 'chrystalsOn' then
		config.mapChrystals = not config.mapChrystals
		Config.update('myNeural', config)
		updateBlockList()
	elseif event.type == 'lavaOn' then
		config.mapLava = not config.mapLava
		Config.update('myNeural', config)
		updateBlockList()
	elseif event.type == 'quit' then
		programRunning = false
		canvas.clear()
		hex.freeLock()
		UI:quit()
	end
	UI.Page.eventHandler(self, event)
end


function uiUpdate()
	UI:setPage(page)
	page.statusBar:setStatus('loading...')
	page:sync()

	UI:start()
end


function keyInput()
	while programRunning do
		local event, key, isHeld = os.pullEvent("key")

		if key == 81 and not isHeld then
            hex.getLock()
            if activeSpellType == "action" then
				activeSpell()
			elseif activeSpellType == "hex" then
				hex.runHexFile("/spells/"..activeSpell)
			elseif activeSpellType == "hexpattern" then
				hex.runPatternFile("/spells/"..activeSpell)
			end
            hex.freeLock()
        end
    end
end


local interval = 0.5
local intervalCounter = 0
function intervalUpdate()
	while programRunning do
		hex.getLock()
		--chat casting
		hex.runPattern("EAST","waqa")--whisper reflection
		local msg = hex.popStack()
		msg = "mineores.action"
		--msg = "brake-block.hexpattern"
		if not not msg:match(".action$")then
			msg = string.sub(msg,1,string.len(msg)-7)
			if actitons[msg] then
				activeSpell = actitons[msg]
				activeSpellType = "action"
				activeSpellName.setText("Spell: ".. msg)
			end
		elseif not not msg:match(".hex$")then
			activeSpell = msg
			config.activeSpell = msg
			activeSpellType = "hex"
			config.activeSpellType = "hex"
			activeSpellName.setText("Spell: ".. string.sub(msg,1,string.len(msg)-3))
			Config.update('myNeural', config)
		elseif not not msg:match(".hexpattern$")then
			activeSpell = msg
			config.activeSpell = msg
			activeSpellType = "hexpattern"
			config.activeSpellType = "hexpattern"
			activeSpellName.setText("Spell: ".. string.sub(msg,1,string.len(msg)-11))
			Config.update('myNeural', config)
		end

		--slow updates
		if intervalCounter % 5 == 1 then
			--auto breath
			local breath = hex.cast(
				{
					{angles = "qaq",["iota$serde"] = "hextweaks:pattern",startDir = "SOUTH_WEST"},--minds
					{angles = "wwaade",["iota$serde"] = "hextweaks:pattern",startDir = "EAST"},--suffocation purification
					["iota$serde"] = "hextweaks:list"
				}
			)[1]
			if breath < 150 then
                hex.runPattern("SOUTH_WEST","qaq")--minds
                hex.runPattern("NORTH_WEST","aweeeeewaweeeee")--gasp
            end

			--Media display
            mediaTotal.setText("Media Total: " .. hex.getMedia())
		end

		hex.freeLock()
		intervalCounter = intervalCounter + 1
	    sleep(updatespeed)
    end
end

local function scan()
    while true do
		if config.mapEnabled and programRunning then
			local scanned_blocks = modules.scan()
			for x = -scannerRange, scannerRange do
				for z = -scannerRange, scannerRange do
					local best_score, best_block, best_y = -1
					for y = -scannerRange, scannerRange do
						local scanned = scanned_blocks[scannerWidth ^ 2 * (x + scannerRange) + scannerWidth * (y + scannerRange) + (z + scannerRange) + 1]
						if scanned then
							local new_score = scanBlocks[scanned.name]
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
		end
        sleep(scanInterval)
    end
end


local function render()
    while true do
		if config.mapEnabled and programRunning then
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
		end
        sleep(renderInterval)
    end
end

parallel.waitForAll(keyInput,uiUpdate,intervalUpdate,scan,render)