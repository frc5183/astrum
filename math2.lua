--- Imports
local Class = require("lib.external.class")
local safety = require("lib.safety")
local math = math
---@class Point2D
---@field x number
---@field y number
---@overload fun(x:number, y:number):Point2D
local Point2D = Class("Point2D")
---@class Vector2D
---@field x number
---@field y number
---@overload fun(x:number, y:number, polar:boolean):Vector2D
local Vector2D = Class("Vector2D")
---@class LineSegment
---@field pt1 Point2D
---@field pt2 Point2D
---@overload fun(pt1:Point2D, pt2:Point2D):LineSegment
local LineSegment = Class("LineSegment")
--- Compares 2 Point2Ds by comparing their individual coordinates
---@param point1 Point2D
---@param point2 Point2D
---@return boolean
Point2D.__eq = function(point1, point2)
	safety.ensureInstanceType(point1, Point2D, "point1")
	safety.ensureInstanceType(point2, Point2D, "point2")
	return point1.x == point2.x and point1.y == point2.y
end
--- Turns a Point2D into a string, listing it's coordinates
---@param point Point2D
---@return string
Point2D.__tostring = function(point)
	return "2D Point: {" .. point.x .. ", " .. point.y .. "}"
end
---@param x number
---@param y number
function Point2D:initialize(x, y)
	safety.ensureNumber(x, "x")
	safety.ensureNumber(y, "y")
	self.x = x
	self.y = y
end

--- Compares 2 Vector2Ds by comparing their individual components
---@param vector1 Vector2D
---@param vector2 Vector2D
---@return boolean
Vector2D.__eq = function(vector1, vector2)
	safety.ensureInstanceType(vector1, Vector2D, "vector1")
	safety.ensureInstanceType(vector2, Vector2D, "vector2")
	return vector1.x == vector2.x and vector1.y == vector2.y
end
--- Turns a Vector2D into a string, listing it's components in both cartesian and polar forms.
---@param vector Vector2D
---@return string
Vector2D.__tostring = function(vector)
	return "2D Vector: {X " ..
		vector.x ..
		", Y " .. vector.y .. ", Angle (Radians) " .. vector:getAngle() .. ", MAGNITUDE " .. vector:getMagnitude() .. "}"
end
--- Compares 2 LineSegments by comparing their individual components
---@param line1 LineSegment
---@param line2 LineSegment
---@return boolean
LineSegment.__eq = function(line1, line2)
   safety.ensureInstanceType(line1, LineSegment, "line1")
   safety.ensureInstanceType(line2, LineSegment, "line2")
   return (line1.pt1 == line2.pt1 and line1.pt2 == line2.pt2) or (line1.pt1 == line2.pt2 and line1.pt2 == line2.pt1)
end
--- Turns a LineSegment into a string
---@param line LineSegment
---@return string
LineSegment.__tostring = function(line)
	safety.ensureInstanceType(line, LineSegment, "line")
	return "Line Segment: {pt1 " .. tostring(line.pt1) .. ", pt2, " .. tostring(line.pt2)
end
--- Returns the magnitude of the Vector2D
---@return number
function Vector2D:getMagnitude()
	return (((self.x ^ 2) + (self.y ^ 2)) ^ 0.5)
end

--- Returns the angle of the Vector2D in radians
---@return number
function Vector2D:getAngle()
	return math.atan2(self.y, self.x)
end

--- A Two Dimentional Line Seugment
---@param pt1 Point2D
---@param pt2 Point2D
function LineSegment:initialize(pt1, pt2)
	safety.ensureInstanceType(pt1, Point2D, "pt1")
	safety.ensureInstanceType(pt2, Point2D, "pt2")
	self.pt1=pt1
	self.pt2=pt2
end

--- A Two Dimensional Vector, able to be constructed from either cartesian or polar form.
---@param x number the x coordinate OR angle in radians if polar
---@param y number the y coordinate OR magnitude if polar
---@param polar boolean true if using polar form, false for cartesian
function Vector2D:initialize(x, y, polar)
	safety.ensureNumber(x, "x")
	safety.ensureNumber(y, "y")
	safety.ensureBoolean(polar, "polar")
	if (polar) then
		self.x = math.cos(x) * y
		self.y = math.sin(x) * y
	else
		self.x = x
		self.y = y
	end
