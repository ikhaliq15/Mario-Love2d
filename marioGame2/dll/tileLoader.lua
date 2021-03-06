require ("dll/tileEditor2")
require("dll/converter")
function loadTileLoader( ) 
	love.filesystem.setIdentity("Converter")
	files = love.filesystem.getDirectoryItems("custom_maps")
	backGroundImage = love.graphics.newImage("dll/editMenu.png")
	editFiles = {};
	-- mapWidth = (love.graphics.getWidth()*2)/32
	mapWidth = 215
	selectPosA = 1
	itmsX = love.graphics.getWidth()/2 - 85;--menu items's xcord
	menuFont = love.graphics.newFont("dll/image_font.ttf", fontSize)
	fontSize = 14
	timer = 0
	mapFile = ""
	layers = {{"Solid", love.graphics.getWidth()/32 , love.graphics.getHeight()/32,{4}},{"dirt", love.graphics.getWidth()/32 , love.graphics.getHeight()/32,{3,2}}}
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

function updateTileLoader(dt)

	function love.keyreleased(key)
		if key == "escape" then
			love.window.setMode(16*32, 14*32)
			state = "menu"
		end
		if key == "return" then
			if selectPosA == 1 and #editFiles ~= 0 and state == "editMenu" then
				print("tileQuads " ..  math.floor(((tileSet:getWidth()*tileSet:getHeight())/(32*32))/(love.graphics.getWidth()/32)))
				state = "edit"
				mapFile = editFiles[selectPosA] .. ".txt"
				loadTileEditor2(mapFile, mapWidth);
			end	
			if state == "edit" then
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

	if state == "edit" then
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


function drawTileLoader()

	love.graphics.setFont(menuFont);

	if state == "editMenu" then
		love.graphics.draw(backGroundImage);
	end

	for i = 1, #editFiles, 1 do
		love.graphics.print("MAPFILE: " .. editFiles[i], itmsX, selectY)
	end

	love.graphics.print(">", itmsX - fontSize*2, selectY + ((selectPosA-1)* 70))

	if state == "edit" then
		drawTileEditor2()
	end
end

