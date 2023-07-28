--- Imports
local Class = require("lib.external.class")
local Point2D = Class("Point2D")
local Vector2D = Class("Vector2D")
local safety = require("lib.safety")
local math=math
--- Compares 2 Point2Ds by comparing their individual coordinates
-- @param point1 the first point
-- @param point2 the second point
Point2D.__eq = function (point1, point2)
	safety.ensureInstanceType(point1, Point2D, "point1")
	safety.ensureInstanceType(point2, Point2D, "point2")
	return point1.x==point2.x and point1.y==point2.y
end
--- Turns a Point2D into a string, listing it's coordinates
-- @param point the point to turn into a string
Point2D.__tostring = function (point)
	return "2D Point: {" .. point.x .. ", " .. point.y .. "}"
end

function Point2D:initialize(x, y)
	safety.ensureNumber(x, "x")
	safety.ensureNumber(y, "y")
	self.x=x
	self.y=y
end
--- Compares 2 Vector2Ds by comparing their individual components
-- @param vector1 the first vector
-- @param vector2 the second vector
Vector2D.__eq = function (vector1, vector2)
	safety.ensureInstanceType(vector1, Vector2D, "vector1")
	safety.ensureInstanceType(vector2, Vector2D, "vector2")
	return vector1.x==vector2.x and vector1.y==vector2.y
end
--- Turns a Vector2D into a strign, listing it's components in both cartesian and polar forms.
-- @param vector the point to turn into a string
Vector2D.__tostring= function (vector)
	return "2D Vector: {X " .. vector.x .. ", Y " .. vector.y .. ", Angle (Radians) " ..   vector:getAngle()   .. ", MAGNITUDE " .. vector:getMagnitude() .. "}"
end
--- Returns the magnitude of the Vector2D
-- @return the magnitude
function Vector2D:getMagnitude()
	return  ( ( (self.x^2) + (self.y^2) )^0.5 )
end
--- Returns the angle of the Vector2D in radians
-- @return the angle in radians
function Vector2D:getAngle()
	return math.atan2(self.y, self.x)
end
--- A Two Dimensional Vector, able to be constructed from either cartesian or polar form.
-- @param x the x coordinate OR angle in radians if polar
-- @param y the y coordinate OR magnitude if polar
-- @param polar true if using polar form, false for cartesian
-- @return the new Vector2D
function Vector2D:initialize(x, y, polar)
	safety.ensureNumber(x, "x")
	safety.ensureNumber(y, "y")
	safety.ensureBoolean(polar, "polar")
	if (polar) then
        self.x=math.cos(x)*y
        self.y=math.sin(x)*y
     else 


        self.x=x
        self.y=y
    end
end
--- Applys one Vector2D to this Vector2D
-- @param vector the vector to apply to this one
-- @return a new Vector2D that is the result of the apply operation
function Vector2D:apply(vector)
	safety.ensureInstanceType(vector, Vector2D, "vector")
	return Vector2D(self.x+vector.x, self.y+vector.y, false)
end
--- Multiplies another Vector2D by this Vector2D
-- @param vector the vector to multiply
-- @return a new Vector2D that is the result of the multiplication
function Vector2D:multiply(vector)
	safety.ensureInstanceType(vector, Vector2D, "vector")
	return Vector2D(self.x*vector.x, self.y*vector.y, false)
end
--- Converts this Vector2D to a Point2D
-- @return the new Point2D
function Vector2D:toPoint()
	return Point2D.fromVector(self)
end
--- Creates a Vector2D from a Point2D
-- @param point the Point2D to convert
-- @return the new Vector2D
function Vector2D.fromPoint(point)
	safety.ensureInstanceType(point, Point2D, "point")
	return Vector2D(point.x, point.y, false)
end
--- Calculates the Distance between this Point and another Point
-- @param point the second point
-- @return the distance 
function Point2D:distanceToPoint(point)
	safety.ensureInstanceType(point, Point2D, "point")
	return ((self.x-point.x)^2+(self.y-point.y)^2)^ 0.5
end
--- Converts this Point2D to a Vector2D
-- @return the new Vector2D
function Point2D:toVector()
	return Vector2D.fromPoint(self)
end
--- Creates a Point2D from a Vector2D
-- @param vector the Vector2D to convert
-- @return the new Point2D
function Point2D.fromVector(vector)
	safety.ensureInstanceType(vector, Vector2D, "vector")
	return Point2D(vector.x, vector.y)
end
--- Rotates a Point2D around a center Point2D by a certain rotation in Radians
-- @param rotation the amount to rotate in radians
-- @param centerPoint the point to rotate around
-- @return the new rotated Point2D
function Point2D:rotate(rotation, centerPoint)
	safety.ensureNumber(rotation, "rotation")
	safety.ensureInstanceType(centerPoint, Point2D, "centerPoint")
	local newX= ((self.x-centerPoint.x)*math.cos(rotation) - (self.y - centerPoint.y)*math.sin(rotation)) + centerPoint.x
    local newY= ((self.xy-centerPoint.x)*math.sin(rotation) + (self.y - centerPoint.y)*math.cos(rotation)) + centerPoint.y
    return Point2D(newX, newY)
end
--- Translates a Point2D by a certain Vector2D
-- @param vector the Translation vector
-- @return the new Translated Point2D
function Point2D:translate(vector)
	safety.ensureInstanceType(vector, Vector2D, "vector")
	return Point2D(self.x+vector.x, self.y+vector.y)
end

local negativeVector = Vector2D(-1, -1, false)
--- Scales a Point2D by a certain Vector2D around a center Point2D
-- @param scaleVector the scaling Vector2D
-- @param cetnerPoint the Point2D to scale around
-- @return the new scaled Point2D
function Point2D:scale(scaleVector, centerPoint)
	safety.ensureInstanceType(scaleVector, Vector2D, "scaleVector")
	safety.ensureInstanceType(centerPoint, Point2D, "centerPoint")
	local centerVector = centerPoint:toVector():multiply(negativeVector)
	local selfVector=self:toVector()
	
	return selfVector:apply(centerVector):multiply(scaleVector):apply(centerPoint:toVector()):toPoint()
end

local out = {}
out.negativeVector=negativeVector
out.Point2D=Point2D
out.Vector2D=Vector2D
-- Allows integration of these math functions into another table, especially the global math table
-- @param math the table to integrate this module into
function out.integrate(math)
	for k, v in pairs(out) do
		if k~="integrate" then
			math[k]=v
		end
	end
	return math
end
--- Ensures that a certain named value is a Point2D
-- @param val the value to be evaluated
-- @param name the optional name of the value
function safety.ensurePoint2D(val, name)
  safety.ensureInstanceType(val, Point2D, name)
end
--- Ensures that a certain named value is a Vector2D
-- @param val the value to be evaluated
-- @param name the optional name of the value
function safety.ensureVector2D(val, name)
  safety.ensureInstanceType(val, Vector2D, name)
end
return out