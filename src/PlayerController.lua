PlayerController = Class{__includes = tiny.Script}

function PlayerController:init()
  tiny.Script.init(self, 'PlayerController')
  self.speed = 60
  self.inEncounter = false
  self.level = nil
  self.monster = nil
  self.joystick = urutora.joy({ x = 50, y = VIRTUAL_SIZE.y / 2 - 30 / 2, w = 30, h = 30 })
  self.joystick:setStyle({
    fgColor = { 0, 0, 0, 0.3 }
  })
  self.joystick:hide()
  self.joystick:disable()
end

function PlayerController:update(dt)
  -- update the animator controller's parameters with the given input
  local playerAnimatorController = self.entity.components['AnimatorController']
  
  local isDownDown = love.keyboard.isDown('down')
  local isDownUp = love.keyboard.isDown('up')
  local isDownLeft = love.keyboard.isDown('left')
  local isDownRight = love.keyboard.isDown('right')
  
  local isJoystickDown = true and self.joystick:getY() > 0.8 or false
  local isJoystickUp = true and self.joystick:getY() < -0.8 or false
  local isJoystickLeft = true and self.joystick:getX() < -0.8 or false
  local isJoystickRight = true and self.joystick:getX() > 0.8 or false
  
  if self.inEncounter then
    playerAnimatorController:SetValue('MoveDown', false)
    playerAnimatorController:SetValue('MoveUp', false)
    playerAnimatorController:SetValue('MoveLeft', false)
    playerAnimatorController:SetValue('MoveRight', false)
  else
    if not self.joystick.enabled then
      self.joystick:enable()
      self.joystick:show()
    end
    playerAnimatorController:SetValue('MoveDown', isDownDown or isJoystickDown)
    playerAnimatorController:SetValue('MoveUp', isDownUp or isJoystickUp)
    playerAnimatorController:SetValue('MoveLeft', isDownLeft or isJoystickLeft)
    playerAnimatorController:SetValue('MoveRight', isDownRight or isJoystickRight)
  end
end

function PlayerController:CheckForEncounter()
  local playerTile = tiny.Vector2D(math.ceil(self.entity.position.x / ENTITY_SIZE.x), 
    math.ceil(self.entity.position.y / ENTITY_SIZE.y))
  
  if self.level.tilemap.grassTiles[playerTile.y][playerTile.x] == TILE_ID_BUSH and math.random(100) == 1 then
    -- trigger music changes
    SOUNDS['field-music']:pause()
    SOUNDS['battle-music']:setVolume(0.3)
    SOUNDS['battle-music']:play()
    
    -- fade in, push battle state and fade out, which will fall back to 
    -- the battle state once it pushes itself off
    stateManager:Push(
      StateFade({ 1, 1, 1, 0 }, { 1, 1, 1, 1 }, 1,
        function()
          stateManager:Push(StateBattle(self.entity))
          stateManager:Push(StateFade({ 1, 1, 1, 1 }, { 1, 1, 1, 0 }, 1,
            function() end))
        end)
    )
    self.inEncounter = true
    if self.joystick.enabled then
      -- force release of virtual joystick button to avoid unwanted movement after encounter
      urutora.released(x, y)
      self.joystick:disable()
      self.joystick:hide()
    end
  else
    self.inEncounter = false
  end
end