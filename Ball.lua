Ball = Class{}

function Ball:init(image, x, y)
    self.x = x
    self.y = y
    self.image = image
    self.dy = 0
    self.dx = 0
end

function Ball:serve()
	self.dy = math.random(1,10)
    self.dx = (math.abs(self.dx) > 0) and -self.dx or 10
end

function Ball:move()
	self.x = self.x + self.dx
	self.y = self.y + self.dy

	if self.y > WINDOW_HEIGHT then
		self.y = WINDOW_HEIGHT
		self.dy = -self.dy
		sounds['wall_hits'][math.floor(math.random(0, 2) + 0.4)]:play()
	end

	if self.y < 0 then
		self.y = 0
		self.dy = -self.dy
		sounds['wall_hits'][math.floor(math.random(0, 2) + 0.4)]:play()
	end
end

function Ball:save_made(striker)
	if (self.x > striker.x + striker.width) or (self.x + self.image:getWidth() < striker.x) then
		return false
	end

	if (self.y + self.image:getHeight() < striker.y) or (self.y > striker.y + striker.height) then
		return false
	end

	sounds['striker_hits'][math.floor(math.random(0, 6) + 0.4)]:play()
	return true
end

function Ball:rebound(offset)
	self.x = offset
	self.dx = -self.dx * 1.03
	if self.dy < 0 then
        self.dy = -math.random(1, 10)
    else
        self.dy = math.random(1, 10)
    end
end

function Ball:reset(x, y)
	self.x = x
	self.y = y
	-- self.dx = 0
end

function Ball:render() 
	-- Uncomment following line and comment line after that for smaller image 
	-- (requires adjustments to math on striker saves)

	-- love.graphics.draw(self.image, self.x, self.y, 0, 0.5, 0.5)
	love.graphics.draw(self.image, self.x, self.y)
end