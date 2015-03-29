tetris = {}
map = {}
graphics = { tileSize = 20, }
pieces = {
	{ color = "cian" , map = {{1, 1, 1, 1}} },
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
	position = {x = math.floor((#map-#pieces[currentPiece].map)/2)+1, y = -(#pieces[currentPiece].map[1])+2}
	fallingPiece = true
end
tetris.start = function ()
	tetris.createMap(23, 12)
	score = 0
	tetris.createNewPiece()
end
tetris.createMap = function (lines, columns)
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
		map[i] = {}
		for j = -invisibleLines+2, lines do
			map[i][j] = "empty"
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
tetris.placePiece = function (pieceNumber, x, y)
	for i = 1, #pieces[pieceNumber].map do
		for j = 1, #pieces[pieceNumber].map[1] do
			if pieces[pieceNumber].map[i][j] == 1 then
				map[x+i-1][j+y-1] = pieces[pieceNumber].color
			end
		end
	end
end
tetris.positionIsAvailable = function (deltaX, deltaY, pieceMap)
	for i = 1, #pieceMap do
		for j = 1, #pieceMap[1] do
			if pieceMap[i][j] == 1 and (not map[position.x+i+deltaX-1] or map[position.x+i+deltaX-1][position.y+j+deltaY-1] ~= "empty") then
				return false
			end
		end
	end
	return true
end
tetris.checkLines = function ()
	for line = 1, #pieces[currentPiece].map[1] do
		local clean = true
		for col = 1, #map do
			if map[col][position.y+line-1] == "empty" then
				clean = false
				break
			end
		end
		if clean then
			score = score + 1
			for col = 1, #map do
				table.remove(map[col], position.y+line-1)
				table.insert(map[col], 1, "empty")
			end
		end
	end
	local line = 0
	while (map[1][line]) do
		for col = 1, #map do
			if map[col][line] ~= "empty" then
				lost = true
				return
			end
		end
		line = line - 1
	end
end
graphics.drawSquare = function (color, x, y, w, h)
	local mode = 'fill'
	if color == "green" then
		love.graphics.setColor(0, 255, 0);
	elseif color == "pink" then
		love.graphics.setColor(204, 0, 204);
	elseif color == "yellow" then
		love.graphics.setColor(255, 255, 0);
	elseif color == "blue" then
		love.graphics.setColor(0, 0, 255);
	elseif color == "orange" then
		love.graphics.setColor(255, 153, 51);
	elseif color == "cian" then
		love.graphics.setColor(0, 255, 255);
	elseif color == "red" then
		love.graphics.setColor(255, 0, 0);
	elseif color == "empty" then
		love.graphics.setColor(150, 150, 150);
		mode = 'line'
	end
	love.graphics.rectangle(mode, x, y, w, h)
end
graphics.drawMap = function ()
	for i = 1, #map do
		for j = 1, #(map[1]) do
			graphics.drawSquare(map[i][j], i*graphics.tileSize, j*graphics.tileSize, graphics.tileSize, graphics.tileSize)
		end
	end
end
graphics.drawFallingPiece = function ()
	for i = 1, #pieces[currentPiece].map do
		for j = 1, #pieces[currentPiece].map[1] do
			if pieces[currentPiece].map[i][j] == 1 and position.y+j-1>0 then
				graphics.drawSquare(pieces[currentPiece].color, (position.x+i-1)*graphics.tileSize, (position.y+j-1)*graphics.tileSize, graphics.tileSize, graphics.tileSize)
			end
		end
	end
end
function love.load ()
	math.randomseed(os.time())
	tetris.start()
	love.window.setTitle("Tetris by Erica Riello")
	love.window.setMode(2*#map*graphics.tileSize, (#map[1]+2)*graphics.tileSize)
end
function love.draw()
    graphics.drawMap()
    if fallingPiece then
    	graphics.drawFallingPiece()
    end
    love.graphics.setColor(255, 255, 255);
    love.graphics.print("Score: "..score, 300, 2*graphics.tileSize)
    if lost then
    	love.graphics.print("You lost!", 300, graphics.tileSize)
    	love.graphics.print("Press R to restart!", 300, 3*graphics.tileSize)
    end
end
function love.update (dt)
	if not lost then
	timeCounter = timeCounter - dt
		if not fallingPiece and timeCounter < 0 then
			tetris.createNewPiece()
		elseif fallingPiece  and timeCounter < 0 then
			timeCounter = 0.25
			if tetris.positionIsAvailable(0, 1, pieces[currentPiece].map) then
				position.y = position.y + 1
			else
				fallingPiece = false 
				tetris.placePiece(currentPiece, position.x, position.y)
				tetris.checkLines()
			end
		end
	end
end
function love.keypressed (key, isrepeat)
	if isrepeat then
		return
	end
	if key == "right" and tetris.positionIsAvailable(1, 0, pieces[currentPiece].map) then
		position.x = position.x + 1
	elseif key == "left" and tetris.positionIsAvailable(-1, 0, pieces[currentPiece].map) then
		position.x = position.x - 1
	elseif key == "down" and tetris.positionIsAvailable(0, 1, pieces[currentPiece].map) then
		position.y = position.y + 1
	elseif key == "up" then
		local newMap = tetris.rotatePiece(currentPiece)
		if tetris.positionIsAvailable(0, 0, newMap) then
			pieces[currentPiece].map = newMap
		end
	elseif key == "r" then
		tetris.start()
	end
end