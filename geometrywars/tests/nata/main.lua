local nata = require "..libs.nata"
require "..libs.class"
require "..libs.vector"
require "..libs.player"
require "..libs.enemy"
require "..libs.utility"

local PhysicsSystem = {}
local JoystickSystem = {}

function PhysicsSystem:init()
	local w, h = love.window:getMode()
	self.window_width = w
	self.window_height = h
end

function PhysicsSystem:update(dt)
	for _,e in ipairs(self.pool.groups.physical.entities) do
		e.position = e.position + e.velocity * dt
		e.position.x = clamp(e.position.x,0,self.window_width)
		e.position.y = clamp(e.position.y,0,self.window_height)
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
		players = {filter = {"joystick","isPlayer"}},
		drawable = {filter = {"draw"}}
	},
	systems = {
		JoystickSystem,
		PhysicsSystem
	}
}
local remove = function(e)
	if e.name == "Lazer" then
		return not isPointWithinRect(
			e.position.x,e.position.y,
			0,0,window_width,window_height)
	end
end

local window_width, window_height = love.window:getMode()

function love.load()
	joysticks = love.joystick.getJoysticks()

	for _,v in pairs(joysticks) do
		local vid,pid,pv = v:getDeviceInfo()
		if vid == 1406 and pid == 8201 and pv == 273 then --Do not use wired connection
			break
		end
		pool:queue(Player(v,0,0,250))	
	end
end
function love.update(dt)
	pool:flush()
	pool:emit("update",dt)
	pool:remove(remove)
end
function love.draw()
	for _,e in ipairs(pool.groups.drawable.entities) do
		e:draw()
	end
end