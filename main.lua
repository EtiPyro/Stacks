--! file: main.lua
print(require("foo"))
tick = require "tick"
lume = require("lume")
local Rectangle = require "rectangle"
local Circle = require "circle"
local r1, r2
table_of_objects = {}
cursor_x = 0
cursor_y = 0
confirm_shape = 0;
shapes = {"square","circle", "other"}
shape_cycle = 0
io.stdout:setvbuf("no")

-- Load some default values for our rectangle.
function love.load()
    r1 = Rectangle(100, 100, 200, 50)
    r2 = Circle(350, 80, 40)
    world = love.physics.newWorld( 1, 1, true)
    x, y, w, h = 20, 20, 60, 20
    meme = love.graphics.newImage("meme.jpg")
    
end



-- Increase the size of the rectangle every frame.
function love.update(dt)
  --print(dt)
    w = w + 1
    h = h + 0.1
    r1:update(dt)
    r2:update(dt)
end

-- Draw a coloured rectangle.
function love.draw()
    love.graphics.setColor(0, 0.4, 0.4)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.draw(meme, x, y)
    for k,v in ipairs(table_of_objects) do
      if (v.shape:type() == "CircleShape") then
        local points = {}
        if (v.placed == false) then
          points = love.mouse.getPosition;
        else
          points = v.body:getWorldPoints(v.shape:getPoint())
        end
        love.graphics.circle("line", points[1], points[2], v.shape:getRadius())
      elseif (v.shape:type() == "PolygonShape") then
        if (v.placed == false) then
          cursor_pos = love.mouse.getPosition;
        else
          points = v.body:getWorldPoints(v.shape:getPoints())
        end
        love.graphics.polygon("line", points)
      else
        if (v.placed == false) then
          points = love.mouse.getPosition;
        else
          points = v.body:getWorldPoints(v.shape:getPoints())
        end
        love.graphics.line(points)
      end
    end
    r1:draw()
    r2:draw()
end


function love.mousepressed(cursor_x, cursor_y, button, istouch)
  if (button==1) then
      confirm_shape = 0;
      local new_object = create_object(cursor_x,cursor_y, shapes[shape_cycle+1])
      new_object.placed = false
      table_of_objects[#table_of_objects+1] = new_object
  end
end

function love.keypressed(key, scancode, isrepeat)
   if key == "escape" then
      love.event.quit()
   elseif key=="f1" then
      love.event.quit("restart")
   end
end

function love.mousereleased(cursor_x, cursor_y, button, istouch)
    if (button==1) then
      confirm_shape = 1;
      shape_cycle = shape_cycle % #shapes
      table_of_objects[#table_of_objects].placed = true;
    end
end

function create_object(obj_x, obj_y, shape)
  new_object = {}
  new_object.body = love.physics.newBody(world, obj_x, obj_y, "dynamic")
  if (shape == "square") then
    new_object.shape = love.physics.newRectangleShape(25, 25)
  elseif (shape == "circle") then
    new_object.shape = love.physics.newCircleShape(15)
  else
    new_object.shape = love.physics.newChainShape(false, obj_x, obj_y, obj_x+75, obj_y+25)
  end
  new_object.fixture = love.physics.newFixture(new_object.body, new_object.shape);
  return new_object
end