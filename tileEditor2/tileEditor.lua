require ("boundary")

tileSet = love.graphics.newImage("spriteBatch.png");
tilesY = 0
function readMapFile(name, size, layerMap, layerNum)
	-- data = love.filesystem.read( "custom_maps/" .. name, size )
	-- print(string.sub(data, 2,2))

	-- for i = 0, math.floor(string.len(data)/2), 1 do
	-- 	layerMap[layerNum][i] = tonumber(string.sub(data,i*2 + 1,i*2 + 1))
	-- 	print(tonumber(string.sub(data,i*2 + 1,i*2 + 1)))
	-- end
end

function injectLayer(id, tbl, layerTbl, layerNum)
	k = 0
	for i = 1, #tbl + 1, 1 do
		for j = 1, #tbl[i-1]+1, 1 do 
			if tbl[i-1][j-1] == id then
				k = k +1
				layerTbl[layerNum][j + #tbl[i-1]*(i-1)] = k
				print(k)
			elseif tbl[i-1][j-1] == nil then
				print ("NILL ".. j .. " " .. i)
			else
				k = k +1
				layerTbl[layerNum][j + #tbl[i-1]*(i-1)] = k
				print(k)
			end
		-- if tbl[i][j] == id then 
		-- 		layerTbl[layerNum][j + #tbl[i]*(i)] = k
		-- 	elseif tbl[i][j] == nil then
		-- 		print (j)
		-- 	else
		-- 		k = k +1
		-- 		-- print(k)
		-- 		layerTbl[layerNum][j + #tbl[i]*(i)] = k
		-- 	end
		end
	end 
	 print(tbl[1][25])

end

--need to read the file first you dont need to overlay any layers because when you make a map you never overlay a tile
function mergeLayers(tbl, layerTbl)
	for i = 1, #layerTbl, 1 do 
		for j = 1, #layerTbl[i], 1 do
			tbl[i][j] = layerTbl[i][j]
		end
	end

end

function updateSize()
	bottomWidth = (((tileSet:getHeight()/32) * tileSet:getWidth()) %love.graphics.getWidth());  
	tilesX = 0; -- tiles boundaryx 
	tilesY = (math.floor((love.graphics.getHeight() - (math.floor(((tileSet:getWidth()*tileSet:getHeight())/(32*32))/(love.graphics.getWidth()/32))*32))/32
		)*32) - math.ceil((bottomWidth) / (bottomWidth+1)) * 32 -- tiles boundaryy
end

function loadTileEditor(mapFile)

	love.graphics.setBackgroundColor(255,255,255);
	tileQuads = {};
	layerMap = {{}};
	bottomWidth = (((tileSet:getHeight()/32) * tileSet:getWidth()) %love.graphics.getWidth());  
	tilesX = 0; -- tiles boundaryx 
	tilesY = (math.floor((love.graphics.getHeight() - (math.floor(((tileSet:getWidth()*tileSet:getHeight())/(32*32))/(love.graphics.getWidth()/32))*32))/32
		)*32) - math.ceil((bottomWidth) / (bottomWidth+1)) * 32 -- tiles boundaryy
	tilesMin = 0;
	tileD = 32;
	boxWidth = 0;
	if(tileSet:getWidth()*(tileSet:getHeight()/32) % love.graphics.getWidth() == tileSet:getWidth()) then
		boxWidth = tileSet:getWidth();
	else
		boxWidth = love.graphics.getWidth();
	end
	boxHeight = math.ceil(((love.graphics.getHeight() - tilesY))/32)*32;
	tileMap = {};
	tx = 0;
	ty = 0;
	-- putting if outside for effeciency, every frame counts!
	data = love.filesystem.read( "custom_maps/" .. mapFile, love.filesystem.getSize(mapFile), layerMap, 1)
	-- if  data ~= "" then
	-- 	readMapFile(mapFile, love.filesystem.getSize(mapFile), layerMap, 1)
	--  	for i = 0, math.floor(love.graphics.getHeight()/32), 1 do
	-- 		tileMap[i] = {};
	-- 		for j = 0, math.floor(love.graphics.getWidth()/32), 1 do
	-- 			tileMap[i][j] = layerMap[1][j + #tileMap[i]*(i)];
	-- 			-- print(layerMap[1][j + #tileMap[i]*(i)]);
	-- 		end
	-- 	end
	-- else
	k = 0

		for i = 0, math.floor(love.graphics.getHeight()/32)-1, 1 do
			tileMap[i] = {};
			for j = 0, math.floor(love.graphics.getWidth()/32)-1, 1 do
				tileMap[i][j] = 0;
				k = k + 1
			end
		end
		-- for i = 0, 10, 1 do
		-- 	print(i)
		-- end
	-- end
	
	for y = 0, (tileSet:getHeight()/32)-1, 1 do
		for x = 0, (tileSet:getWidth()/32)-1, 1 do 
			tileQuads[#tileQuads+1] = love.graphics.newQuad(x * 32, y * 32, 32, 32, tileSet:getWidth(), tileSet:getHeight());
		end
	end
	spriteBatch = love.graphics.newSpriteBatch(tileSet, love.graphics.getHeight() * love.graphics.getWidth());
end

function getMap( )
	return layerMap;

end

function updateMap() 
	spriteBatch:clear();
	for i = 0, #tileMap, 1 do 
		for j = 0, #tileMap[i] do 
			if tileMap[i][j] ~= 0 then
				spriteBatch:add(tileQuads[tileMap[i][j]],j*32,i*32);
			end
		end
	end
	spriteBatch:flush();
end

function isTileItemColliding()
	return isTouching(tilesMin, tilesY, boxWidth, boxHeight, bottomWidth);
end 


function drawTileEditor()
	love.graphics.setColor(0,0,0);
	-----MAP GRID
	for i = 0, math.floor(love.graphics.getHeight()/32), 1 do
		love.graphics.line(0, i*32, love.graphics.getWidth(), i*32);
	end 

	for i = 0, math.floor(love.graphics.getWidth()/32), 1 do
		love.graphics.line(i*32, 0, i*32, love.graphics.getHeight());
	end 
	-----END OF MAP GRID
	-- love.graphics.print("mousex: " .. tostring(love.mouse.getX()/32), 0, love.graphics.getHeight() - 20);
	love.graphics.print("mousey: " .. tostring(love.mouse.getY()/32), 200);
	love.graphics.print("isTouching ".. tostring(isTouching(tilesMin, tilesY, boxWidth, boxHeight, bottomWidth)), 32);
-- math.floor(((tileSet:getWidth()*tileSet:getHeight())/(32*32))/(love.graphics.getWidth()/32))
	love.graphics.setColor(255,255,255);
	for y = 0, math.floor(((tileSet:getWidth()*tileSet:getHeight())/(32*32))/(love.graphics.getWidth()/32)), 1 do --clean up with modoulus
		for i = 1, #tileQuads - y * love.graphics.getWidth()/32, 1 do
			if i <= 25 then
				tilesX = ((i-1)*32);
				tileMap[(tilesY+y*32)/32][tilesX/32] = i + (y*(love.graphics.getWidth()/32));
			end
		end
	end

	-- (y*(love.graphics.getWidth()/32));
	updateMap()
	love.graphics.draw(spriteBatch);
	isGrabbing(tilesMin, tilesY, boxWidth, boxHeight,tileD, tileQuads, tileSet,tileMap);
end
