PlayState = Class {__includes = BaseState}

function PlayState:enter(params)
    backs = {'back11', 'back22', 'back33'}
    randomIndex = math.random(1, #backs)
    randomElement = backs[randomIndex]
    background = all_textures[randomElement]
    buttons = {
        startGame = {
            text = "Continue",
            width = 200,
            height = 50,
            x = (WINDOW_WIDTH - 200) / 2,
            y = 200,
            action = function() self.paused = not self.paused end
        },
        exit = {
            text = "Menu",
            width = 200,
            height = 50,
            x = (WINDOW_WIDTH - 200) / 2,
            y = 300,
            action = function() gStateMachine:change('start') end
        }
    }

    self.level = params.level
    self.paused = false
    self.world = love.physics.newWorld(0, 500)
    self.world:setCallbacks(beginContact)

    -- self.leftWallBody = love.physics.newBody(self.world, 0, 0, 'static')

    self.groundBody = love.physics.newBody(self.world, 0, 0, 'static')

    -- self.leftWallShape = love.physics.newEdgeShape(0, 0, 0, WINDOW_HEIGHT)
    self.rightWallShape = love.physics.newEdgeShape(WINDOW_WIDTH, 0,
                                                    WINDOW_WIDTH, WINDOW_HEIGHT)
    self.groundShape = love.physics.newEdgeShape(0, WINDOW_HEIGHT,
                                                 WINDOW_WIDTH + 500,
                                                 WINDOW_HEIGHT)

    -- self.leftWall = love.physics.newFixture(self.leftWallBody,
    --                                       self.leftWallShape)

    self.ground = love.physics.newFixture(self.groundBody, self.groundShape)

    -- self.leftWall:setUserData('Wall')

    self.ground:setUserData('Wall')
    self.flag = 0
    self.sprite = Bird(self.world, 1, WINDOW_WIDTH * 0.2, WINDOW_HEIGHT * 0.7)
    self.sprite.body:setAwake(false)

    self.obstacles = LevelMaker.createMap(self.world, self.level,
                                          self.sprite.body:getX())

    self.follow_alien = false
    self.launch_alien = false
    self.di = all_textures['lodka']:getWidth() / 2 + 45
    self.has_launched = false

    init_sprite_x = self.sprite.body:getX()
    init_sprite_y = self.sprite.body:getY()
    to_destroy = {}
    count_down = 6

end

function PlayState:update(dt)

    if love.mouse.wasPressed(1) then
        for _, button in pairs(buttons) do
            if button.isMouseOver then
                button.action()
                if button.text == "Quit" then
                    self.quitRequested = true

                end
            end
        end

    end
    local mouseX, mouseY = love.mouse.getPosition()

    for _, button in pairs(buttons) do
        button.isMouseOver = mouseX >= button.x and mouseX <= button.x +
                                 button.width and mouseY >= button.y and mouseY <=
                                 button.y + button.height
    end
    if not self.paused then
        mouse_x, mouse_y = love.mouse.getPosition()
        sprite_x = self.sprite.body:getX()
        sprite_y = self.sprite.body:getY()

        if not self.has_launched then
            if mouse_x > sprite_x - 70 and mouse_x < sprite_x + 70 and mouse_y <
                sprite_y + 70 and mouse_y > sprite_y - 70 then
                if love.mouse.wasPressed(1) then
                    self.follow_alien = true
                end
            end

            if not love.mouse.wasReleased(1) and self.follow_alien then

                mouse_x, mouse_y = love.mouse.getPosition()
                if mouse_x - init_sprite_x > 0 then
                    self.sprite.body:setX(
                        math.min(init_sprite_x + 70 + 100, mouse_x))

                else
                    self.sprite.body:setX(math.max(mouse_x,
                                                   init_sprite_x - 70 - 100))

                end
                if mouse_y - init_sprite_y > 0 then
                    self.sprite.body:setY(math.min(mouse_y,
                                                   init_sprite_y + 70 + 100))
                else
                    self.sprite.body:setY(math.max(mouse_y,
                                                   init_sprite_y - 70 - 100))
                end

            end

            if love.mouse.wasReleased(1) and self.follow_alien then

                if mouse_x > init_sprite_x - 40 and mouse_x < init_sprite_x + 40 and
                    mouse_y < init_sprite_y + 40 and mouse_y > init_sprite_y -
                    40 then
                    self.sprite.body:setX(init_sprite_x)
                    self.sprite.body:setY(init_sprite_y)
                    self.follow_alien = false
                else
                    self.launch_alien = true
                end
            end

        else

            count_down = count_down - dt

            num_pigs = 0

            for key, value in pairs(self.obstacles) do
                for key, obstacle in pairs(value) do
                    if not obstacle.body:isDestroyed() then
                        if obstacle.fixture:getUserData() == 'Pig' then
                            num_pigs = num_pigs + 1
                        end
                    end
                end
            end

            if count_down <= 0 then
                if num_pigs == 0 then
                    self.level = self.level + 1
                    gStateMachine:change('victory', {level = self.level})

                else
                    gStateMachine:change('retry', {level = self.level})
                end
            end

        end
        if self.sprite.body:getX() > WINDOW_WIDTH / 2 then
            self.sprite.body:setX(WINDOW_WIDTH / 2)
            for key, value in pairs(self.obstacles) do
                for key, obstacle in pairs(value) do
                    obstacle.body:setX(obstacle.body:getX() -
                                           self.sprite.body:getLinearVelocity() /
                                           50)

                    self.di = self.di - self.sprite.body:getLinearVelocity() /
                                  350

                end
            end
        end
        if self.launch_alien and not self.has_launched then

            self.sprite.body:setLinearVelocity(5 * (init_sprite_x - mouse_x),
                                               5 * (init_sprite_y - mouse_y))

            self.sprite.fixture:setRestitution(0.4)
            self.sprite.body:setAwake(true)
            self.has_launched = true
        end

        self.world:update(dt)

        for key, obstacle_body in pairs(to_destroy) do
            if not obstacle_body:isDestroyed() then
                obstacle_body:destroy()
            end
        end

        for key, value in pairs(self.obstacles) do
            for key, obstacle in pairs(value) do
                if obstacle.body:isDestroyed() then
                    table.remove(value, key)
                end
            end
        end

        to_destroy = {}

    end

    if love.keyboard.wasKeyPressed('escape') then

        self.paused = not self.paused
    end
end

function beginContact(a, b, coll)

    type_a = a:getUserData()
    type_b = b:getUserData()

    a_body = a:getBody()
    a_speed_x, a_speed_y = a_body:getLinearVelocity()
    a_res_speed = math.abs(a_speed_x) + math.abs(a_speed_y)

    b_body = b:getBody()
    b_speed_x, b_speed_y = b_body:getLinearVelocity()
    b_res_speed = math.abs(b_speed_x) + math.abs(b_speed_y)

    if b_res_speed > 300 or a_res_speed > 300 then
        if type_a == 'Wall' and type_b == 'Pig' then
            table.insert(to_destroy, b:getBody())
            love.audio.play(all_sounds['kill'])

        elseif type_a == 'Pig' and type_b == 'Wall' then
            table.insert(to_destroy, a:getBody())
            love.audio.play(all_sounds['kill'])

        elseif type_a == 'Pig' and type_b == 'Pig' then
            table.insert(to_destroy, a:getBody())
            table.insert(to_destroy, b:getBody())

            love.audio.play(all_sounds['kill'])

        elseif type_a == 'Wall' and type_b == 'Obstacle' then
            table.insert(to_destroy, b:getBody())
            love.audio.play(all_sounds['break1'])

        elseif type_a == 'Obstacle' and type_b == 'Obstacle' then
            table.insert(to_destroy, a:getBody())
            table.insert(to_destroy, b:getBody())
            love.audio.play(all_sounds['break1'])

        elseif type_a == 'Bird' and type_b == 'Pig' then
            table.insert(to_destroy, b:getBody())
            love.audio.play(all_sounds['kill'])

        elseif type_a == 'Bird' and type_b == 'Obstacle' then
            table.insert(to_destroy, b:getBody())
            love.audio.play(all_sounds['break1'])

        elseif type_a == 'Wall' and type_b == 'Bird' then
            love.audio.play(all_sounds['bounce'])
        end

    elseif a_res_speed < 300 and b_res_speed < 300 then

        if type_a == 'Bird' and type_b == 'Obstacle' then

            if b_body:getUserData() == 'false' then
                b_body:setUserData('true')
                love.audio.play(all_sounds['break3'])
            end

        elseif type_a == 'Wall' and type_b == 'Obstacle' then
            if b_res_speed > 200 then
                if b_body:getUserData() == 'false' then
                    b_body:setUserData('true')
                    love.audio.play(all_sounds['break3'])
                end
            end

        elseif type_a == 'Obstacle' and type_b == 'Obstacle' then
            if a_res_speed > 200 or b_res_speed > 200 then

                if a_body:getUserData() == 'false' or b_body:getUserData() ==
                    'false' then
                    b_body:setUserData('true')
                    a_body:setUserData('true')
                    love.audio.play(all_sounds['break3'])
                end
            end

        end
    end

end

function PlayState:draw()

    if not self.has_launched then

        love.graphics.draw(all_textures['lodka'], init_sprite_x -
                               all_textures['lodka']:getWidth() / 2 + 45,
                           init_sprite_y - all_textures['lodka']:getHeight() / 2 +
                               37, 0, 0.5, 0.5)
    else
        if self.sprite.body:getX() > WINDOW_WIDTH / 2 then
            love.graphics.draw(all_textures['lodka'], init_sprite_x -
                                   all_textures['lodka']:getWidth() / 2 + 45 +
                                   self.di - 220, init_sprite_y -
                                   all_textures['lodka']:getHeight() / 2 + 37,
                               0, 0.5, 0.5)
            self.flag = 1

        elseif self.flag == 0 then
            love.graphics.draw(all_textures['lodka'], init_sprite_x -
                                   all_textures['lodka']:getWidth() / 2 + 45,
                               init_sprite_y - all_textures['lodka']:getHeight() /
                                   2 + 37, 0, 0.5, 0.5)

        end

    end
    self.sprite:draw()

    for key, value in pairs(self.obstacles) do
        for key, obstacle in pairs(value) do
            if not obstacle.body:isDestroyed() then obstacle:draw() end
        end
    end
    if self.paused then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
        love.graphics.setColor(1, 1, 1, 1)
        for _, button in pairs(buttons) do
            love.graphics.setColor(1, 1, 1)
            if button.isMouseOver then
                love.graphics.setColor(0.6, 0.6, 0.6)
            end

            if button.text == 'Continue' then
                love.graphics.draw(all_textures['b_continue'], button.x,
                                   button.y, 0, 0.4, 0.3)

            elseif button.text == 'Menu' then
                love.graphics.draw(all_textures['b_menu'], button.x, button.y,
                                   0, 0.4, 0.3)
            end

            love.graphics.setColor(1, 1, 1)

        end

    end

end

