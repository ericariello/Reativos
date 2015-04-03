tetris = {}
map = {}
graphics = { tileSize = 20, }
pieces = { { color = "purple" , map = {{1, 1, 1, 1}} },
	{ color = "yellow", map = {{1, 1}, {1, 1}} },
	{ color = "red", map = {{1, 0}, {1, 1}, {0, 1}}},
	{ color = "green", map = {{0, 1}, {1, 1}, {1, 0}}},
	{ color = "pink", map = {{1, 0}, {1, 1}, {1, 0}}},
	{ color = "orange", map = {{1, 1}, {1, 0}, {1, 0}}},
	{ color = "blue", map = {{1, 1}, {0, 1}, {0, 1}}},
}
fallingMaxTime, currentFallTime = 0.25, 0.25
tetris.copyPieceMap = function (pieceId)
	local copy = {}
	for i = 1, #pieces[pieceId].map do
		copy[i] = {}
		for j = 0, #pieces[pieceId].map[1] do
			copy[i][j] = pieces[pieceId].map[i][j]
		end
	end
	return copy
end
tetris.createNewPiece = function ()
	timeCounter = fallingMaxTime
	local pieceId = math.random(#pieces)
	local piece = { color = pieces[pieceId].color, map=tetris.copyPieceMap(pieceId), animationTime = 0, }
	for i = 1, math.random(4)-1 do
		piece.map = tetris.rotatePiece(piece)
	end
	piece.position = {x = math.floor((#map-#piece.map)/2)+1, y = -(#piece.map[1])+2}
	return piece
end
tetris.start = function ()
	lost, score, level, holdPiece, fallingPiece = false, 0, 1, nil, true
	tetris.createMap(map, 23, 12)
	currentPiece = tetris.createNewPiece()
	nextPiece = tetris.createNewPiece()
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
tetris.rotatePiece = function (piece)
	local newMap = {}
	for i = 1, #piece.map[1] do
		newMap[i] = {}
		for j = 1, #piece.map do
			newMap[i][j] = piece.map[j][#piece.map[1]-i+1]
		end
	end
	return newMap
end
tetris.placePiece = function (mapToPlace, piece, x, y)
	for i = 1, #piece.map do
		for j = 1, #piece.map[1] do
			if piece.map[i][j] == 1 then
				mapToPlace[x+i-1][j+y-1] = piece.color
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
tetris.checkLines = function (mapToCheck, line1, line2)
	for line = line1, line2 do
		local clean = true
		for col = 1, #mapToCheck do
			if mapToCheck[col][line] == "empty" then
				clean = false
				break
			end
		end
		if clean then
			score = score + 1
			if score%10 == 0 then
				level = level + 1
			end
			for col = 1, #mapToCheck do
				table.remove(mapToCheck[col], line)
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
graphics.drawPiece = function (piece, x, y)
	for i = 1, #piece.map do
		for j = 1, #piece.map[1] do
			if piece.map[i][j] == 1 and y+j-1>0 then
				graphics.drawSquare(piece.color, x+(i-1)*graphics.tileSize, y+(j-1)*graphics.tileSize)
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
    	graphics.drawPiece(currentPiece, currentPiece.position.x*graphics.tileSize, currentPiece.position.y*graphics.tileSize-graphics.tileSize*(1-currentPiece.animationTime/fallingMaxTime))
    end
    love.graphics.draw(graphics.title, (#map+2)*graphics.tileSize, graphics.tileSize)
    graphics.drawPiece(nextPiece, 300, 13*graphics.tileSize)
    if holdPiece then
    	graphics.drawPiece(holdPiece, 300, 19*graphics.tileSize)
    end
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', graphics.tileSize, 0, #map*graphics.tileSize, graphics.tileSize)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(level, 300, 7.6*graphics.tileSize)
    love.graphics.print(score, 300, 10.5*graphics.tileSize)
    if lost then
    	love.graphics.print("You lost! Press R to restart!", 300, 5*graphics.tileSize)
    end
end
function love.update (dt)
	currentPiece.animationTime = currentPiece.animationTime + dt
	if not lost then
		timeCounter = timeCounter - dt
		if not fallingPiece and timeCounter < 0 then
			currentPiece, nextPiece, fallingPiece = nextPiece, tetris.createNewPiece(), true
			currentFallTime = fallingMaxTime
		elseif fallingPiece  and timeCounter < 0 then
			timeCounter = currentFallTime
			if tetris.positionIsAvailable(map, currentPiece.position.x, currentPiece.position.y, 0, 1, currentPiece.map) then
				currentPiece.position.y, currentPiece.animationTime = currentPiece.position.y + 1, 0
			else
				fallingPiece = false 
				tetris.placePiece(map, currentPiece, currentPiece.position.x, currentPiece.position.y)
				tetris.checkLines(map, currentPiece.position.y, currentPiece.position.y+#(currentPiece.map[1])-1)
			end
		end
	end
end
function love.keypressed (key, isrepeat)
	if isrepeat then
		return
	end
	if key == "right" and tetris.positionIsAvailable(map, currentPiece.position.x, currentPiece.position.y, 1, 0, currentPiece.map) then
		currentPiece.position.x = currentPiece.position.x + 1
	elseif key == "left" and tetris.positionIsAvailable(map, currentPiece.position.x, currentPiece.position.y, -1, 0, currentPiece.map) then
		currentPiece.position.x = currentPiece.position.x - 1
	elseif key == "down" and tetris.positionIsAvailable(map, currentPiece.position.x, currentPiece.position.y, 0, 1, currentPiece.map) then
		currentFallTime = (currentFallTime<=0.05 and 0.05) or currentFallTime - 0.05
	elseif key == "up" then
		local newMap = tetris.rotatePiece(currentPiece)
		if tetris.positionIsAvailable(map, currentPiece.position.x, currentPiece.position.y, 0, 0, newMap) then
			currentPiece.map = newMap
		end
	elseif key == "h" then
		if not holdPiece then
			holdPiece, currentPiece, nextPiece = currentPiece, nextPiece, tetris.createNewPiece()
		else
			holdPiece, currentPiece = currentPiece, holdPiece
		end
		holdPiece.animationTime = 0
		holdPiece.position = {x = math.floor((#map-#holdPiece.map)/2)+1, y = -(#holdPiece.map[1])+2}
	elseif key == "r" then
		tetris.start()
	end
end