require "..libs.class"
require "..libs.vector"

Grunt = Class("Grunt")
Grunt.isEnemy = true
Grunt.count = 0
function Grunt:init(x,y,target)
	self.timer = 0
	self.ready = false
	self.position = Vector2(x,y)
	self.velocity = Vector2(0,0)
	self.speed = 100
	self.bounds = 10
	self.target = target
	self.color = {r=000/255,g=128/255,b=128/225}
	self.id = Grunt.count
	Grunt.count = Grunt.count + 1
end
function Grunt:draw()
	love.graphics.setColor(self.color.r,self.color.g,self.color.b)
	love.graphics.circle("line",self.position.x,self.position.y,self.bounds,15)
end

Rocket = Class("Rocket")
Rocket.isEnemy = true
function Rocket:init(x,y,direction)
	self.timer = 0
	self.ready = false
	self.position = Vector2(x,y)
	self.velocity = Vector2(0,0)
	self.speed = 175
	self.bounds = 10
	self.direction = direction
	self.color = {r=255/255,g=127/255,b=000/255}
end
function Rocket:draw()
	love.graphics.setColor(self.color.r,self.color.g,self.color.b)
	love.graphics.circle("line",self.position.x,self.position.y,self.bounds,15)
end

Wanderer = Class("Wanderer")
Wanderer.isEnemy = true
function Wanderer:init(x,y)
	self.timer = 0
	self.ready = false
	self.position = Vector2(x,y)
	self.velocity = Vector2(0,0)
	self.speed = 25
	self.bounds = 10
	self.direction = 0
	self.wait = 1
	self.color = {r=128/255,g=000/255,b=128/255}
end
function Wanderer:draw()
	love.graphics.setColor(self.color.r,self.color.g,self.color.b)
	love.graphics.circle("line",self.position.x,self.position.y,self.bounds,15)
end

