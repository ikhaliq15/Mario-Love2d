 function love.load()
	require "boundary"
	require "test"
	love.graphics.setBackgroundColor(255,255,255);
	tileSet = love.graphics.newImage("spriteBatch.png");
	layers = { 
			{"Sky", 25, 19},
		}
	love.filesystem.setIdentity("Converter")
	ogImagePath = love.filesystem.getSourceBaseDirectory().."/resources/tileset.png"
	saveImagePath = love.filesystem.getSaveDirectory().."/maps/tileset.png"
	tileQuads = {};
	tilesX = 0; -- tiles boundaryx 
	tilesY = (math.floor((love.graphics.getHeight() - (math.floor(((tileSet:getWidth()*tileSet:getHeight())/(32*32))/(love.graphics.getWidth()/32))*32))/32
		)*32)-32 -- tiles boundaryy
	tilesMin = 0;
	tileD = 32;
	bottomWidth = (((tileSet:getHeight()/32) * tileSet:getWidth()) %love.graphics.getWidth()); --how many extra tiles at the bottom 
	boxWidth = 0;
	if(tileSet:getWidth()*(tileSet:getHeight()/32) % love.graphics.getWidth() == tileSet:getWidth()) then
		boxWidth = tileSet:getWidth();
	else
		boxWidth = love.graphics.getWidth();
	end
	boxHeight = math.ceil(((love.graphics.getHeight() - tilesY))/32)*32;
	tileMap = {};
	layerMap = {{}};
	tx = 0;
	ty = 0;

	print (love.graphics.getHeight()/32)
	print (love.graphics.getWidth()/32)
	for i = 0, math.floor(love.graphics.getHeight()/32), 1 do
		tileMap[i] = {};
		for j = 0, math.floor(love.graphics.getWidth()/32), 1 do
			tileMap[i][j] = 0;
		end
	end

	for y = 0, (tileSet:getHeight()/32)-1, 1 do
		for x = 0, (tileSet:getWidth()/32)-1, 1 do 
			tileQuads[#tileQuads+1] = love.graphics.newQuad(x * 32, y * 32, 32, 32, tileSet:getWidth(), tileSet:getHeight());
		end
	end
	spriteBatch = love.graphics.newSpriteBatch(tileSet, love.graphics.getHeight() * love.graphics.getWidth());
end

function injectLayer(id, tbl, layerTbl, layerNum)
	for i = 1, #tbl, 1 do
		for j = 1, #tbl[i],1 do 
			if tbl[i-1][j-1] == id then 
				layerTbl[layerNum][j + #tbl[i]*(i-1)] = id
			elseif tbl[i-1][j-1] == nil then
				print (j)
			else
				layerTbl[layerNum][j + #tbl[i]*(i-1)] = 0
			end
		end
	end
end
--need to read the file first you dont need to overlay any layers because when you make a map you never overlay a tile
function mergeLayers(tbl, layerTbl)
	for i = 1, #layerTbl, 1 do 
		for j = 1, #layerTbl[i], 1 do
			tblp[i][j] = layerTbl[i][j]
		end
	end

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

function love.update()
	isTouching(tilesMin, tilesY, boxWidth, boxHeight, bottomWidth);
	function love.keyreleased(key) 

		if key == "return" then
			-- checkMapsFolder()
			injectLayer(2, tileMap, layerMap, 1)
			for i = 1, #layerMap[1], 1 do 
				print (layerMap[1][i])
			end
			print(#layerMap[1]);
			newMap("test", layers, layerMap)
			-- print(love.graphics.getHeight()/32 .. " " .. love.graphics.getWidth()/32)

		end
	end
end

function love.draw()
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
			tilesX = ((i-1)*32);
			tileMap[(tilesY+y*32)/32][tilesX/32] = i + (y*(love.graphics.getWidth()/32));
		end
	end
	-- (y*(love.graphics.getWidth()/32));
	updateMap()
	love.graphics.draw(spriteBatch);
	isGrabbing(tilesMin, tilesY, boxWidth, boxHeight,tileD, tileQuads, tileSet,tileMap);
end
