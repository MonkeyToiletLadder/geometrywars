Class = {}
Class.mt = {}
setmetatable(Class,Class.mt)
Class.mt.__call = function(self,name,exclude,...)
	local class = {}
	local mandatory = {"init","parents","mt","__index","__newindex"}
	if exclude then
		for _,v in ipairs(exclude) do table.insert(mandatory,v) end
	end
	class.dead = false
	class.name = name
	class.locked = false
	class.parents = {...}
	class.__index = class
	class.mt = {}
	for _,v in pairs(class.parents) do
		for i,j in pairs(v) do
			for _,e in ipairs(mandatory) do
				if i == e then goto EXCLUDE end
			end
				class[i] = j 
				::EXCLUDE::
		end
	end
	class.mt.__call = function(self,...)
		local t = {}
		setmetatable(t,self)
		local state = class.locked
		class.locked = false
		t.init(t,...)
		class.locked = state
		return t
	end
	class.__newindex = function(t,k,v)
        if class.locked then
            error("Attempt to index "..t.name.. " a new field ".. k)
        else
            rawset(t,k,v)
        end
	end
	setmetatable(class,class.mt)
	return class
end