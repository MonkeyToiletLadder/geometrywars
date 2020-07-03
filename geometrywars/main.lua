require "..libs.vector"
require "..libs.utility"
require "player"
require "enemy"



players = {}
joysticks = love.joystick.getJoysticks()
enemies = {}
timer = 0

function love.load( ... )
	windowWidth, windowHeight = love.window.getMode()
	if #players == 0 then
		for _,v in pairs(joysticks) do
			local vid,pid,pv = v:getDeviceInfo()
			if vid == 1406 and pid == 8201 and pv == 273 then --Do not use wired connection
				break
			end
				table.insert(players,Player(v,0,0,250))	
		end
	end
	table.insert(enemies,Grunt(windowWidth/2,windowHeight/2,players[1]))
	table.insert(enemies,Grunt(windowWidth/2 + 30,windowHeight/2,players[1]))
	table.insert(enemies,Grunt(windowWidth/2 + 60,windowHeight/2,players[1]))
	table.insert(enemies,Grunt(windowWidth/2 + 90,windowHeight/2,players[1]))
	table.insert(enemies,Rocket(windowWidth/2,windowHeight/2,math.pi / 2))
	table.insert(enemies,Rocket(windowWidth/2 + 30,windowHeight/2,math.pi / 2))
	table.insert(enemies,Rocket(windowWidth/2 + 60,windowHeight/2,math.pi / 2))
	table.insert(enemies,Rocket(windowWidth/2 + 90,windowHeight/2,math.pi / 2))
	table.insert(enemies,Rocket(windowWidth/2 + 120,windowHeight/2,math.pi / 2))
	table.insert(enemies,Rocket(windowWidth/2 + 150,windowHeight/2,math.pi / 2))
	table.insert(enemies,Rocket(windowWidth/2 + 180,windowHeight/2,math.pi / 2))
	table.insert(enemies,Rocket(windowWidth/2 + 210,windowHeight/2,math.pi / 2))
	table.insert(enemies,Rocket(windowWidth/2 + 240,windowHeight/2,math.pi / 2))
	table.insert(enemies,Rocket(windowWidth/2 + 270,windowHeight/2,math.pi / 2))
	table.insert(enemies,Rocket(windowWidth/2 + 300,windowHeight/2,math.pi / 2))
	table.insert(enemies,Rocket(windowWidth/2 + 330,windowHeight/2,math.pi / 2))
	table.insert(enemies,Rocket(windowWidth/2 + 360,windowHeight/2,math.pi / 2))
end

function love.update(dt)
	timer = timer + dt
	if timer >= .5 then
		table.insert(enemies,Rocket(
			math.random(0,windowWidth),math.random(0,windowHeight),
			math.random(0,360)*math.pi/180))
		table.insert(enemies,Grunt(
			0,windowHeight,players[1]))
		timer = 0
	end
	for _,player in pairs(players) do
		player:update(dt)
		for i,lazer in ipairs(player.lazers) do
			for j,enemy in ipairs(enemies) do
				local isCollision = isCircleCollision(
					lazer.position.x,lazer.position.y,lazer.bounds,
					enemy.position.x,enemy.position.y,enemy.bounds)
				if isCollision then
					table.remove(player.lazers,i)
					table.remove(enemies,j)
				end	
			end
		end
	end
	for _,player in pairs(players) do
		for k,enemy in pairs(enemies) do
			local isCollision = isCircleCollision(
				player.position.x,player.position.y,player.bounds,
				enemy.position.x,enemy.position.y,enemy.bounds)
			if isCollision and enemy.collision then
				for k in pairs(enemies) do
					enemies[k] = nil
				end
				love.load()
			end
		end
	end
	for k,v in pairs(enemies) do
		v:update(dt)
	end
end
function love.draw()
	for _,v in pairs(players) do
		v:draw()
	end
	for k,v in pairs(enemies) do
		v:draw()
	end
end