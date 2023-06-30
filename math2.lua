local Class = require("lib.external.class")
local Point2D = Class("Point2D")
local Vector2D = Class("Vector2D")
local safety = require("lib.safety")
local math=math
Point2D.__eq = function (point1, point2)
	safety.ensureInstanceType(point1, Point2D, "point1")
	safety.ensureInstanceType(point2, Point2D, "point2")
	return point1.x==point2.x and point1.y==point2.y
end

Point2D.__tostring = function (point)
	return "2D Point: {" .. point.x .. ", " .. point.y .. "}"
end

function Point2D:initialize(x, y)
	safety.ensureNumber(x, "x")
	safety.ensureNumber(y, "y")
	self.x=x
	self.y=y
end

Vector2D.__eq = function (vector1, vector2)
	safety.ensureInstanceType(vector1, Vector2D, "vector1")
	safety.ensureInstanceType(vector2, Vector2D, "vector2")
	return vector1.x==vector2.x and vector1.y==vector2.y
end

Vector2D.__tostring= function (vector)
	return "2D Vector: {X " .. vector.x .. ", Y " .. vector.y .. ", Angle (Radians) " ..   vector:getAngle()   .. ", MAGNITUDE " .. vector:getMagnitude() .. "}"
end

function Vector2D:getMagnitude()
	return  ( ( (self.x^2) + (self.y^2) )^0.5 )
end

function Vector2D:getAngle()
	return math.atan2(self.y, self.x)
end

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

function Vector2D:apply(vector)
	safety.ensureInstanceType(vector, Vector2D, "vector")
	return Vector2D(self.x+vector.x, self.y+vector.y, false)
end

function Vector2D:multiply(vector)
	safety.ensureInstanceType(vector, Vector2D, "vector")
	return Vector2D(self.x*vector.x, self.y*vector.y, false)
end

function Vector2D:toPoint()
	return Point2D.fromVector(self)
end

function Vector2D.fromPoint(point)
	safety.ensureInstanceType(point, Point2D, "point")
	return Vector2D(point.x, point.y, false)
end

function Point2D:distanceToPoint(point)
	safety.ensureInstanceType(point, Point2D, "point")
	return ((self.x-point.x)^2+(self.y-point.y)^2)^ 0.5
end

function Point2D:toVector()
	return Vector2D.fromPoint(self)
end

function Point2D.fromVector(vector)
	safety.ensureInstanceType(vector, Vector2D, "vector")
	return Point2D(vector.x, vector.y)
end

function Point2D:rotate(rotation, centerPoint)
	safety.ensureNumber(rotation, "rotation")
	safety.ensureInstanceType(centerPoint, Point2D, "centerPoint")
	local newX= ((self.x-centerPoint.x)*math.cos(rotation) - (self.y - centerPoint.y)*math.sin(rotation)) + centerPoint.x
    local newY= ((self.xy-centerPoint.x)*math.sin(rotation) + (self.y - centerPoint.y)*math.cos(rotation)) + centerPoint.y
    return Point2D(newX, newY)
end

function Point2D:translate(vector)
	safety.ensureInstanceType(vector, Vector2D, "vector")
	return Point2D(self.x+vector.x, self.y+vector.y)
end

local negativeVector = Vector2D(-1, -1, false)

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
function out.integrate(math)
	for k, v in pairs(out) do
		if k~="integrate" then
			math[k]=v
		end
	end
	return math
end
function safety.ensurePoint2D(val, name)
  safety.ensureInstanceType(val, Point2D, name)
end
function safety.ensureVector2D(val, name)
  safety.ensureInstanceType(val, Vector2D, name)
end
return out