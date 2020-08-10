-- libraries
Class = require 'libs.class'
push = require 'libs.push'
Timer = require 'libs.knife.timer'
tiny = require 'libs.tiny'

-- data definitions
require 'defs'

-- general purpose / utility
require 'BehaviourPlayerMovingDown'
require 'BehaviourPlayerMovingLeft'
require 'BehaviourPlayerMovingRight'
require 'BehaviourPlayerMovingUp'
require 'Level'
require 'Panel'
require 'Player'
require 'PlayerController'
require 'StateDialogue'
require 'StateFade'
require 'StatePlay'
require 'StateStart'
require 'Textbox'
require 'TileMap'
require 'util'

--[[
    constants
  ]]
GAME_TITLE = 'Bug Hunter'
DEBUG_MODE = true

-- OS checks in order to make necessary adjustments to support multiplatform
MOBILE_OS = (love._version_major > 0 or love._version_minor >= 9) and (love.system.getOS() == 'Android' or love.system.getOS() == 'OS X')
WEB_OS = (love._version_major > 0 or love._version_minor >= 9) and love.system.getOS() == 'Web'
  
-- pixels resolution
WINDOW_SIZE = tiny.Vector2D(1280, 720)
VIRTUAL_SIZE = tiny.Vector2D(384, 216)
TILE_SIZE = tiny.Vector2D(16, 16)
ENTITY_SIZE = tiny.Vector2D(16, 16)

-- tile IDs
TILE_ID_GRASS = {1, 2}
TILE_ID_EMPTY = 3
TILE_ID_BUSH = 4

-- resources
FONTS = {
  ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
  ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
  ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
  ['huge'] = love.graphics.newFont('fonts/font.ttf', 64)
}

SOUNDS = {
  ['intro-music'] = love.audio.newSource('sounds/intro.mp3', WEB_OS and 'static' or 'stream')
}

TEXTURES = {
  ['aardart-back'] = love.graphics.newImage('graphics/monsters/aardart-back.png'),
  ['aardart-front'] = love.graphics.newImage('graphics/monsters/aardart-front.png'),
  ['agnite-back'] = love.graphics.newImage('graphics/monsters/agnite-back.png'),
  ['agnite-front'] = love.graphics.newImage('graphics/monsters/agnite-front.png'),
  ['anoleaf-back'] = love.graphics.newImage('graphics/monsters/anoleaf-back.png'),
  ['anoleaf-front'] = love.graphics.newImage('graphics/monsters/anoleaf-front.png'),
  ['bamboon-back'] = love.graphics.newImage('graphics/monsters/bamboon-back.png'),
  ['bamboon-front'] = love.graphics.newImage('graphics/monsters/bamboon-front.png'),
  ['cardiwing-back'] = love.graphics.newImage('graphics/monsters/cardiwing-back.png'),
  ['cardiwing-front'] = love.graphics.newImage('graphics/monsters/cardiwing-front.png'),
  ['entities'] = love.graphics.newImage('graphics/entities.png'),
  ['gui-enter'] = love.graphics.newImage('graphics/gui_enter.png'),
  ['tiles'] = love.graphics.newImage('graphics/sheet.png')
}

QUADS = {
  ['player-walk-down'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(48, 0)),
  ['player-walk-left'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(48, 16)),
  ['player-walk-right'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(48, 32)),
  ['player-walk-up'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(48, 48)),
  ['tile-bush'] = GenerateQuads(TEXTURES['tiles'], 1, 1, TILE_SIZE, tiny.Vector2D(16, 80)),
  ['tile-empty'] = GenerateQuads(TEXTURES['tiles'], 1, 1, TILE_SIZE, tiny.Vector2D(80, 192)),
  ['tiles-grass'] = GenerateQuads(TEXTURES['tiles'], 1, 2, TILE_SIZE, tiny.Vector2D(80, 80))
}