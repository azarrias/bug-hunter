BehaviourPlayerMovingDown = Class{__includes = tiny.StateMachineBehaviour}

function BehaviourPlayerMovingDown:init()
  self.name = 'BehaviourPlayerMovingDown'
  tiny.StateMachineBehaviour.init(self)
end

function BehaviourPlayerMovingDown:OnStateEnter(dt, animatorController)
end

function BehaviourPlayerMovingDown:OnStateExit(dt, animatorController)
end

function BehaviourPlayerMovingDown:OnStateUpdate(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  local bounds = VIRTUAL_SIZE.y - TILE_SIZE.y
  
  entity.position.y = entity.position.y + playerController.speed * dt
  
  -- if there is no collision, make sure that player stays within bounds
  if entity.position.y >= bounds then
    entity.position.y = bounds
  end
  
  -- there is a chance to find an encounter and enter battle while walking on bushes
  playerController:CheckForEncounter()
end