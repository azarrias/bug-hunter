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
require 'Menu'
require 'MenuItems'
require 'MonsterController'
require 'MonsterSprite'
require 'Panel'
require 'PlayerController'
require 'ProgressBar'
require 'StateBattle'
require 'StateBattleMenu'
require 'StateBattleMessage'
require 'StateBattleTurn'
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
MONSTER_SIZE = tiny.Vector2D(64, 64)

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
  ['battle-music'] = love.audio.newSource('sounds/battle_music.mp3', WEB_OS and 'static' or 'stream'),
  ['blip'] = love.audio.newSource('sounds/blip.wav', 'static'),
  ['exp'] = love.audio.newSource('sounds/exp.wav', 'static'),
  ['field-music'] = love.audio.newSource('sounds/field_music.wav', WEB_OS and 'static' or 'stream'),
  ['hit'] = love.audio.newSource('sounds/hit.wav', 'static'),
  ['intro-music'] = love.audio.newSource('sounds/intro.ogg', WEB_OS and 'static' or 'stream'),
  ['levelup'] = love.audio.newSource('sounds/levelup.wav', 'static'),
  ['powerup'] = love.audio.newSource('sounds/powerup.wav', 'static'),
  ['run'] = love.audio.newSource('sounds/run.wav', 'static'),
  ['victory-music'] = love.audio.newSource('sounds/victory.wav', WEB_OS and 'static' or 'stream')
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
  ['cursor'] = love.graphics.newImage('graphics/cursor.png'),
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