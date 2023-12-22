-- StartState:
StartState = Class {__includes = BaseState}

function StartState:init()
    background = all_textures['menu']
    self.world = love.physics.newWorld(0, 500)

    self.leftWallBody = love.physics.newBody(self.world, 0, 0, 'static')
    self.rightWallBody = love.physics.newBody(self.world, 0, 0, 'static')
    self.groundBody = love.physics.newBody(self.world, 0, 0, 'static')

    self.leftWallShape = love.physics.newEdgeShape(0, 0, 0, WINDOW_HEIGHT)
    self.rightWallShape = love.physics.newEdgeShape(WINDOW_WIDTH, 0,
                                                    WINDOW_WIDTH, WINDOW_HEIGHT)
    self.groundShape = love.physics.newEdgeShape(0, WINDOW_HEIGHT, WINDOW_WIDTH,
                                                 WINDOW_HEIGHT)

    self.leftWall = love.physics.newFixture(self.leftWallBody,
                                            self.leftWallShape)
    self.rightWall = love.physics.newFixture(self.rightWallBody,
                                             self.rightWallShape)
    self.ground = love.physics.newFixture(self.groundBody, self.groundShape)

    self.sprites = {}
    buttons = {
        startGame = {
            text = "Play",
            width = 200,
            height = 50,
            x = (WINDOW_WIDTH - 200) / 2,
            y = 150,
            action = function()
                gStateMachine:change('play', {level = 1})
                self.sprites = {}

            end
        },
        exit = {
            text = "Exit",
            width = 200,
            height = 50,
            x = (WINDOW_WIDTH - 200) / 2,
            y = 250,
            action = function() love.event.quit() end
        }
    }
    self.quitRequested = false

end

function StartState:update(dt)
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
    self.world:update(dt)
    if love.keyboard.wasKeyPressed('escape') then love.event.quit() end

end

function StartState:draw()
    for _, button in pairs(buttons) do
        love.graphics.setColor(1, 1, 1)
        if button.isMouseOver then love.graphics.setColor(0.6, 0.6, 0.6) end

        if button.text == 'Play' then
            love.graphics.draw(all_textures['b_play'], button.x, button.y, 0,
                               0.4, 0.3)

        elseif button.text == 'Exit' then
            love.graphics.draw(all_textures['b_exit'], button.x, button.y, 0,
                               0.4, 0.3)
        end

        love.graphics.setColor(1, 1, 1)

    end

end

