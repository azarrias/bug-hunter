Level = Class{}

function Level:init()
  self.rows = math.ceil(VIRTUAL_SIZE.y / TILE_SIZE.y)
  self.columns = math.ceil(VIRTUAL_SIZE.x / TILE_SIZE.x)
  self.tilemap = TileMap(self.columns, self.rows)
  self.player = Player()
end

function Level:update(dt)
  self.player:update(dt)
end

function Level:render()
  self.tilemap:render()
  self.player:render()
end
