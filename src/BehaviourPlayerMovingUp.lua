BehaviourPlayerMovingUp = Class{__includes = tiny.StateMachineBehaviour}

function BehaviourPlayerMovingUp:init()
  self.name = 'BehaviourPlayerMovingUp'
  tiny.StateMachineBehaviour.init(self)
end

function BehaviourPlayerMovingUp:OnStateEnter(dt, animatorController)
end

function BehaviourPlayerMovingUp:OnStateExit(dt, animatorController)
end

function BehaviourPlayerMovingUp:OnStateUpdate(dt, animatorController)
  local entity = animatorController.entity
  local playerController = entity.components['Script']['PlayerController']
  local bounds = 0
  
  entity.position.y = entity.position.y - playerController.speed * dt
  
  -- if there is no collision, make sure that player stays within bounds
  if entity.position.y <= bounds then
    entity.position.y = bounds
  end
  
  -- there is a chance to find an encounter and enter battle while walking on bushes
  playerController:CheckForEncounter()
end