end

--- Applys one Vector2D to this Vector2D
---@param vector Vector2D
---@return Vector2D
function Vector2D:apply(vector)
	safety.ensureInstanceType(vector, Vector2D, "vector")
	return Vector2D(self.x + vector.x, self.y + vector.y, false)
end

--- Multiplies another Vector2D by this Vector2D
---@param vector Vector2D
---@return Vector2D
function Vector2D:multiply(vector)
	safety.ensureInstanceType(vector, Vector2D, "vector")
	return Vector2D(self.x * vector.x, self.y * vector.y, false)
end

--- Converts this Vector2D to a Point2D
---@return Point2D
function Vector2D:toPoint()
	return Point2D.fromVector(self)
end

--- Creates a Vector2D from a Point2D
---@param point Point2D
---@return Vector2D
function Vector2D.fromPoint(point)
	safety.ensureInstanceType(point, Point2D, "point")
	return Vector2D(point.x, point.y, false)
end

--- Calculates the Distance between this Point and another Point
---@param point Point2D
---@return number
function Point2D:distanceToPoint(point)
	safety.ensureInstanceType(point, Point2D, "point")
	return ((self.x - point.x) ^ 2 + (self.y - point.y) ^ 2) ^ 0.5
end

--- Converts this Point2D to a Vector2D
---@return Vector2D
function Point2D:toVector()
	return Vector2D.fromPoint(self)
end

--- Creates a Point2D from a Vector2D
---@param vector Vector2D
---@return Point2D
function Point2D.fromVector(vector)
	safety.ensureInstanceType(vector, Vector2D, "vector")
	return Point2D(vector.x, vector.y)
end

--- Rotates a Point2D around a center Point2D by a certain rotation in Radians
---@param rotation number
---@param centerPoint Point2D
---@return Point2D
function Point2D:rotate(rotation, centerPoint)
	safety.ensureNumber(rotation, "rotation")
	safety.ensureInstanceType(centerPoint, Point2D, "centerPoint")
	---@type number
	local newX = ((self.x - centerPoint.x) * math.cos(rotation) - (self.y - centerPoint.y) * math.sin(rotation)) +
		centerPoint.x
	---@type number
	local newY = ((self.x - centerPoint.x) * math.sin(rotation) + (self.y - centerPoint.y) * math.cos(rotation)) +
		centerPoint.y
	return Point2D(newX, newY)
end

--- Translates a Point2D by a certain Vector2D
---@param vector Vector2D
---@return Point2D
function Point2D:translate(vector)
	safety.ensureInstanceType(vector, Vector2D, "vector")
	return Point2D(self.x + vector.x, self.y + vector.y)
end

---@type Vector2D
local negativeVector = Vector2D(-1, -1, false)
--- Scales a Point2D by a certain Vector2D around a center Point2D
---@param scaleVector Vector2D
---@param centerPoint Point2D
---@return Point2D
function Point2D:scale(scaleVector, centerPoint)
	safety.ensureInstanceType(scaleVector, Vector2D, "scaleVector")
	safety.ensureInstanceType(centerPoint, Point2D, "centerPoint")
	---@type Vector2D
	local centerVector = centerPoint:toVector():multiply(negativeVector)
	---@type Vector2D
	local selfVector = self:toVector()

	return selfVector:apply(centerVector):multiply(scaleVector):apply(centerPoint:toVector()):toPoint()
end

---@type table
local out = {}
out.negativeVector = negativeVector
out.Point2D = Point2D
out.Vector2D = Vector2D
--- Allows integration of these math functions into another table, especially the global math table
---@param _math table
---@return table
function out.integrate(_math)
	for k, v in pairs(out) do
		if k ~= "integrate" then
			_math[k] = v
		end
	end
	return _math
end

--- Ensures that a certain named value is a Point2D
---@param val any
---@param name string|nil
function safety.ensurePoint2D(val, name)
	safety.ensureInstanceType(val, Point2D, name)
end

--- Ensures that a certain named value is a Vector2D
---@param val any
---@param name string|nil
function safety.ensureVector2D(val, name)
	safety.ensureInstanceType(val, Vector2D, name)
end

return out
