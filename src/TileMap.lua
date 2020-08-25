TileMap = Class{}

function TileMap:init(width, height)
  self.width = width
  self.height = height
  self.baseTiles = {}
  self.grassTiles = {}
  self.baseSpriteBatch = nil
  self.grassSpriteBatch = nil
  self.tileQuads = {}
  
  self:CreateMap()
  self:CreateTileset()
  self:UpdateTileset()
end

function TileMap:CreateMap()
  for y = 1, self.height do
    table.insert(self.baseTiles, {})
    table.insert(self.grassTiles, {})
    
    for x = 1, self.width do
      local tile = math.random(2)
      table.insert(self.baseTiles[y], tile)
      tile = y > 10 and TILE_ID_BUSH or TILE_ID_EMPTY
      table.insert(self.grassTiles[y], tile)
    end
  end
end

function TileMap:CreateTileset()
  self.tileQuads[1] = QUADS['tiles-grass'][1]
  self.tileQuads[2] = QUADS['tiles-grass'][2]
  self.tileQuads[TILE_ID_EMPTY] = QUADS['tile-empty'][1]
  self.tileQuads[TILE_ID_BUSH] = QUADS['tile-bush'][1]

  self.baseSpriteBatch = love.graphics.newSpriteBatch(TEXTURES['tiles'], self.width * self.height)
  self.grassSpriteBatch = love.graphics.newSpriteBatch(TEXTURES['tiles'], self.width * self.height)
end

function TileMap:UpdateTileset()
  self.baseSpriteBatch:clear()
  self.grassSpriteBatch:clear()
  
  for y = 1, self.height do
    for x = 1, self.width do
      -- TODO: Add only visible tile quads to the sprite batches
      self.baseSpriteBatch:add(self.tileQuads[self.baseTiles[y][x]], (x - 1) * TILE_SIZE.x, (y - 1) * TILE_SIZE.y)
      self.grassSpriteBatch:add(self.tileQuads[self.grassTiles[y][x]], (x - 1) * TILE_SIZE.x, (y - 1) * TILE_SIZE.y)
    end
  end
  
  self.baseSpriteBatch:flush()
  self.grassSpriteBatch:flush()
end

function TileMap:render()
  love.graphics.draw(self.baseSpriteBatch)
  love.graphics.draw(self.grassSpriteBatch)
  love.graphics.setFont(FONTS['small'])
  love.graphics.print("FPS: "..love.timer.getFPS(), VIRTUAL_SIZE.x - 35, VIRTUAL_SIZE.y - 10)
end
