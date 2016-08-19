function readFile()
	local contents = ""
    local file = io.open(love.filesystem.getSourceBaseDirectory().."/oi.png", "r" )
    if (file) then
        -- read all contents of file into a string
        contents = file:read("*all")
        file:close() 
    end
    return contents
end

-- Check if a maps folder exists. If not, then create one
function checkMapsFolder()
	--print(love.filesystem.getSaveDirectory() .. "/maps/tilset_smb2.png")
	tileset = readFile()
	if not love.filesystem.exists(love.filesystem.getSaveDirectory().."/maps/") then
		success = love.filesystem.createDirectory("maps")
		if success then
			m = love.filesystem.newFile("maps/tilset_smb.png")
			m:open("w")
			m:write(tileset)
			m:close()
		end
	end
end

-- Create a new map. n = name, l = layers, d = data
function newMap(n, l, d)
	if love.filesystem.exists("maps/" .. n) then
		return saveMap(n, l, d)
	end

	parts = {}

	m = love.filesystem.newFile("maps/" .. n .. ".tmx")
	m:open("w")

	parts[#parts + 1] = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><map version=\"1.0\" orientation=\"orthogonal\" renderorder=\"right-down\" width=\"215\" height=\"15\" tilewidth=\"32\" tileheight=\"32\" nextobjectid=\"1\"><tileset firstgid=\"1\" name=\"tilset_smb2\" tilewidth=\"32\" tileheight=\"32\" tilecount=\"48\"><image source=\"tilset_smb2.png\" trans=\"3658ae\" width=\"256\" height=\"192\"/></tileset>"

	for i = 1, #l, 1 do
		for j = 1, #d[i], 1 do
			
		end
	end
end

-- Save a map. n = name, l = layers, d = data
function saveMap(n, l, d)
	if not love.filesystem.exists("maps/" .. n) then
		return newMap(n, l, d)
	end

end