function clamp(value,lower,upper)
	if value > upper then value = upper end
	if value < lower then value = lower end
	return value
end
function isPointWithinRect(px,py,rx,ry,rw,rh)
	return px > rx and px < rx + rw and py > ry and py < ry + rh
end
function isCircleCollision(ax,ay,ar,bx,by,br)
	local dx = ax - bx
	local dy = ay - by
	local tr = ar + br
	return dx * dx + dy * dy <= tr * tr
end