require "..libs.class"
require "..libs.utility"
theta = 0
Lazer = Class("Lazer")
Lazer.isLazer = true
function Lazer:init(x,y,speed,direction)
	self.position = Vector2(x,y)
	self.speed = speed
	self.velocity = Vector2:fromPolar(speed,direction)
	self.bounds = 10
end
function Lazer:draw()
	-- love.graphics.setColor(self.position.x/windowWidth,self.position.y/windowHeight,0)
	love.graphics.setColor(clamp(math.sin(theta),.5,1),clamp(math.cos(theta),.5,1),clamp(math.tan(theta),.5,1))
	-- love.graphics.setColor(255,255,0)
	love.graphics.circle("line",self.position.x,self.position.y,self.bounds,15)
end

Player = Class("Player")
Player.isPlayer = true
function Player:init(id,joystick,x,y,speed)
	self.id = id
	self.joystick = joystick
	self.position = Vector2(x,y)
	self.velocity = Vector2(0,0)
	self.trigger_delay = .1
	self.speed = speed
	self.bounds = 10
	self.lives = 3
	-- self.source = love.audio.newSource("res/pew.wav","static")
end
function Player:draw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.circle("line",self.position.x,self.position.y,self.bounds,30)
end