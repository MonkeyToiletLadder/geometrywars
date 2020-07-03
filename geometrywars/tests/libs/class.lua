Class = {}
Class.mt = {}
setmetatable(Class,Class.mt)
Class.mt.__call = function(self,name)
	local class = {}
	class.name = name
	class.locked = false
	class.__index = class
	class.mt = {}
	class.mt.__call = function(self,...)
		local t = {}
		setmetatable(t,self)
		t.init(t,...)
		return t
	end
	setmetatable(class,class.mt)
	return class
end