function love.load()

	selector = love.graphics.newImage("SELECTOR.png");
	logo = love.graphics.newImage("THEINTERWEB.png");
	itmsX = love.graphics.getWidth()/2 - 85;--menu items's xcord
	selectY = love.graphics.getHeight()/2 - logo:getHeight() + 45;--selector's y cord
	selectTb = {"WIDTH",0,"BGCOLOR",0,"ENTER"}--goes by 35
	selectPos = 1
	selectorX = itmsX - 35;
	selectorY = selectY;
	fontSize = 14 --actually the fontspace too lazy to change everything
	menuFont = love.graphics.newFont("image_font.ttf", 10)
end

function love.update()
	function love.keyreleased(key)
		if key == "down" and selectorX == itmsX -35 then
			selectPos = selectPos % math.ceil(#selectTb/2) + 1;
		end
		if key == "up" and selectorX == itmsX -35 then
			selectPos = (math.ceil(#selectTb/2) - selectPos)+ 1 
			selectPos = selectPos % math.ceil(#selectTb/2) +1
			selectPos = math.ceil(#selectTb/2) - selectPos + 1
		end
		-- if selectPos % 2 == 0 then
		-- 	selectorX = itmsX - fontSize + string.len(selectTb[selectPos-1])* fontSize
		-- 	selectorY = selectY + (35 * (selectPos-2))
		-- else
		-- 	selectorX = itmsX - 35
		-- 	selectorY = selectY + (35 * (selectPos-1))
		-- end
		if ((selectPos-1)*2+1) % 2 == 1 and key == "return" and selectPos ~= math.ceil(#selectTb/2) and selectorX ~= itmsX - fontSize + string.len(selectTb[(selectPos-1)*2+1])* fontSize then
			selectorX = itmsX - fontSize + string.len(selectTb[(selectPos-1)*2+1])* fontSize
			-- if key == "return" and selectorX == itmsX - fontSize + string.len(selectTb[(selectPos-1)*2+1])* fontSize  then
			-- 	selectorX = itmsX - 35
			-- end
			print(math.ceil(#selectTb/2))
		elseif key == "up" and  selectorX == itmsX - fontSize + string.len(selectTb[(selectPos-1)*2+1])* fontSize then
			selectTb[(selectPos-1)*2+2] = selectTb[(selectPos-1)*2+2] + 32;
		elseif  key == "down" and  selectorX == itmsX - fontSize + string.len(selectTb[(selectPos-1)*2+1])* fontSize and selectTb[(selectPos-1)*2+2] > 0 then
			selectTb[(selectPos-1)*2+2] = selectTb[(selectPos-1)*2+2] - 32;
		elseif key == "return" and selectorX == itmsX - fontSize + string.len(selectTb[(selectPos-1)*2+1])* fontSize then
			selectorX = itmsX -35
		end
	end
end

function love.draw()
	-- for i = 1, #selectTb, 1 do
	-- 	love.graphics.draw(selectTb[i], itmsX, love.graphics.getHeight()/2 - logo:getHeight() + 45 + (35 * (i-1)))
	-- end
	-- love.graphics.draw(logo, love.graphics.getWidth()/2 - 15, love.graphics.getHeight()/2 - logo:getHeight() + 15);
	-- love.graphics.draw(selector, itmsX - 35, selectY + (35 * (selectPos - 1)));

	love.graphics.setFont(menuFont);

	for i = 1, #selectTb, 1 do
		if i % 2 == 0 then 
			love.graphics.print(selectTb[i], itmsX + string.len(selectTb[i-1])* fontSize, selectY + (35 * (i-2)));
		else 
			love.graphics.print(selectTb[i], itmsX, selectY + (35 * (i-1)))
		end
	end

	love.graphics.print(">", selectorX, selectorY + ((selectPos-1)* 70))

	-- if selectPos % 2 == 0 then
	-- 	love.graphics.print("O", itmsX - fontSize + string.len(selectTb[selectPos-1])* fontSize, selectY + (35 * (selectPos-2)))

	-- else
	-- 	love.graphics.print("O", itmsX - 35, selectY + (35 * (selectPos-1)))

	-- end
	
end
-- function love.load( ) 
-- 	love.filesystem.setIdentity("Converter")
-- 	files = love.filesystem.getDirectoryItems("")
-- 	editFiles = {"mapWidth", 0, backGroundColor, 0, "enter"};
-- 	mapWidth = 0;
-- 	selectorX = 0;

-- 	-- for k, file in ipairs(files) do
-- 	-- 	if string.sub(file, -3) == "txt" then
-- 	-- 		editFiles[#editFiles + 1] = string.sub(file, 1, -5);
-- 	-- 	end
-- 	-- end
-- 	-- for i = 1, #editFiles, 1 do
-- 	-- 	print ("MAPFILE: " .. editFiles[i])
-- 	-- end
-- end

-- function love.update()
	

-- end

-- function love.draw( ... )
-- 	love.graphics.setFont(menuFont);
-- 	-- for i = 1, #editFiles, 1 do
-- 	-- 	love.graphics.print("MAPFILE: " .. editFiles[i], 30, 30)
-- 	-- end
-- 	love.graphics.print("WIDTH:  " .. tostring(mapWidth), 30);
-- 	love.graphics.print("o", selectorX);
	
-- end

