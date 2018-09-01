Ball = Class{}

function Ball:init(image, x, y)
    self.x = x
    self.y = y
    self.image = image
    self.dy = 0
    self.dx = 0
end

function Ball:move()
	self.x = self.x + self.dx
	self.y = self.y + self.dy
	if self.y > WINDOW_HEIGHT then
		self.y = WINDOW_HEIGHT
		self.dy = -self.dy
	end

	if self.y < 0 then
		self.y = 0
		self.dy = -self.dy
	end
end

function Ball:save_made(striker)
	if (self.x > striker.x + striker.width) or (self.x + self.image:getWidth() < striker.x) then
		return false
	end

	if (self.y + self.image:getHeight() < striker.y) or (self.y > striker.y + striker.height) then
		return false
	end

	return true
end

function Ball:reset(x, y)
	self.x = x
	self.y = y
end

function Ball:render() 
	love.graphics.draw(self.image, self.x, self.y)
end