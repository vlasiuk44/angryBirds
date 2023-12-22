-- main.lua:
require 'src/Dependencies'

function love.load()
    min_dt = 1 / 60
    next_time = love.timer.getTime()

    math.randomseed(os.time())

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT,
                        {fullscreen = false, resizable = true})

    love.window.setTitle('Angry Birds')
    love.keyboard.keysPressed = {}

    background = all_textures['menu']

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['retry'] = function() return RetryState() end,
        ['victory'] = function() return VictoryState() end

    }
    gStateMachine:change('start')

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}

end

function love.update(dt)

    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}

    next_time = next_time + min_dt

end

function love.draw()

    love.graphics.draw(background, 0, 0, 0, 0.5, 0.5)

    gStateMachine:draw()

    local cur_time = love.timer.getTime()
    if next_time <= cur_time then
        next_time = cur_time
        return
    end

    love.timer.sleep(next_time - cur_time)

end

function love.mousepressed(x, y, key) love.mouse.keysPressed[key] = true end

function love.mousereleased(x, y, key) love.mouse.keysReleased[key] = true end

function love.mouse.wasPressed(key) return love.mouse.keysPressed[key] end

function love.mouse.wasReleased(key) return love.mouse.keysReleased[key] end

function love.keypressed(key) love.keyboard.keysPressed[key] = true end

function love.keyboard.wasKeyPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

