--! file: rectangle.lua

-- Pass Object as first argument.
Rectangle = Object.extend(Object)

function Rectangle.new(self)
    self.test = math.random(1, 1000)
end