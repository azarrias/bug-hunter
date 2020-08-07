Level = Class{}

function Level:init()
  self.tileMap = self:CreateTileMap(50, 50)
  self.player = self:CreatePlayer()
end

function Level:update(dt)
  self.player:update(dt)
end

function Level:render()
  self.tileMap:render()
  self.player:render()
end

function Level:CreatePlayer()
  local player = tiny.Entity(VIRTUAL_SIZE.x / 2, 134)
  
  -- sprite component
  local playerSprite = tiny.Sprite(TEXTURES['entities'], QUADS['player-idle-down'][1])
  player:AddComponent(playerSprite)
  
  return player
end
  
function Level:CreateTileMap(columns, rows)
  local tilemap = TileMap(columns, rows)
  
  for y = 1, rows do
    table.insert(tilemap.baseTiles, {})
    table.insert(tilemap.grassTiles, {})
    
    for x = 1, columns do
      local baseTile = tiny.Entity(x * ENTITY_SIZE.x - ENTITY_SIZE.x / 2,
        y * ENTITY_SIZE.y - ENTITY_SIZE.y / 2)
      local grassTile = tiny.Entity(x * ENTITY_SIZE.x - ENTITY_SIZE.x / 2,
        y * ENTITY_SIZE.y - ENTITY_SIZE.y / 2)
      
      local baseSprite = tiny.Sprite(TEXTURES['tiles'], QUADS['tiles-grass'][math.random(#QUADS['tiles-grass'])])
      local quad = y > 10 and QUADS['tile-bush'][1] or QUADS['tile-empty'][1]
      local grassSprite = tiny.Sprite(TEXTURES['tiles'], quad)
      baseTile:AddComponent(baseSprite)
      grassTile:AddComponent(grassSprite)
      
      table.insert(tilemap.baseTiles[y], baseTile)
      table.insert(tilemap.grassTiles[y], grassTile)
    end
  end
  
  return tilemap
end