-- libraries
Class = require 'libs.class'
push = require 'libs.push'
Timer = require 'libs.knife.timer'
tiny = require 'libs.tiny'

-- data definitions
require 'defs'

-- general purpose / utility
require 'StartState'
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
TILE_SIZE = 16

-- resources
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
  ['cardiwing-front'] = love.graphics.newImage('graphics/monsters/cardiwing-front.png')
}