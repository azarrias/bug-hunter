StateStart = Class{__includes = tiny.State}

local INTRO_DIALOG = "Welcome to Bug Hunter! To start fighting monsters with your own randomly assigned" ..
  " monster, just walk in the tall grass! If you need to heal, just press 'P' in the field! " ..
  "Good luck! "

function StateStart:init()
  SOUNDS['intro-music']:setLooping(true)
  SOUNDS['intro-music']:play()
  INTRO_DIALOG = INTRO_DIALOG .. (MOBILE_OS and "(Tap screen to dismiss dialogues)" or "(Press Enter to dismiss dialogues)")
  
  -- create game object and give it a random sprite
  self.monster = tiny.Entity(VIRTUAL_SIZE.x / 2, VIRTUAL_SIZE.y / 2 + TILE_SIZE)
  local sprite = self:GetRandomMonsterSprite()
  self.monster:AddComponent(sprite)
  
  -- randomly change the sprite every 3 seconds
  self.tween = Timer.every(3, function()
    Timer.tween(0.2, {
        [self.monster.position] = { x = -TILE_SIZE * 2 }
      })
      :finish(function()
        sprite = self:GetRandomMonsterSprite()
        self.monster:AddComponent(sprite)
        self.monster.position.x = VIRTUAL_SIZE.x + TILE_SIZE
        
        Timer.tween(0.2, {
          [self.monster.position] = { x = VIRTUAL_SIZE.x / 2 }
        })
      end)
  end)
end

function StateStart:update(dt)
  if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] 
    or love.mouse.buttonReleased[1] then
    stateManager:Push(StateFade({1, 1, 1, 0 }, {1, 1, 1, 1}, 1,
      function()
        SOUNDS['intro-music']:stop()
        self.tween:remove()
        stateManager:Pop()
        
        stateManager:Push(StateFade({1, 1, 1, 1}, {1, 1, 1, 0}, 1,
          function() end))
      end))
  end
end

function StateStart:render()
  love.graphics.clear(188 / 255, 188 / 255, 188 / 255, 1)
  
  love.graphics.setColor(24 / 255, 24 / 255, 24 / 255, 1)
  love.graphics.setFont(FONTS['large'])
  love.graphics.printf(GAME_TITLE, 0, VIRTUAL_SIZE.y / 2 - 72, VIRTUAL_SIZE.x, 'center')
  love.graphics.setFont(FONTS['medium'])
  love.graphics.printf(MOBILE_OS and 'Tap' or 'Press Enter', 0, VIRTUAL_SIZE.y / 2 + 68, VIRTUAL_SIZE.x, 'center')
  
  love.graphics.setColor(45 / 255, 184 / 255, 45 / 255, 124 / 255)
  love.graphics.ellipse('fill', VIRTUAL_SIZE.x / 2, VIRTUAL_SIZE.y / 2 + 32, 72, 24)
  
  love.graphics.setColor(1, 1, 1, 1)
  self.monster:render()
end

function StateStart:GetRandomMonsterSprite()
  local monster_id = MONSTER_IDS[math.random(#MONSTER_IDS)]
  local sprite_name = MONSTER_DEFS[monster_id].battleSpriteFront
  return tiny.Sprite(TEXTURES[sprite_name])
end