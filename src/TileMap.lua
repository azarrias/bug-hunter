TileMap = Class{}

function TileMap:init(width, height)
  self.width = width
  self.height = height
  self.baseTiles = {}
  self.grassTiles = {}
end

function TileMap:render()
    for y = 1, self.height do
        for x = 1, self.width do
            self.baseTiles[y][x]:render()
            self.grassTiles[y][x]:render()
        end
    end
end
