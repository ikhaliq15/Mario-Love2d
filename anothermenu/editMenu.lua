function love.load( ... )
	dir = love.filesystem.getSaveDirectory( );
	files = love.filesystem.getDirectoryItems( dir )
end

function love.update()
	for i = 1, #files, 1 do 
		print(files[i])
	end
end

function love.draw( ... )
	-- body
end