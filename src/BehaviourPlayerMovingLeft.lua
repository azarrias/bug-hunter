BehaviourPlayerMovingLeft = Class{__includes = tiny.StateMachineBehaviour}

function BehaviourPlayerMovingLeft:init()
  self.name = 'BehaviourPlayerMovingLeft'
  tiny.StateMachineBehaviour.init(self)
end

function BehaviourPlayerMovingLeft:OnStateEnter(dt, animatorController)
end

function BehaviourPlayerMovingLeft:OnStateExit(dt, animatorController)
end

function BehaviourPlayerMovingLeft:OnStateUpdate(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  local bounds = 0
      
  entity.position.x = entity.position.x - playerController.speed * dt
  
  -- if there is no collision, make sure that player stays within bounds
  if entity.position.x - ENTITY_SIZE.x / 2 <= bounds then
    entity.position.x = bounds + ENTITY_SIZE.x / 2
  end
  
  -- there is a chance to find an encounter and enter battle while walking on bushes
  playerController:CheckForEncounter()
end