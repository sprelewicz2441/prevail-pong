Class = require 'class'
require 'Ball'
require 'Striker'

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 400

STRIKER_MOVE_SPEED = 20

function love.load()
	game_state = 'welcome'
	num_players = 1
	winning_score = 5

	love.window.setTitle('Prevail Pong')

    -- seed the RNG
    math.randomseed(os.time())

	love.graphics.setColor(255,255,255)
   	love.graphics.setBackgroundColor(0,0,0)

   	messageFont = love.graphics.newFont(24)
   	scoreFont = love.graphics.newFont(68)
   	love.graphics.setFont(messageFont)

   	sounds = {
   		['wall_hits'] = {
   			[0] = love.audio.newSource('sounds/bingbing1.mp3', 'static'),
   			[1] = love.audio.newSource('sounds/bongbong1.mp3', 'static'),
   			[2] = love.audio.newSource('sounds/bingbong2.mp3', 'static')
   		},
   		['striker_hits'] = {
   			[0] = love.audio.newSource('sounds/china.mp3', 'static'),
   			[1] = love.audio.newSource('sounds/wall_short.mp3', 'static'),
   			[2] = love.audio.newSource('sounds/failed_short.mp3', 'static'),
   			[3] = love.audio.newSource('sounds/loser.mp3', 'static'),
   			[4] = love.audio.newSource('sounds/sit_down_short.mp3', 'static'),
   			[5] = love.audio.newSource('sounds/loser.mp3', 'static'),
   			[6] = love.audio.newSource('sounds/hombres_short.mp3', 'static')
   		},
   		['goals'] = {
   			[0] = love.audio.newSource('sounds/trumpX3.mp3', 'static')
   		}
   	}

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
			ball:rebound(player1.x + player1.width)
		end

		if ball:save_made(player2) then
			ball:rebound(player2.x - ball.image:getWidth())
		end

		if ball.x > WINDOW_WIDTH then
			player1:goal()
			ball:reset(WINDOW_WIDTH/2 - ball_image:getWidth()/2, WINDOW_HEIGHT/2)
			if player1.score >= winning_score then
				winner = "Player 1"
				game_state = 'end'
			else
				game_state = 'serve'
			end
		end

		if ball.x < 0 then
			player2:goal()
			ball:reset(WINDOW_WIDTH/2 - ball_image:getWidth()/2, WINDOW_HEIGHT/2)
			if player2.score >= winning_score then
				winner = "Player 2"
				game_state = 'end'
			else
				game_state = 'serve'
			end
		end
	end

	if love.keyboard.isDown('w') then
		player1.y = player1.y - STRIKER_MOVE_SPEED
	elseif love.keyboard.isDown('s') then
		player1.y = player1.y + STRIKER_MOVE_SPEED
	end

	if num_players == 2 then
		if love.keyboard.isDown('up') then
			player2.y = player2.y - STRIKER_MOVE_SPEED
		elseif love.keyboard.isDown('down') then
			player2.y = player2.y + STRIKER_MOVE_SPEED
		end
	elseif num_players == 1 then
		player2:moveUI(ball, STRIKER_MOVE_SPEED)
	else
		player2:moveUI(ball, STRIKER_MOVE_SPEED)
		player1:moveUI(ball, STRIKER_MOVE_SPEED)
	end

	player1:update()
	player2:update()
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif game_state == 'welcome' and (key == '0' or key == '1' or key == '2') then
		num_players = tonumber(key)
		love.graphics.clear()
		game_state = 'serve'
	elseif key == 'enter' or key == 'return' then
		if game_state == 'welcome' or game_state == 'end' then
			love.graphics.clear()
			game_state = 'serve'
		elseif game_state == 'serve' then
			ball:serve()
			game_state = 'playing'
		end
	end
end

function love.resize()

end

function love.draw()
	if game_state == 'welcome' then
		love.graphics.printf("Welcome to Prevail Pong! Good luck mofo(s)!!!", 10, WINDOW_HEIGHT/2 - 15, 780, 'center')
		love.graphics.printf("How many mofos are playing today? (Press 0, 1 or 2)", 10, WINDOW_HEIGHT/2 + 15, 780, 'center')
	end

	if game_state == 'end' then
		love.graphics.clear()
		love.graphics.printf(winner .. " Wins!", 10, WINDOW_HEIGHT/2 -70, 780, 'center')
		love.graphics.printf("Final Score", 10, WINDOW_HEIGHT/2, 780, 'center')
		love.graphics.printf(player1.score .. "-" .. player2.score, 10, WINDOW_HEIGHT/2 + 70, 780, 'center')
	end

	if game_state ~= 'welcome' and game_state ~= 'end' then
		ball:render()
		player1:render()
		player2:render()
		showScoreBoard()
	end
end

function showScoreBoard()
	love.graphics.setFont(scoreFont)
	love.graphics.print(player1.score, WINDOW_WIDTH/2 - 80, 50)
	love.graphics.print(player2.score, WINDOW_WIDTH/2 + 50, 50)
end