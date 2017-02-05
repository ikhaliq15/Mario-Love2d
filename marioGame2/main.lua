local AdvTiledLoader = require("libs/AdvTiledLoader.Loader")
require("libs/camera")
require "libs/boundary"
require "dll/Menu"
require "dll/Input"
require "dll/Player"
require "dll/Map"
require "dll/Utility"
require "dll/tileEditor"
require "dll/tileEditor2"
require "dll/tileLoader"


function love.load()
	loadUtility() -- state is defined in loadUtility
	loadJoystick()
 	loadMenu()
	loadPlayer()
	loadWorld()
	loadMap()
end

function love.update(dt)
	if state == "menu" then
		updateMenu()
	end
	if state == "play" then
		loadMap();
		loadWorld();
		updatePlay(dt)
	end
	if state == "editMenu" or state == "edit" then
		updateTileLoader(dt)
	end
end

function love.draw()
	if state == "play" then
		drawPlay()
		print("PLAY")
	end
	if state == "menu" then
		drawMenu()
	end
	if state == "create" then
		drawTileEditor();
		isTileItemColliding();
	end
	if state == "editMenu" or state == "edit" then
		drawTileLoader();
	end
end