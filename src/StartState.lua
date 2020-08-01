StartState = Class{__includes = tiny.State}

function StartState:init()
  SOUNDS['intro-music']:setLooping(true)
  SOUNDS['intro-music']:play()
  
  local monster_id = MONSTER_IDS[math.random(#MONSTER_IDS)]
  local sprite_name = MONSTER_DEFS[monster_id].battleSpriteFront
  local sprite = tiny.Sprite(TEXTURES[sprite_name])
  self.monster = tiny.Entity(VIRTUAL_SIZE.x / 2, VIRTUAL_SIZE.y / 2)
  self.monster:AddComponent(sprite)
end

function StartState:update(dt)
end

function StartState:render()
  self.monster:render()
end