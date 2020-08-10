BehaviourPlayerMovingRight = Class{__includes = tiny.StateMachineBehaviour}

function BehaviourPlayerMovingRight:init()
  self.name = 'BehaviourPlayerMovingRight'
  tiny.StateMachineBehaviour.init(self)
end

function BehaviourPlayerMovingRight:OnStateEnter(dt, animatorController)
end

function BehaviourPlayerMovingRight:OnStateExit(dt, animatorController)
end

function BehaviourPlayerMovingRight:OnStateUpdate(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  local bounds = VIRTUAL_SIZE.x - TILE_SIZE.x
  
  entity.position.x = entity.position.x + playerController.speed * dt
  
  -- if there is no collision, make sure that player stays within bounds
  if entity.position.x - ENTITY_SIZE.x / 2 >= bounds then
    entity.position.x = bounds + ENTITY_SIZE.x / 2
  end
end