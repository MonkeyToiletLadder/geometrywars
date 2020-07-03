require "..libs.class"
require "..libs.vector"

Enemy = Class("Enemy")
Enemy.isEnemy = true
function Enemy:init(x,y,speed,bounds,color)
	self.position = Vector2(x,y)
	self.velocity = Vector2(0,0)
	self.speed = speed
	self.bounds = bounds
	self.color = color or {r=255,g=255,b=255}
	self.collision = false
	self.timer = 0
	self.wait = 1
	-- self.source = love.audio.newSource("res/explosion.wav","static")
end
function Enemy:update(dt)
	self.timer = self.timer + dt
	if self.timer > self.wait then self.collision = true end
end
function Enemy:draw()
	love.graphics.setColor(self.color.r,self.color.g,self.color.b)
	love.graphics.circle("line",self.position.x,self.position.y,self.bounds,15)
end
function Enemy:delete()
	-- love.audio.play(self.source)
	self = nil
end
Enemy.locked = true

Grunt = Class("Grunt",{},Enemy)
Grunt.isGrunt = true
function Grunt:init(x,y,target)
	local speed = 100
	local bounds = 10
	Enemy.init(self,x,y,speed,bounds,{r=0/255,g=255/255,b=255/255})
	self.target = target
end
function Grunt:update(dt)
	Enemy.update(self,dt)
	if self.timer > self.wait then
		local dx = self.target.position.x - self.position.x
		local dy = self.target.position.y - self.position.y
		local direction = math.atan2(dy,dx)
		self.velocity = self.velocity:fromPolar(self.speed,direction)
		self.position = self.position + self.velocity * dt
	end
end
Grunt.locked = true

Rocket = Class("Rocket",{}, Enemy)
Rocket.isRocket = true
function Rocket:init(x,y,direction)
	local speed = 175
	local bounds = 10
	Enemy.init(self,x,y,speed,bounds,{r=255/255,g=165/255,b=0/255})
	self.direction = direction
end
function Rocket:update(dt)
	Enemy.update(self,dt)
	if self.timer > self.wait then
		if self.position.x + self.bounds + 5 > windowWidth or self.position.y + self.bounds + 1 > windowHeight or self.position.x - self.bounds - 1 < 0 or self.position.y - self.bounds - 5 < 0 then
			self.direction = self.direction + math.pi
		end
		self.velocity = self.velocity:fromPolar(self.speed,self.direction)
		self.position = self.position + self.velocity * dt
		self.position.x = clamp(self.position.x,0 + self.bounds,windowWidth - self.bounds)
		self.position.y = clamp(self.position.y,0 + self.bounds,windowHeight - self.bounds)
	end
end
Rocket.locked = true