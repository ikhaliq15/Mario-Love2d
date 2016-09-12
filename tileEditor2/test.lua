function readFile()
	local contents = ""
	path = love.filesystem.getSourceBaseDirectory().."/resources/tileset.png"
	actualPath = "/Users/Imran/Desktop/Coding/Github/Mario-Love2d/Converter/resources/tileset.png"

	print ("Path: " .. path)
	print ("Actual Path: " .. actualPath)

    local file = io.open(path, "r" )
    if (file) then
        -- read all contents of file into a string
        contents = file:read("*all")
        file:close() 
    end

    if string.len(contents) < 1 then
    	print ("SECOND TRY")
    	path = love.filesystem.getSourceBaseDirectory().."/Converter/resources/tileset.png"
    	print ("Path: " .. path)
    	local file = io.open(path, "r" )
    	if (file) then
        	-- read all contents of file into a string
        	contents = file:read("*all")
        	file:close() 
    	end
    end

    return contents
end

-- Check if a maps folder exists. If not, then create one
function checkMapsFolder()
	--print(love.filesystem.getSaveDirectory() .. "/maps/tilset_smb2.png")
	tileset = readFile()
	print ("TILESET LENGTH: " .. tostring(string.len(tileset)))
	if string.len(tileset) < 1 then
		print ("IMAGE FOR TILESET IS GONE!!!")
		love.event.push('quit')
	end
	if not love.filesystem.exists(love.filesystem.getSaveDirectory().."\\custom_maps\\") then
		success = love.filesystem.createDirectory("custom_maps")
		if success then
			m = love.filesystem.newFile("custom_maps/tileset.png")
			m:open("w")
			m:write(tileset)
			m:close()
		end
	end
end

-- Create a new map. n = name, l = layers, d = data
function newMap(n, l, d)
	-- if love.filesystem.exists("maps/" .. n) then
	-- 	return saveMap(n, l, d)
	-- end

	parts = {}
	parts2 = {}

	m = love.filesystem.newFile("custom_maps/" .. n .. ".tmx")
	m2 = love.filesystem.newFile("custom_maps/" .. n .. ".txt")
	m:open("w")
	m2:open("w")

	parts[#parts + 1] = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><map version=\"1.0\" orientation=\"orthogonal\" renderorder=\"right-down\" width=\"215\" height=\"15\" tilewidth=\"32\" tileheight=\"32\" nextobjectid=\"1\"><tileset firstgid=\"1\" name=\"tilset_smb2\" tilewidth=\"32\" tileheight=\"32\" tilecount=\"48\"><image source=\"tileset.png\" trans=\"3658ae\" width=\"256\" height=\"192\"/></tileset>"

	for i = 1, #l, 1 do
		currentStr = "<layer name=\"" .. l[i][1] .. "\" width=\"" .. tostring(l[i][2]) .. "\" height=\"" .. tostring(l[i][3]) .. "\"><data encoding=\"csv\">"
		for j = 1, #d[i], 1 do
			currentStr = currentStr .. tostring(d[i][j])
			if not (j == #d[i]) then
				currentStr = currentStr .. ","
			end
		end
		currentStr = currentStr .. "</data></layer>"
		parts[#parts + 1] = currentStr
		print("data" .. #l)
	end

	parts[#parts + 1] = "</map>"

	finalString = ""
	for i = 1, #parts, 1 do
		finalString = finalString .. parts[i] .. "\n"
	end
-- txt file
	-- for i = 1, 1, 1 do
	-- 	currentStr2 = ""
	-- 	for j = 1, #d[i], 1 do
	-- 		currentStr2 = currentStr2 .. tostring(d[i][j])
	-- 		if not (j == #d[i]) then
	-- 			currentStr2 = currentStr2 .. ","
	-- 		end
	-- 	end
	-- 	parts2[#parts2 + 1] = currentStr2
	-- end

	-- finalString2 = ""

	-- for i = 1, #parts2, 1 do
	-- 	finalString2 = finalString2 .. parts2[i] .. "\n"
	-- end
	for i = 1, #d[1], 1 do 
		parts2[i] = 0
	end

	for i = 1, #l, 1 do
		currentStr2 = ""
		for j = 1, #d[i], 1 do
			if parts2[j] == 0 then
				parts2[j] = d[i][j]
				-- if d[i][j] ~= 0 then
				-- 	print(d[i][j])
				-- end
			end
		end
	end
	
	finalString2 = ""
	
	for i = 1, #parts2, 1 do
		finalString2 =  finalString2 .. parts2[i]
		if not (i == #parts2) then
			finalString2 = finalString2 .. ","
		end
	end
	finalString2 = finalString2 .. "\n"

	print ("Final TMX: " .. string.len(finalString))
	print ("Final TXT: " .. string.len(finalString2))


	success = love.filesystem.write( "custom_maps/"..n..".tmx", finalString)
	succes2 = love.filesystem.write( "custom_maps/"..n..".txt", finalString2)

end

-- Save a map. n = name, l = layers, d = data