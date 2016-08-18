enemy = {}

enemy.timer = 0
enemy.timerLimit = math.random(3,5)
enemy.amount = math.random(1,3)
enemy.side = math.random(1,4)

function enemy.generate(dt)
    enemy.timer = enemy.timer + dt
    if enemy.timer > enemy.timerLimit  then
        --spawn an enemy
        for i=1, enemy.amount do
            if enemy.side == 1 then --left
                enemy.spawn(-10, screenHeight / 2 - 25)
            end
            if enemy.side == 2 then -- top
                enemy.spawn(screenWidth / 2 - 25, -10)
            end
            if enemy.side == 3 then -- right
                enemy.spawn(screenWidth, screenHeight / 2 - 25)
            end
            if enemy.side == 4 then -- top
                enemy.spawn(screenWidth / 2 - 25, screenHeight)
            end
            enemy.side = math.random(1,4)

        end
        enemy.amount = math.random(1,3)
        enemy.timerLimit = math.random(3,5)
        enemy.timer = 0
    end
end

enemy.width = 20
enemy.height = 20
enemy.speed = 750
enemy.friction = 9.5

function enemy.spawn(x,y)
    table.insert(enemy, {x = x, y = y, xvel = 0, yvel = 0, health = 2, width = enemy.width, height = enemy.height})
end

function enemy.draw()
    for i,v in ipairs(enemy) do
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle('fill', v.x, v.y, enemy.width, enemy.height)
    end
end

function enemy.physics(dt)
    for i,v in ipairs(enemy) do
        v.x = v.x + v.xvel * dt
        v.y = v.y + v.yvel * dt
        v.xvel = v.xvel * (1 - math.min(dt*enemy.friction, 1))
        v.yvel = v.yvel * (1 - math.min(dt*enemy.friction, 1))
    end
end

--
function enemy.AI(dt)
    for i,v in ipairs(enemy) do
        --X Axis
        if player.x + player.width / 2 < v.x + v.width / 2 then
            if v.xvel > -enemy.speed then
                v.xvel = v.xvel - enemy.speed * dt
            end
        end

        if player.x + player.width / 2 > v.x + v.width / 2 then
            if v.xvel < enemy.speed then
                v.xvel = v.xvel + enemy.speed * dt
            end
        end
        --Y Axis
        if player.y + player.height / 2 < v.y + v.height / 2 then
            if v.yvel > -enemy.speed then
                v.yvel = v.yvel - enemy.speed * dt
            end
        end
        if player.y + player.height / 2 > v.y + v.height / 2 then
            if v.yvel < enemy.speed then
                v.yvel = v.yvel + enemy.speed * dt
            end
        end
    end
end

function enemy.bullet_collide()
    for i,v in ipairs(enemy) do
        for ia,va in ipairs(bullet) do
            if CheckCollision(v.x, v.y, v.width, v.height, va.x, va.y, va.width, va.height) then
                if v.health > 0 then
                    v.health = v.health - 1
                    table.remove(bullet,ia)
                elseif v.health == 0 then
                    table.remove(enemy,i)
                    table.remove(bullet,ia)
                    score = score + 1
                end
            end
        end
    end
end

function enemy.enemy_collide()
    for i,v in ipairs(enemy) do
        for va,va in ipairs(enemy) do
            if v == va then

            elseif CheckCollision(v.x, v.y, v.width, v.height, va.x, va.y, va.width, va.height) then
                if v.x >= va.x then --enemy is to the right of collision
                    v.x = v.x + v.width
                else -- enemy is to the left of the CheckCollision
                    v.x = v.x - v.width
                end
                if v.y >= va.y then -- enemy is below the collision
                    v.y = v.y + v.height
                else  -- enemy is above the collision
                    v.y = v.y - v.height
                end
            end
        end
    end
end
--Parent functions
function DRAW_ENEMY()
    enemy.draw()
end
function UPDATE_ENEMY(dt)
    enemy.physics(dt)
    enemy.AI(dt)
    enemy.generate(dt)
    enemy.bullet_collide()
    enemy.enemy_collide()
end
