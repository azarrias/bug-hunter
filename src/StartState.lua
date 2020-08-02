StartState = Class{__includes = tiny.State}

function StartState:init()
  SOUNDS['intro-music']:setLooping(true)
  SOUNDS['intro-music']:play()
  
  -- create game object and give it a random sprite
  self.monster = tiny.Entity(VIRTUAL_SIZE.x / 2, VIRTUAL_SIZE.y / 2)
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

function StartState:update(dt)
end

function StartState:render()
  self.monster:render()
end

function StartState:GetRandomMonsterSprite()
  local monster_id = MONSTER_IDS[math.random(#MONSTER_IDS)]
  local sprite_name = MONSTER_DEFS[monster_id].battleSpriteFront
  return tiny.Sprite(TEXTURES[sprite_name])
end