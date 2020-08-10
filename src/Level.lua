Level = Class{}

function Level:init()
  self.rows = 50
  self.columns = 50
  self.tilemap = TileMap(50, 50)
  self.player = self:CreatePlayer()
end

function Level:update(dt)
  self.player:update(dt)
end

function Level:render()
  self.tilemap:render()
  self.player:render()
end

function Level:CreatePlayer()
  local player = tiny.Entity(VIRTUAL_SIZE.x / 2, 134)
  
  -- sprite component
  local playerSprite = tiny.Sprite(TEXTURES['entities'], QUADS['player-idle-down'][1])
  player:AddComponent(playerSprite)
  
  return player
end
