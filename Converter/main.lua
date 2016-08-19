require("test")

function love.load()

	checkMapsFolder()

	layers = {	{"Sky", 3, 1},
				{"Solid", 3, 1},
				{"Background", 3, 1}
			}
	data = {
				{1, 1, 1},
				{2, 2, 2},
				{3, 3, 3},
			}

	newMap("mario1-1", layers, data)
end


function love.update(dt)

end


function love.draw()
	love.graphics.print(love.filesystem.getSourceBaseDirectory().."/oi.png", 0, 0)
end
