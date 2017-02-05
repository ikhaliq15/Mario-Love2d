require ("dll/boundary")

tileSet = love.graphics.newImage("spriteBatch.png");
tilesY = 0
CameraX = math.floor(love.graphics.getWidth()/32)-1

--make past 2 digits

function string:split(sep)
        local sep, fields = sep or ":", {}
        local pattern = string.format("([^%s]+)", sep)
        self:gsub(pattern, function(c) fields[#fields+1] = c end)
        return fields
end

function readMapFile(name, size, layerMap, layerNum)
	layerNums = getLayerMap()
	
	t = data:split(",")
	for i = 1, #t, 1 do
		for j = 1, #layerNums, 1 do
			layerMap[j][i] = tonumber(t[i])
		end
	end

	for j = 1, #layerNums, 1 do
		print("MAPSIZE : " .. #layerMap[j])
	end
end

function contains(value,ids)
	for k = 1, #ids, 1 do
		if value == ids[k] then
			return value;
		end
	end
	return 0
end

function injectLayer(ids, tbl, layerTbl, layerNum)
	for i = 1, #tbl+1, 1 do
		for j = 1, #tbl[i-1]+1, 1 do -- minus i and 1 to set back to zero while not getting out of bounds error
			-- if tbl[i-1][j-1] == id then
			-- 	layerTbl[layerNum] [j + (#tbl[i-1]+1) * (i-1)] = ids
			-- elseif tbl[i-1][j-1] == nil then
			-- 	print ("NILL ".. j .. " " .. i)
			-- else
			-- 	layerTbl[layerNum] [j + (#tbl[i-1]+1) * (i-1)] = 0
			-- end
			-- layerTbl[1] [j + (#tbl[i-1]+1) * (i-1)] = 0;
			-- for k = 1, #ids, 1 do
				layerTbl[layerNum] [j + (#tbl[i-1]+1) * (i-1)] = contains(tbl[i-1][j-1], ids);
			-- end

		end
	end 
end

--need to read the file first you dont need to overlay any layers because when you make a map you never overlay a tile

function mergeLayers(tbl, layerTbl)
	for i = 1, #layerTbl, 1 do 
		for j = 1, #layerTbl[i], 1 do
			tbl[i][j] = layerTbl[i][j]
		end
	end
end

function addCameraX( a )
	CameraX = CameraX + a
end

function subCameraX( s )
	CameraX = CameraX -	s;
end

function getCameraX( )
	return CameraX
end

function updateSize()
	bottomWidth = (((tileSet:getHeight()/32) * tileSet:getWidth()) %love.graphics.getWidth());  
	tilesX = 0; -- tiles boundaryx 
	tilesY = (math.floor((love.graphics.getHeight() - (math.floor(((tileSet:getWidth()*tileSet:getHeight())/(32*32))/(love.graphics.getWidth()/32))*32))/32
		)*32) - math.ceil((bottomWidth) / (bottomWidth+1)) * 32 -- tiles boundaryy
end

function loadTileEditor2(mapFile, mapWidth)

	love.graphics.setBackgroundColor(255,255,255);
	tileQuads = {};
	layerMap = {};
	for i = 1, #layers, 1 do
		layerMap[i] = {}
	end
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
	data = love.filesystem.read( "custom_maps/" .. "test.txt", love.filesystem.getSize(mapFile), layerMap, 1)
	k = 0
	if  data ~= "" and data ~= nil then
		print("DATA READ")
		readMapFile(mapFile, love.filesystem.getSize("custom_maps/" .. "test.txt"), layerMap, 1)
	 	for i = 0, math.floor(love.graphics.getHeight()/32)-1, 1 do
			tileMap[i] = {};
			for j = 0, mapWidth-1, 1 do
				tileMap[i][j] = layerMap[1][(j+1) + (mapWidth) * i];
				k = k+1
				-- tileMap[i][j] = 0;
				-- print(layerMap[1][j + #tileMap[i]*(i)]);
			end
		end
	else
		for i = 0, math.floor(love.graphics.getHeight()/32)-1, 1 do
			tileMap[i] = {};
			for j = 0, mapWidth-1, 1 do
				tileMap[i][j] = 0;
				-- print("zero" .. tileMap[i][j] .. k)
			end
		end
	end
	
	for y = 0, (tileSet:getHeight()/32)-1, 1 do
		for x = 0, (tileSet:getWidth()/32)-1, 1 do 
			tileQuads[#tileQuads+1] = love.graphics.newQuad(x * 32, y * 32, 32, 32, tileSet:getWidth(), tileSet:getHeight());
		end
	end
	spriteBatch = love.graphics.newSpriteBatch(tileSet, love.graphics.getHeight() * love.graphics.getWidth());
end

function getLayerMap()

	return layerMap;

end

function updateMap2(camX) 
	spriteBatch:clear();
	for i = 0, math.floor(love.graphics.getHeight()/32)-1, 1 do 
		for j = 0, math.floor(love.graphics.getWidth()/32)-1, 1 do 
			if tileMap[i][j+(camX - (math.floor(love.graphics.getWidth()/32)-1))] ~= 0 then
				spriteBatch:add(tileQuads[tileMap[i][j+(camX - (math.floor(love.graphics.getWidth()/32)-1))]],j*32,i*32);
			end
		end
	end
	spriteBatch:flush();
end

function isTileItemColliding2()
	return isTouching(tilesMin, tilesY, boxWidth, boxHeight, bottomWidth);
end 


function drawTileEditor2()
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

	love.graphics.setColor(255,255,255);

	for i = 0, (love.graphics.getWidth() - bottomWidth)/32 -1, 1 do
		if tileMap[love.graphics.getHeight()/32 - 1][bottomWidth/32 + i +(getCameraX() - (math.floor(love.graphics.getWidth()/32)-1))] ~= 0 then
			tileMap[love.graphics.getHeight()/32 - 1][bottomWidth/32 + i +(getCameraX() - (math.floor(love.graphics.getWidth()/32)-1))] = 0
		end
	end 

	for i = 1, #tileQuads, 1 do
		tilesX = (i-1) % (love.graphics.getWidth()/32);
		y = math.floor((i-1)/(love.graphics.getWidth()/32)) 
		-- print(i + (y*(love.graphics.getWidth()/32)))
		tileMap[tilesY/32 + y][tilesX+(getCameraX() - (math.floor(love.graphics.getWidth()/32)-1))] = i 
	end
	updateMap2(getCameraX())
	love.graphics.draw(spriteBatch);
	isGrabbing(tilesMin, tilesY,(getCameraX() - (math.floor(love.graphics.getWidth()/32)-1)), boxWidth, boxHeight,tileD, tileQuads, tileSet,tileMap);
end