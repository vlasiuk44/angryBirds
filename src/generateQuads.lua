-- generateQuads.lua
function GenerateQuads2(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local spritesheet = {}

    spritesheet[0] = love.graphics.newQuad(1, 1, tilewidth, tileheight,
                                           atlas:getDimensions())

    return spritesheet
end
