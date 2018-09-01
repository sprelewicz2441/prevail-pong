Class = require 'class'
require 'Ball'
require 'Striker'

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 400

STIKER_MOVE_SPEED = 20

function love.load()
	game_state = 'welcome'

	love.graphics.setColor(255,255,255)
   	love.graphics.setBackgroundColor(0,0,0)

   	messageFont = love.graphics.newFont(24)
   	scoreFont = love.graphics.newFont(18)
   	love.graphics.setFont(messageFont)

   	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

   	ball_image = love.graphics.newImage("trump_head.png")
   	ball = Ball(ball_image, WINDOW_WIDTH/2 - ball_image:getWidth()/2, WINDOW_HEIGHT/2)
   	-- Left side striker
   	player1 = Striker(10,10,10,60)
   	-- Right side striker
	player2 = Striker(WINDOW_WIDTH - 20, WINDOW_HEIGHT - 70, 10, 60)
end

function love.update(dt)
	
	if game_state == 'playing' then
		ball:move()
		if ball:save_made(player1) then
			ball.dx = -ball.dx
			ball.dy = -ball.dy
		end

		if ball:save_made(player2) then
			ball.dx = -ball.dx
			ball.dy = -ball.dy
		end

		if ball.x > WINDOW_WIDTH then
			player1:goal()
			ball:reset(WINDOW_WIDTH/2 - ball_image:getWidth()/2, WINDOW_HEIGHT/2)
			game_state = 'serve'
		end

		if ball.x < 0 then
			player2:goal()
			ball:reset(WINDOW_WIDTH/2 - ball_image:getWidth()/2, WINDOW_HEIGHT/2)
			game_state = 'serve'
		end
	end

	if love.keyboard.isDown('w') then
		player1.y = player1.y - STIKER_MOVE_SPEED
	elseif love.keyboard.isDown('s') then
		player1.y = player1.y + STIKER_MOVE_SPEED
	end

	if love.keyboard.isDown('up') then
		player2.y = player2.y - STIKER_MOVE_SPEED
	elseif love.keyboard.isDown('down') then
		player2.y = player2.y + STIKER_MOVE_SPEED
	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'enter' or key == 'return' then
		if game_state == 'welcome' then
			love.graphics.clear()
			game_state = 'serve'
		elseif game_state == 'serve' then
			ball.dy = 10
			ball.dx = 10
			game_state = 'playing'
		end
	end
end

function love.draw()
	if game_state == 'welcome' then
		love.graphics.printf("Welcome to Prevail Pong! Good luck mofo(s)!!!", 10, WINDOW_HEIGHT/2 - 15, 780, 'center')
		love.graphics.printf("Press Enter to begin", 10, WINDOW_HEIGHT/2 + 15, 780, 'center')
	end

	if game_state ~= 'welcome' then
		ball:render()
		player1:render()
		player2:render()
		showScoreBoard()
	end
end

function showScoreBoard()
	love.graphics.setFont(scoreFont)
	love.graphics.print(player1.score, WINDOW_WIDTH/2 - 50, 20)
	love.graphics.print(player2.score, WINDOW_WIDTH/2 + 50, 20)
end