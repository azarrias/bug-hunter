StateStart = Class{__includes = tiny.State}

local INTRO_DIALOG = "Welcome to Bug Hunter!\n\nTo start fighting monsters with your own randomly assigned" ..
  " monster, just walk in the tall grass!\nIf you need to heal, just press 'P' in the field! " ..
  "\nGood luck!"

function StateStart:init()
  SOUNDS['intro-music']:setLooping(true)
  SOUNDS['intro-music']:play()
  
  -- create game object (only to hold the monsterController script)
  self.monster = tiny.Entity(0, 0)
  
  -- register controller script, assign sprite and keep a reference to the monster that we picked
  local monsterController = self.monster:AddScript('MonsterController')
  monsterController:SetLevel(1)
  self.monsterSprite = MonsterSprite(monsterController.monsterId..'-front', 
    VIRTUAL_SIZE.x / 2 - MONSTER_SIZE.x / 2,
    VIRTUAL_SIZE.y / 2 - MONSTER_SIZE.y / 2)
  
  -- randomly change the sprite every 3 seconds
  self.tween = Timer.every(3, function()
    Timer.tween(0.2, {
        [self.monsterSprite.position] = { x = -MONSTER_SIZE.x }
      })
      :finish(function()
        monsterController:RandomizeMonsterId()
        self.monsterSprite.texture = monsterController.monsterId..'-front'
        self.monsterSprite.position.x = VIRTUAL_SIZE.x
        
        Timer.tween(0.2, {
          [self.monsterSprite.position] = { x = VIRTUAL_SIZE.x / 2 - MONSTER_SIZE.x / 2 }
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
        
        stateManager:Push(StatePlay(self.monster))
        stateManager:Push(StateDialogue(INTRO_DIALOG))
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
  self.monsterSprite:render()
end
