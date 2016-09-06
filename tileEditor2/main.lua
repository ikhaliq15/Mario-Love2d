require ("tileEditor")
function love.load( ) 
	love.filesystem.setIdentity("Converter")
	files = love.filesystem.getDirectoryItems("custom_maps")
	editFiles = {};
	mapWidth = 0;
	selectPos = 1
	itmsX = love.graphics.getWidth()/2 - 85;--menu items's xcord
	menuFont = love.graphics.newFont("image_font.ttf", fontSize)
	fontSize = 14
	mapFile = ""
	gameState = "menu"
	print(love.graphics.getHeight()/32)
	print(love.graphics.getWidth()/32)
	for k, file in ipairs(files) do
		if string.sub(file, -3) == "txt" then
			editFiles[#editFiles + 1] = string.sub(file, 1, -5);
		end
	end

	selectY = love.graphics.getHeight()/2 - fontSize * #editFiles;--selector's y cord

	for i = 1, #editFiles, 1 do
		print ("MAPFILE: " .. editFiles[i])
	end
	loadTileEditor();
	print(tileD)

	-- function love.keyreleased(key) 
	-- 	if key == "return" then
	-- 		gameState = "edit"
	-- 		mapFile = "" .. editFiles[selectPos] .. ".txt"
	-- 		loadTileEditor()
	-- 		updateSize()

	-- 	end
	-- end

end

function love.update()
	if love.keyboard.isDown("return") then
		if selectPos == 1 then
			gameState = "edit"
			loadTileEditor();
		end
	end
end

function love.draw()
	love.graphics.setFont(menuFont);

	for i = 1, #editFiles, 1 do
		love.graphics.print("MAPFILE: " .. editFiles[i], itmsX, selectY)
	end

	love.graphics.print(">", itmsX - fontSize*2, selectY + ((selectPos-1)* 70))

	if gameState == "edit" then
		drawTileEditor()
	end
end

