require "..libs.class"

Vector2 = Class("Vector2")
Point2 = Vector2
Vector2.isVector2 = true
function Vector2:init(x,y)
	self.x = x
	self.y = y
end
function Vector2:fromPolar(r,theta)
	local x = r * math.cos(theta)
	local y = r * math.sin(theta)
	return Vector2(x,y)
end
function Vector2:magnitude()
	return math.sqrt(self:dot(self))
end
function Vector2:direction()
	return math.atan2(self.y,self.x)
end
function Vector2:unit()
	return self / self:magnitude()
end
function Vector2:dot(other)
	return self.x * other.x + self.y * other.y
end
function Vector2:__add(other)
	return Vector2(self.x + other.x, self.y + other.y)
end
function Vector2:__sub(other)
	return Vector2(self.x - other.x, self.y - other.y)
end
function Vector2:__mul(other)
	return Vector2(self.x * other, self.y * other)
end
function Vector2:__div(other)
	return Vector2(self.x / other, self.y / other)
end
function Vector2:print()
	print("<" .. self.x .. "," .. self.y .. ">")
end

Vector3 = Class("Vector3", {"direction", "fromPolar",}, Vector2)
Point3 = Vector3
Vector3.isVector3 = true
function Vector3:init(x,y,z)
	Vector2.init(self,x,y)
	self.z = z
end
function Vector3:magnitude()
	return math.sqrt(Vector2.dot(self,self))
end
function Vector3:dot(other)
	return Vector2.dot(self,other) + self.z * other.z
end
function Vector3:cross(other)
	return Vector3(
		self.y * other.z - self.z * other.y,
		self.z * other.x - self.x * other.z,
		self.x * other.y - self.y * other.x)
end
function Vector3:__add(other)
	if self.z and other.z then
		return Vector3(self.x + other.x, self.y + other.y, self.z + other.z)
	else
		return Vector2.__add(self,other)
	end
end
function Vector3:__sub(other)
	if self.z and other.z then
		return Vector3(self.x - other.x, self.y - other.y, self.z - other.z)
	else
		return Vector2.__sub(self,other)
	end
end
function Vector3:__mul(other)
	if self.z and other.z then
		return Vector3(self.x * other, self.y * other, self.z * other)
	else
		return Vector2.__mul(self,other)
	end
end
function Vector3:__div(other)
	if self.z  and other.z then
		return Vector3(self.x / other, self.y / other, self.z / other)
	else
		return Vector2.__div(self,other)
	end
end
function Vector3:print()
	print("<" .. self.x .. "," .. self.y .. "," .. self.z .. ">")
end
Vector2.locked = true
Vector3.locked = true