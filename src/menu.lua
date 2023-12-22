function love.load()
    screenWidth, screenHeight = love.graphics.getDimensions()

    buttons = {
        startGame = {
            text = "Начать игру",
            width = 200,
            height = 50,
            x = (screenWidth - 200) / 2,
            y = 200,
            action = function() print("Игра началась!") end
        },
        exit = {
            text = "Выйти",
            width = 200,
            height = 50,
            x = (screenWidth - 200) / 2,
            y = 300,
            action = function() love.event.quit() end
        }
    }
end

function love.update(dt)

    local mouseX, mouseY = love.mouse.getPosition()

    for _, button in pairs(buttons) do
        button.isMouseOver = mouseX >= button.x and mouseX <= button.x +
                                 button.width and mouseY >= button.y and mouseY <=
                                 button.y + button.height
    end
end

function love.draw()

    for _, button in pairs(buttons) do
        love.graphics.setColor(0.4, 0.4, 0.4)
        if button.isMouseOver then love.graphics.setColor(0.6, 0.6, 0.6) end

        love.graphics.rectangle("fill", button.x, button.y, button.width,
                                button.height)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(button.text, button.x + 10, button.y + 10)
    end
end

