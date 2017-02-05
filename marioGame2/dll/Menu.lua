require "dll/tileEditor"
function loadMenu()
	-- Load all the menu stuff.
 	logo = love.graphics.newImage("gfx/THEINTERWEB.png");
	play = love.graphics.newImage("gfx/PLAYGAME.png");
	createMap = love.graphics.newImage("gfx/CREATEMAP.png");
	editMap = love.graphics.newImage("gfx/EDITMAP.png");
	help = love.graphics.newImage("gfx/HELP.png");
	selector = love.graphics.newImage("gfx/SELECTOR.png");
	menu = love.graphics.newImage("gfx/MENU.png")
	itmsX = love.graphics.getWidth()/2 - 85;--menu selection's xcord
	selectY = love.graphics.getHeight()/2 - logo:getHeight() + 40;--selector's y cord
	selectTb = {selectY, selectY + 35, selectY + 70, selectY + 105}
	selectPos = 1
end

function updateMenu()
	loadKeyBoard();
	if love.keyboard.isDown("return") then
		if selectPos == 1 then
			state = "play"
		end
		if selectPos == 2 then
			love.graphics.setBackgroundColor(255,255,255);
			state = "create"
			success = love.window.setMode(25*32, 19*32)
			loadTileEditor();	
		end
	end

end

function drawMenu()
	love.graphics.draw(menu);
	love.graphics.draw(logo, love.graphics.getWidth()/2 - 15, love.graphics.getHeight()/2 - logo:getHeight() + 15);
	love.graphics.draw(play, itmsX, love.graphics.getHeight()/2 - logo:getHeight() + 45); --increments by 35pxs
	love.graphics.draw(createMap, itmsX, love.graphics.getHeight()/2 - logo:getHeight() + 80);
	love.graphics.draw(editMap, itmsX, love.graphics.getHeight()/2 - logo:getHeight() + 115);
	love.graphics.draw(help, itmsX, love.graphics.getHeight()/2 - logo:getHeight() + 150);
	love.graphics.draw(selector, itmsX - 35, selectTb[selectPos]);
end