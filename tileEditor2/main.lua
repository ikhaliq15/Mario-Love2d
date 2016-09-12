require ("tileEditor")
require("converter")
function love.load( ) 
	love.filesystem.setIdentity("Converter")
	files = love.filesystem.getDirectoryItems("custom_maps")
	backGroundImage = love.graphics.newImage("editMenu.png")
	editFiles = {};
	mapWidth = (love.graphics.getWidth()*2)/32
	selectPos = 1
	itmsX = love.graphics.getWidth()/2 - 85;--menu items's xcord
	menuFont = love.graphics.newFont("image_font.ttf", fontSize)
	fontSize = 14
	timer = 0
	mapFile = ""
	gameState = "editMenu"
	layers = {{"mix", love.graphics.getWidth()/32 , love.graphics.getHeight()/32,{2}},{"dirt", love.graphics.getWidth()/32 , love.graphics.getHeight()/32,{3,2}}}
	print("Map Height " .. love.graphics.getHeight()/32)
	print("Map Width " .. love.graphics.getWidth()/32)
	for k, file in ipairs(files) do
		if string.sub(file, -3) == "txt" then
			editFiles[#editFiles + 1] = string.sub(file, 1, -5);
		end
	end

	selectY = love.graphics.getHeight()/2 - fontSize * #editFiles;--selector's y cord

	for i = 1, #editFiles, 1 do
		print ("MAPFILE: " .. editFiles[i])
	end

	-- function love.keyreleased(key) 
	-- 	if key == "return" then
	-- 		gameState = "edit"
	-- 		mapFile = "" .. editFiles[selectPos] .. ".txt"
	-- 		loadTileEditor()
	-- 		updateSize()

	-- 	end
	-- end

end

function love.update(dt)

	function love.keyreleased(key)
		if key == "return" then
			if selectPos == 1 and #editFiles ~= 0 and gameState == "editMenu" then
				gameState = "edit"
				mapFile = editFiles[selectPos] .. ".txt"
				loadTileEditor(mapFile, mapWidth);
			end	
			if gameState == "edit" then
				print("tileQuads " ..  math.floor(((tileSet:getWidth()*tileSet:getHeight())/(32*32))/(love.graphics.getWidth()/32)))
				if dt > 0.05 then
					dt = 0.05
				end
				-- injectLayer(2, tileMap, layerMap, 1)
				for i = 1 , #layers, 1 do
					injectLayer(layers[i][4], tileMap, layerMap, i)
					print("Layer " .. i .. " length " .. #layerMap[i])
					-- print(#layers[i][4])
					-- for j = 1, #layers[i][4], 1 do 
					-- 	print("Layer num of types " .. i .. " " .. layers[1][4][j])
					-- end
				end

				t = getLayerMap()
				newMap("test", layers, t)
				-- for i = 1, #t, 1 do
				-- 	for j = 1, #t[i], 1 do
				-- 		if t[i][j] ~= 0 then 
				-- 			print("LAYER " .. i .. " " .. t[i][j])
				-- 		end
				-- 	end
				-- end
				-- checkMapsFolder()
				-- for i = 1, #layerMap[1], 1 do
				-- 	print(layerMap[1][i]) 

				-- 	if i % 25 == 0 then
				-- 		print("\n")
				-- 	end
				-- end
			end
		end
	end

	if gameState == "edit" then
		if dt > 0.05 then
			dt = 0.05
		end
		timer = timer + math.floor((love.timer.getDelta() * love.timer.getFPS()) * 100) / 10000

		if love.keyboard.isDown("right") and getCameraX() < mapWidth-1 then
			if timer > .05 then
				addCameraX(1)
				timer = 0
			end
		elseif love.keyboard.isDown("left") and getCameraX()+1 > math.floor(love.graphics.getWidth()/32) then
			if timer > .05 then
				subCameraX(1)
				timer = 0
			end
		end
	end

end


function love.draw()

	love.graphics.setFont(menuFont);

	if gameState == "editMenu" then
		love.graphics.draw(backGroundImage);
	end

	for i = 1, #editFiles, 1 do
		love.graphics.print("MAPFILE: " .. editFiles[i], itmsX, selectY)
	end

	love.graphics.print(">", itmsX - fontSize*2, selectY + ((selectPos-1)* 70))

	if gameState == "edit" then
		drawTileEditor()
	end
end

