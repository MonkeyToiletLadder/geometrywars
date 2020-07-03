local nata = require "..libs.nata"
require "..libs.vector"
require "..libs.player"
require "..libs.enemy"
require "..libs.utility"

local state = "main"

local PhysicsSystem = {}
local JoystickSystem = {}
local CollisionSystem = {}
local SpawnerSystem = {}

function SpawnerSystem:init()
	local w, h = love.window:getMode()
	self.window_width = w
	self.window_height = h
	self.spawn_delay = 1
	self.timer = 0
end

function SpawnerSystem:update(dt)
	self.timer = self.timer + dt
	if self.timer > self.spawn_delay then
		local player = {}
		for _,e in ipairs(self.pool.groups.players.entities) do
			if e.id == 1 then
				player = e
				break
			end
		end
		self.pool:queue(Wanderer(math.random(0,self.window_width),math.random(0,self.window_height)))
		self.pool:queue(Rocket(math.random(0,self.window_width),math.random(0,self.window_height),math.random(0,3)*90*math.pi/180))
		self.pool:queue(Grunt(math.random(0,self.window_width),math.random(0,self.window_height),player))
		self.timer = 0
	end
end

function CollisionSystem:init()

end

function CollisionSystem:update(dt)
	for _,ae in ipairs(self.pool.groups.collidable.entities) do
		for _,be in ipairs(self.pool.groups.collidable.entities) do
			if ae.name == "Grunt" and be.name == "Grunt" and ae.id ~= be.id then
				local collision, direction = isCircleCollision(
					ae.position.x,ae.position.y,ae.bounds,
					be.position.x,be.position.y,be.bounds)
				if collision < 0 then
					ae.position = ae.position + Vector2:fromPolar(-collision,direction)
				end
			elseif ae.name == "Lazer" and be.isEnemy and be.ready then
				local collision, direction = isCircleCollision(
					ae.position.x,ae.position.y,ae.bounds,
					be.position.x,be.position.y,be.bounds)
				if collision < 0 then
					ae.dead = true
					be.dead = true
				end
			elseif ae.name == "Player" and be.isEnemy and be.ready then
				local collision, direction = isCircleCollision(
					ae.position.x,ae.position.y,ae.bounds,
					be.position.x,be.position.y,be.bounds)
				if collision < 0 then
					self.pool:emit("reset")
				end
			end
		end
	end
end

function PhysicsSystem:init()
	local w, h = love.window:getMode()
	self.window_width = w
	self.window_height = h
	self.enemy_delay = 1
end

function PhysicsSystem:update(dt)
	for _,e in ipairs(self.pool.groups.physical.entities) do
		if e.name == "Grunt" then
			local dx = e.target.position.x - e.position.x
			local dy = e.target.position.y - e.position.y
			local direction = math.atan2(dy,dx)
			local distance = math.sqrt(dx * dx + dy * dy)
			e.velocity = Vector2:fromPolar(e.speed,direction)
		end
		if e.name == "Rocket" then
			if e.position.x + e.bounds + 5 > self.window_width or e.position.y + e.bounds + 1 > self.window_height or e.position.x - e.bounds - 1 < 0 or e.position.y - e.bounds - 5 < 0 then
				e.direction = e.direction + math.pi
			end
			e.velocity = e.velocity:fromPolar(e.speed,e.direction)
		end
		if e.name == "Wanderer" then
			if e.timer > e.wait then
				e.direction = math.random(0,3) * 90 * math.pi / 180
				e.timer = 0
			end
			e.velocity = e.velocity:fromPolar(e.speed,e.direction)
		end
		if e.name == "Lazer" then
			if not isPointWithinRect(e.position.x,e.position.y,0,0,self.window_width,self.window_height) then
				e.dead = true
			end
		end
		if e.ready or e.name == "Player" or e.name == "Lazer" then
			e.position = e.position + e.velocity * dt
		end
		e.position.x = clamp(e.position.x,0,self.window_width)
		e.position.y = clamp(e.position.y,0,self.window_height)
	end
	for _,e in ipairs(self.pool.groups.enemies.entities) do
		e.timer = e.timer + dt
		if e.timer > self.enemy_delay then
			e.ready = true
		end
	end
end

function JoystickSystem:init()
	self.threshold = .1
	self.timer = 0
end

function JoystickSystem:update(dt)
	self.timer = self.timer + dt
	for _,e in ipairs(self.pool.groups.players.entities) do
		e.velocity = Vector2(0,0)
		local left_ax, left_ay = e.joystick:getAxes()
		if math.abs(left_ax) > self.threshold or math.abs(left_ay) > self.threshold then
			e.velocity.x = left_ax
			e.velocity.y = left_ay
			e.velocity = e.velocity:unit() * e.speed
		end
		local _,_,right_ax, right_ay = e.joystick:getAxes()
		if math.abs(right_ax) > self.threshold or math.abs(right_ay) > self.threshold then
			if self.timer > e.trigger_delay then
				self.pool:queue(Lazer(e.position.x,e.position.y,e.speed+500,math.atan2(right_ay,right_ax)))
				self.timer = 0
			end
		end
	end
end

local window_width, window_height = love.window:getMode()

local pool = nata.new{
	groups = {
		physical = {filter = {"position", "velocity"}},
		players = {filter = {"isPlayer"}},
		drawable = {filter = {"draw"}},
		collidable = {filter = {"bounds"}},
		enemies = {filter = {"isEnemy"}},
	},
	systems = {
		JoystickSystem,
		PhysicsSystem,
		CollisionSystem,
		SpawnerSystem,
	},
}
local remove = function(e)
	return e.dead
end

local window_width, window_height = love.window:getMode()

function love.load()
	local joysticks = love.joystick.getJoysticks()
	local count = 0
	for _,v in pairs(joysticks) do
		count = count + 1
		local vid,pid,pv = v:getDeviceInfo()
		if vid == 1406 and pid == 8201 and pv == 273 then --Do not use wired connection
			break
		end
		pool:queue(Player(count,v,0,0,250))
	end
	pool:on("reset",function()
		for _,e in ipairs(pool.groups.enemies.entities) do
			e.dead = true
		end
		for _,e in ipairs(pool.groups.players.entities) do
			e.position = Vector2(window_width/2,window_height/2)
		end
	end)
end
function love.update(dt)
	pool:emit("update",dt)
	pool:remove(remove)
	pool:flush()
end
function love.draw()
	for _,e in ipairs(pool.groups.drawable.entities) do
		e:draw()
	end
end