tetris = {}
map = {}
graphics = { tileSize = 20, }
pieces = {
	{ color = "purple" , map = {{1, 1, 1, 1}} },
	{ color = "yellow", map = {{1, 1}, {1, 1}} },
	{ color = "red", map = {{1, 0}, {1, 1}, {0, 1}}},
	{ color = "green", map = {{0, 1}, {1, 1}, {1, 0}}},
	{ color = "pink", map = {{1, 0}, {1, 1}, {1, 0}}},
	{ color = "orange", map = {{1, 1}, {1, 0}, {1, 0}}},
	{ color = "blue", map = {{1, 1}, {0, 1}, {0, 1}}},
}
tetris.createNewPiece = function ()
	timeCounter = 0.25
	currentPiece = math.random(#pieces)
	for i = 1, math.random(4)-1 do
		pieces[currentPiece].map = tetris.rotatePiece(currentPiece)
	end
	position = {x = math.floor((#map-#pieces[currentPiece].map)/2)+1, y = -(#pieces[currentPiece].map[1])+2}
	fallingPiece = true
end
tetris.start = function ()
	tetris.createMap(map, 23, 12)
	score = 0
	tetris.createNewPiece()
end
tetris.createMap = function (mapToCreate, lines, columns)
	local invisibleLines = 0
	for k = 1, #pieces do
		if #pieces[k].map > invisibleLines then
			invisibleLines = #pieces[k].map
		end
		if #pieces[k].map[1] > invisibleLines then
			invisibleLines = #pieces[k].map[1]
		end
	end
	for i = 1, columns do
		mapToCreate[i] = {}
		for j = -invisibleLines+2, lines do
			mapToCreate[i][j] = "empty"
		end
	end
end
tetris.rotatePiece = function (pieceNumber)
	local newMap = {}
	for i = 1, #pieces[pieceNumber].map[1] do
		newMap[i] = {}
		for j = 1, #pieces[pieceNumber].map do
			newMap[i][j] = pieces[pieceNumber].map[j][#pieces[pieceNumber].map[1]-i+1]
		end
	end
	return newMap
end
tetris.placePiece = function (mapToPlace, pieceNumber, x, y)
	for i = 1, #pieces[pieceNumber].map do
		for j = 1, #pieces[pieceNumber].map[1] do
			if pieces[pieceNumber].map[i][j] == 1 then
				mapToPlace[x+i-1][j+y-1] = pieces[pieceNumber].color
			end
		end
	end
end
tetris.positionIsAvailable = function (mapToCheck, currentX, currentY, deltaX, deltaY, pieceMap)
	for i = 1, #pieceMap do
		for j = 1, #pieceMap[1] do
			if pieceMap[i][j] == 1 and (not mapToCheck[currentX+i+deltaX-1] or mapToCheck[currentX+i+deltaX-1][currentY+j+deltaY-1] ~= "empty") then
				return false
			end
		end
	end
	return true
end
tetris.checkLines = function (mapToCheck)
	for line = 1, #pieces[currentPiece].map[1] do
		local clean = true
		for col = 1, #mapToCheck do
			if mapToCheck[col][position.y+line-1] == "empty" then
				clean = false
				break
			end
		end
		if clean then
			score = score + 1
			for col = 1, #mapToCheck do
				table.remove(mapToCheck[col], position.y+line-1)
				table.insert(mapToCheck[col], 1, "empty")
			end
		end
	end
	local line = 0
	while (mapToCheck[1][line]) do
		for col = 1, #mapToCheck do
			if map[col][line] ~= "empty" then
				lost = true
				return
			end
		end
		line = line - 1
	end
end
graphics.drawSquare = function (color, x, y)
	love.graphics.draw(graphics.blocksImages[color], x, y)
end
graphics.drawMap = function ()
	for i = 1, #map do
		for j = 1, #(map[1]) do
			graphics.drawSquare(map[i][j], i*graphics.tileSize, j*graphics.tileSize)
		end
	end
end
graphics.drawFallingPiece = function ()
	for i = 1, #pieces[currentPiece].map do
		for j = 1, #pieces[currentPiece].map[1] do
			if pieces[currentPiece].map[i][j] == 1 and position.y+j-1>0 then
				graphics.drawSquare(pieces[currentPiece].color, (position.x+i-1)*graphics.tileSize, (position.y+j-1)*graphics.tileSize)
			end
		end
	end
end
graphics.loadImages = function ()
	graphics.blocksImages = {}
	graphics.blocksImages.green = love.graphics.newImage("imagens//green.png")
	graphics.blocksImages.pink = love.graphics.newImage("imagens//pink.png")
	graphics.blocksImages.yellow = love.graphics.newImage("imagens//yellow.png")
	graphics.blocksImages.blue = love.graphics.newImage("imagens//blue.png")
	graphics.blocksImages.orange = love.graphics.newImage("imagens//orange.png")
	graphics.blocksImages.purple = love.graphics.newImage("imagens//purple.png")
	graphics.blocksImages.red = love.graphics.newImage("imagens//red.png")
	graphics.blocksImages.empty = love.graphics.newImage("imagens//empty.png")
	graphics.title = love.graphics.newImage("imagens//title.png")
end
function love.load ()
	graphics.loadImages()
	math.randomseed(os.time())
	tetris.start()
	love.window.setTitle("Tetris by Erica Riello")
	love.window.setMode((2*#map+3)*graphics.tileSize, (#map[1]+2)*graphics.tileSize)
end
function love.draw()
    graphics.drawMap()
    if fallingPiece then
    	graphics.drawFallingPiece()
    end
    love.graphics.setColor(255, 255, 255);
    love.graphics.print("Score: "..score, 300, 10*graphics.tileSize)
    if lost then
    	love.graphics.print("You lost!", 300, 11*graphics.tileSize)
    	love.graphics.print("Press R to restart!", 300, 12*graphics.tileSize)
    end
    love.graphics.draw(graphics.title, (#map+2)*graphics.tileSize, graphics.tileSize)
end
function love.update (dt)
	if not lost then
	timeCounter = timeCounter - dt
		if not fallingPiece and timeCounter < 0 then
			tetris.createNewPiece()
		elseif fallingPiece  and timeCounter < 0 then
			timeCounter = 0.25
			if tetris.positionIsAvailable(map, position.x, position.y, 0, 1, pieces[currentPiece].map) then
				position.y = position.y + 1
			else
				fallingPiece = false 
				tetris.placePiece(map, currentPiece, position.x, position.y)
				tetris.checkLines(map)
			end
		end
	end
end
function love.keypressed (key, isrepeat)
	if isrepeat then
		return
	end
	if key == "right" and tetris.positionIsAvailable(map, position.x, position.y, 1, 0, pieces[currentPiece].map) then
		position.x = position.x + 1
	elseif key == "left" and tetris.positionIsAvailable(map, position.x, position.y, -1, 0, pieces[currentPiece].map) then
		position.x = position.x - 1
	elseif key == "down" and tetris.positionIsAvailable(map, position.x, position.y, 0, 1, pieces[currentPiece].map) then
		position.y = position.y + 1
	elseif key == "up" then
		local newMap = tetris.rotatePiece(currentPiece)
		if tetris.positionIsAvailable(map, position.x, position.y, 0, 0, newMap) then
			pieces[currentPiece].map = newMap
		end
	elseif key == "r" then
		tetris.start()
	end
end