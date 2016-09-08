function love.load()

	selector = love.graphics.newImage("SELECTOR.png");
	logo = love.graphics.newImage("THEINTERWEB.png");
	backGroundImage = love.graphics.newImage("EDITMENU.png");
	selectTb = {"WIDTH",0,"BGCOLOR",0,"ENTER"}--goes by 35
	fontSize = 18 --actually the fontspace too lazy to change everything
	menuFont = love.graphics.newFont("image_font.ttf", fontSize-4)
	itmsX = love.graphics.getWidth()/2 - 70;--menu items's xcord
	selectYCreate = love.graphics.getHeight()/2 - 35 * #selectTb + 35;--selector's y cord
	selectPos = 1
	selectorX = itmsX - 35;
	selectorY = selectYCreate;

	love.graphics.setBackgroundColor(120,120,250);
	gameState = "createMenu"
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
	if gameState == "createMenu" then
		love.graphics.draw(backGroundImage)
		for i = 1, #selectTb, 1 do
			if i % 2 == 0 then 
				love.graphics.print(selectTb[i], itmsX + string.len(selectTb[i-1])* fontSize, selectYCreate + (35 * (i-2)));
			else 
				love.graphics.print(selectTb[i], itmsX, selectYCreate + (35 * (i-1)))
			end
		end

		love.graphics.print(">", selectorX, selectorY + ((selectPos-1)* 70))
	end

	
end


