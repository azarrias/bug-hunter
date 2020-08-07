Level = Class{}

function Level:init()
  self.player = self:CreatePlayer()
end

function Level:update(dt)
  self.player:update(dt)
end

function Level:render()
  self.player:render()
end

function Level:CreatePlayer()
  local player = tiny.Entity(160, 160)
  
  -- sprite component
  local playerSprite = tiny.Sprite(TEXTURES['entities'], FRAMES['player-idle-down'][1])
  player:AddComponent(playerSprite)
  
  return player
end
  
  