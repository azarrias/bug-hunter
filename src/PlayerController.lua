PlayerController = Class{__includes = tiny.Script}

function PlayerController:init()
  tiny.Script.init(self, 'PlayerController')
  self.speed = 60
  self.inEncounter = false
  self.level = nil
end

function PlayerController:update(dt)
  -- update the animator controller's parameters with the given input
  local playerAnimatorController = self.entity.components['AnimatorController']
  
  local isDownDown = love.keyboard.isDown('down')
  local isDownUp = love.keyboard.isDown('up')
  local isDownLeft = love.keyboard.isDown('left')
  local isDownRight = love.keyboard.isDown('right')
  
  playerAnimatorController:SetValue('MoveDown', isDownDown)
  playerAnimatorController:SetValue('MoveUp', isDownUp)
  playerAnimatorController:SetValue('MoveLeft', isDownLeft)
  playerAnimatorController:SetValue('MoveRight', isDownRight)
end

function PlayerController:CheckForEncounter()
  local playerTile = tiny.Vector2D(math.ceil(self.entity.position.x / ENTITY_SIZE.x), 
    math.ceil(self.entity.position.y / ENTITY_SIZE.y))
  
  if self.level.tilemap.grassTiles[playerTile.y][playerTile.x] == TILE_ID_BUSH and math.random(100) == 1 then
    self.inEncounter = true
    print("Enter encounter")
  else
    self.inEncounter = false
  end
end