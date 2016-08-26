local AdvTiledLoader = require("libs/AdvTiledLoader.Loader")
require("libs/camera")
require "libs/boundary"
require "dll/Menu"
require "dll/Input"
require "dll/Player"
require "dll/Map"
require "dll/Utility"
require "dll/tileEditor"

function love.load()
	loadUtility()
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
		updatePlay(dt)
	end
end

function love.draw()
	if state == "play" then
		drawPlay()
	end
	if state == "menu" then
		drawMenu()
	end
	if state == "create" then
		drawTileEditor();
		isTileItemColliding();
	end
end