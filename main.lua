require "player"
require "bullet"
require "enemy"

score = 0 
--Things to load upon start up
function love.load(arg)
    --Loading Libraries
    player.load()

    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    love.graphics.setBackgroundColor(255,255,255)
end

function love.keypressed(key)
    -- body...
    player.shoot(key)
end

-- Collision detection function.
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function love.update(dt)
    UPDATE_PLAYER(dt)
    UPDATE_BULLET(dt)
    UPDATE_ENEMY(dt)
end

function love.draw()
    DRAW_PLAYER()
    DRAW_BULLET()
    DRAW_ENEMY()
end
