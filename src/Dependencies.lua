-- Dependencies.lua:
Class = require 'lib/class'

require 'src/menu'
require 'src/constants'

require 'src/Bird'
require 'src/Pig'
require 'src/Obstacle'
require 'src/LevelMaker'

require 'src/generateQuads'

require 'src/StateMachine'
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'
require 'src/states/VictoryState'
require 'src/states/RetryState'

all_textures = {
    ['menu'] = love.graphics.newImage('graphics/menu_angry.png'),

    ['b_menu'] = love.graphics.newImage('graphics/menu_b.png'),
    ['b_continue'] = love.graphics.newImage('graphics/continue_b.png'),
    ['b_play'] = love.graphics.newImage('graphics/play_b.png'),
    ['b_exit'] = love.graphics.newImage('graphics/exit_b.png'),

    ['back11'] = love.graphics.newImage('graphics/back11.png'),
    ['back22'] = love.graphics.newImage('graphics/back22.png'),
    ['back33'] = love.graphics.newImage('graphics/back33.png'),
    ['lodka'] = love.graphics.newImage('graphics/lodka.png'),

    ['wood'] = love.graphics.newImage('graphics/wood.png'),

    ['monster1'] = love.graphics.newImage('graphics/enem1.png'),
    ['monster2'] = love.graphics.newImage('graphics/enem2.png'),
    ['monster3'] = love.graphics.newImage('graphics/enem3.png'),

    ['bird1'] = love.graphics.newImage('graphics/gun1.png'),
    ['bird2'] = love.graphics.newImage('graphics/gun2.png')

}

all_frames = {
    ['monster1'] = GenerateQuads2(all_textures['monster1'],
                                  all_textures['monster1']:getWidth(),
                                  all_textures['monster1']:getHeight()),
    ['monster2'] = GenerateQuads2(all_textures['monster2'],
                                  all_textures['monster2']:getWidth(),
                                  all_textures['monster2']:getHeight()),
    ['monster3'] = GenerateQuads2(all_textures['monster3'],
                                  all_textures['monster3']:getWidth(),
                                  all_textures['monster3']:getHeight()),
    ['bird1'] = GenerateQuads2(all_textures['bird1'],
                               all_textures['bird1']:getWidth(),
                               all_textures['bird1']:getHeight()),
    ['bird2'] = GenerateQuads2(all_textures['bird2'],
                               all_textures['bird2']:getWidth(),
                               all_textures['bird2']:getHeight()),

    ['wood'] = {
        love.graphics.newQuad(0, 0, 110, 35,
                              all_textures['wood']:getDimensions()),
        love.graphics
            .newQuad(0, 35, 110, 35, all_textures['wood']:getDimensions()),
        love.graphics
            .newQuad(320, 180, 35, 110, all_textures['wood']:getDimensions()),
        love.graphics
            .newQuad(355, 355, 35, 110, all_textures['wood']:getDimensions())
    }
}

all_sounds = {
    ['break1'] = love.audio.newSource('sounds/break1.wav', 'static'),
    ['break2'] = love.audio.newSource('sounds/break2.wav', 'static'),
    ['break3'] = love.audio.newSource('sounds/break3.mp3', 'static'),
    ['break4'] = love.audio.newSource('sounds/break4.wav', 'static'),
    ['break5'] = love.audio.newSource('sounds/break5.wav', 'static'),
    ['bounce'] = love.audio.newSource('sounds/bounce.wav', 'static'),
    ['kill'] = love.audio.newSource('sounds/kill.wav', 'static')
}

