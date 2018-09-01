Striker = Class{}

function Striker:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.score = 0
end

function Striker:goal()
	self.score = self.score + 1
end

function Striker:render() 
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end