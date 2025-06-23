local hex = require('hex.wand')
local UI       = require('opus.ui')
local Util     = require('opus.util')

local activeSpell = {}
local activeSpellName = ""
local activeSpellType

local actitons = {}




local page = UI.Page {
	add = UI.Button {
		x = 2, y = -3,
		text = ' + ',
		event = 'action',
		help = 'Install or update',
	},
	updateall = UI.Button {
		ex = -2, y = -3, width = 12,
		text = 'Update All',
		event = 'updateall',
		help = 'Update all installed packages',
	},
	description = UI.TextArea {
		x = 16, y = 3, ey = -5,
		marginRight = 2, marginLeft = 0,
	},
	UI.Checkbox {
		x = 3, y = -5,
		label = 'Compress',
		textColor = 'yellow',
		backgroundColor = 'primary',
		value = config.compression,
		help = 'Compress packages (experimental)',
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

	elseif event.type == 'checkbox_change' then
		config.compression = not config.compression
		Config.update('package', config)
	elseif event.type == 'quit' then
		UI:quit()
    else
        page.statusBar:setStatus(event.type)
        page:sync()
	end
	UI.Page.eventHandler(self, event)
end

UI:setPage(page)
page.statusBar:setStatus('loading...')
page:sync()

UI:start()