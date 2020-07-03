require "..libs.class"
require "..libs.utility"
theta = 0
Lazer = Class("Lazer")
Lazer.isLazer = true
Lazer.count = 0
function Lazer:init(x,y,speed,rax,ray)
	self.position = Vector2(x,y)
	self.speed = speed
	self.velocity = Vector2(rax,ray):unit()
	local direction = self.velocity:direction() -- + math.random(-10,10) * math.pi / 180
	local magnitude = self.velocity:magnitude()
	self.velocity = self.velocity:fromPolar(magnitude,direction)
	self.id = Lazer.count
	self.bounds = 5
	Lazer.count = Lazer.count + 1
end
function Lazer:update(dt,player)
	self.position = self.position + self.velocity * self.speed * dt
	if not isPointWithinRect(self.position.x,self.position.y,0,0,windowWidth,windowHeight) then
		for i,v in ipairs(player.lazers) do
			if v.id == self.id then
				table.remove(player.lazers,i)
			end
		end
	end
end
function Lazer:draw()
	-- love.graphics.setColor(self.position.x/windowWidth,self.position.y/windowHeight,0)
	-- love.graphics.setColor(clamp(math.sin(theta),.5,1),clamp(math.cos(theta),.5,1),clamp(math.tan(theta),.5,1))
	love.graphics.setColor(255,255,0)
	love.graphics.circle("line",self.position.x,self.position.y,self.bounds,5)
end
Lazer.locked = true

Player = Class("Player")
Player.isPlayer = true
function Player:init(joystick,x,y,speed)
	self.joystick = joystick
	self.position = Vector2(x,y)
	self.velocity = Vector2(0,0)
	self.speed = speed
	self.acceleration = acceleration
	self.terminal_velocity = terminal_velocity
	self.lazzer_speed = speed + 25
	self.lazers = {}
	self.bounds = 15
	self.lives = 3
	self.timer = 0
	-- self.source = love.audio.newSource("res/pew.wav","static")
end
function Player:update(dt)
	theta = theta + .05
	self.timer = self.timer + dt
	local lax,lay = self.joystick:getAxes()
	self.velocity.x = lax
	self.velocity.y = lay
	if math.abs(lax) > .1 or math.abs(lay) > .1 then
		self.velocity = self.velocity:unit()
	end
	self.position = self.position + self.velocity * self.speed * dt
	self.position.x = clamp(self.position.x,0 + self.bounds,windowWidth - self.bounds)
	self.position.y = clamp(self.position.y,0 + self.bounds,windowHeight - self.bounds)
	local _,_,rax,ray = self.joystick:getAxes()
	if (math.abs(rax) > .1 or math.abs(ray) > .1) and self.timer > .1 then
		table.insert(self.lazers,Lazer(self.position.x,self.position.y,self.speed + 250,rax,ray))
		-- love.audio.play(self.source)
		self.timer = 0
	end
	for _,v in pairs(self.lazers) do
		v:update(dt,self)
	end
end
function Player:draw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.circle("line",self.position.x,self.position.y,self.bounds,30)
	for _,v in pairs(self.lazers) do
		v:draw()
	end
end
Player.locked = true