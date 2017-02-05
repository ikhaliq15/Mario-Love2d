require ("../libs/boundary")

tileSet = love.graphics.newImage("spriteBatch.png");
tilesY = 0

function updateSize()
	bottomWidth = (((tileSet:getHeight()/32) * tileSet:getWidth()) %love.graphics.getWidth());  
	tilesX = 0; -- tiles boundaryx 
	tilesY = (math.floor((love.graphics.getHeight() - (math.floor(((tileSet:getWidth()*tileSet:getHeight())/(32*32))/(love.graphics.getWidth()/32))*32))/32
		)*32) - math.ceil((bottomWidth) / (bottomWidth+1)) * 32 -- tiles boundaryy
end

function loadTileEditor()

	love.graphics.setBackgroundColor(255,255,255);
	tileQuads = {};
	bottomWidth = (((tileSet:getHeight()/32) * tileSet:getWidth()) %love.graphics.getWidth());  
	tilesX = 0; -- tiles boundaryx 
	tilesY = (math.floor((love.graphics.getHeight() - (math.floor(((tileSet:getWidth()*tileSet:getHeight())/(32*32))/(love.graphics.getWidth()/32))*32))/32
		)*32) - math.ceil((bottomWidth) / (bottomWidth+1)) * 32 -- tiles boundaryy
	print(tilesY/32)
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
			tilesX = ((i-1)*32);
			tileMap[(tilesY+y*32)/32][tilesX/32] = i + (y*(love.graphics.getWidth()/32));
		end
	end
	-- (y*(love.graphics.getWidth()/32));
	updateMap()
	love.graphics.draw(spriteBatch);
	isGrabbing(tilesMin, tilesY, boxWidth, boxHeight,tileD, tileQuads, tileSet,tileMap);
end
