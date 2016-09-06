grab = false;
tileW = 0;
tileH = 0;
tileT = 0;
extra = 0;
function isTouching(x, y, width, height, ex)
	tileW = width;
	tileH = height;
	extra = ex; --distance from the pixel set to the bottom
	isExtra = math.ceil((bottomWidth) / (bottomWidth+1)) * 32;

	-- print(tileH - (love.graphics.getHeight() - 32*((tileH - y)/32) + y));
	if love.mouse.getX() > x and love.mouse.getX() < x + tileW and love.mouse.getY() > y and love.mouse.getY() < tileH + y then
		if ex == "ntTile" then
			return true;
		end
		if love.mouse.getY() >= ((love.graphics.getHeight() - y)- isExtra)+ y and love.mouse.getX() >= extra then
			return false;
		else
			return true;
		end
	end 
	return false;

end

function isGrabbing(x,y,width, height,tileD,Quad,QuadImg,tileMap)

	if love.mouse.isDown(1) and isTouching(x,y,width, height, extra) then -- if it is in the area of the tiles then it is grab = true
		cx = math.floor((love.mouse.getX())/32);
		cy = math.floor((love.mouse.getY())/32);
		tileT = tileMap[cy][cx]; -- sets the value of the block to the one in the map
		grab = true;
	end
	if grab == true then
		tileTx = love.mouse.getX()-tileD/2;
		tileTy = love.mouse.getY()-tileD/2;
		love.graphics.draw(QuadImg, Quad[tileT],tileTx,tileTy); --draws tile in middle of mouse
		if love.mouse.isDown(2) == true then
			grab = false;
			tileDx = tilex;
			tileDy = tiley;
			-- tileDx = math.floor((love.mouse.getX())/32) * 32;
			-- tileDy = math.floor((love.mouse.getY())/32) * 32;
		end
		if love.mouse.isDown(1) == true then -- checks which tile it grabbed
			cx = math.floor((love.mouse.getX())/32);
			cy = math.floor((love.mouse.getY())/32);
			tileMap[cy][cx] = tileT; -- sets the place in the map to the type it grabbed
			return tileMap; 
		end
	end
end