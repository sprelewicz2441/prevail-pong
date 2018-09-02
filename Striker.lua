Striker = Class{}

function Striker:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
    self.score = 0
end

function Striker:update()
	if self.y < 0 then
		self.y = 0
	elseif self.y + self.height > WINDOW_HEIGHT then
		self.y = WINDOW_HEIGHT - self.height
	else 
		self.y = self.y + self.dy
	end
end

function Striker:goal()
	self.score = self.score + 1
	sounds['goals'][0]:play()
end

function Striker:moveUI(target_obj, speed)
	if target_obj.y < self.y  then
        self.dy = -speed
    elseif target_obj.y > self.y + target_obj.image:getHeight() then
        self.dy = STRIKER_MOVE_SPEED
    else
        self.dy = 0
    end
end

function Striker:render() 
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end