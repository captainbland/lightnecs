import strutils
import chipmunk
import basic2d



proc v(x,y:float): Vector2d = vector2d(x,y)

var gravity = v(0, -100)
var vzero = v(0,0)
var space = newSpace()
space.gravity = gravity

var ground = newSegmentShape(space.staticBody, v(-20, 5), v(20, -5), 0)
ground.setFriction(1.0)
var discarded = space.addShape(ground)

var radius = 5.0
var mass = 1.0

var moment = MomentForCircle(mass, 0, radius, vzero)

var ballBody = space.addBody(newBody(mass, moment))
ballBody.setPos(v(0, 15))

var ballShape = space.addShape(newCircleShape(ballBody, radius, vzero))
ballShape.setFriction(0.7)

var timeStep = 1.0/60.0

var time = 0.0
while time < 2:
  var pos = ballBody.getPos()
  var vel = ballBody.getVel()
  echo "Time is $#. ballBody is at ($#, $#). Its velocity is ($#, $#)".format(
    time, pos.x, pos.y, vel.x, vel.y
  )

  space.step(timeStep)

  time += timeStep

when defined chipmunkNoDestructors:
  ballShape.destroy()
  ballBody.destroy()
  ground.destroy()
  space.destroy()