Player = Class{}

function Player:init()
  self.gameObject = tiny.Entity(VIRTUAL_SIZE.x / 2, 134)
  
  -- sprite component
  local playerSprite = tiny.Sprite(TEXTURES['entities'], QUADS['player-walk-down'][2])
  self.gameObject:AddComponent(playerSprite)
  
  -- register controller script
  self.gameObject:AddScript('PlayerController')
  
  local playerAnimatorController = self:SetupAnimatorController()
  self:CreateAnimatorStateMachine(playerAnimatorController)
end

function Player:update(dt)
  self.gameObject:update(dt)
end

function Player:render()
  self.gameObject:render()
end

function Player:SetupAnimatorController()
  local playerAnimatorController = tiny.AnimatorController('PlayerAnimatorController')
  self.gameObject:AddComponent(playerAnimatorController)
  playerAnimatorController:AddParameter('MoveDown', tiny.AnimatorControllerParameterType.Bool)
  playerAnimatorController:AddParameter('MoveUp', tiny.AnimatorControllerParameterType.Bool)
  playerAnimatorController:AddParameter('MoveLeft', tiny.AnimatorControllerParameterType.Bool)
  playerAnimatorController:AddParameter('MoveRight', tiny.AnimatorControllerParameterType.Bool)
  playerAnimatorController:AddParameter("Attack", tiny.AnimatorControllerParameterType.Trigger)
  return playerAnimatorController
end
  
function Player:CreateAnimatorStateMachine(playerAnimatorController)
  -- create state machine states (first state to be created will be the default state)
  local movingFrameDuration = 0.3
  local stateIdleDown = playerAnimatorController:AddAnimation('IdleDown')
  stateIdleDown.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-down'][2])
  local stateIdleUp = playerAnimatorController:AddAnimation('IdleUp')
  stateIdleUp.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-up'][2])
  local stateIdleLeft = playerAnimatorController:AddAnimation('IdleLeft')
  stateIdleLeft.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-left'][2])
  local stateIdleRight = playerAnimatorController:AddAnimation('IdleRight')
  stateIdleRight.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-right'][2])
  local stateMovingDown = playerAnimatorController:AddAnimation('MovingDown')
  stateMovingDown.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-down'][1], movingFrameDuration)
  stateMovingDown.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-down'][2], movingFrameDuration)
  stateMovingDown.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-down'][3], movingFrameDuration)
  stateMovingDown.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-down'][2], movingFrameDuration)
  local stateMovingUp = playerAnimatorController:AddAnimation('MovingUp')
  stateMovingUp.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-up'][1], movingFrameDuration)
  stateMovingUp.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-up'][2], movingFrameDuration)
  stateMovingUp.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-up'][3], movingFrameDuration)
  stateMovingUp.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-up'][2], movingFrameDuration)
  local stateMovingLeft = playerAnimatorController:AddAnimation('MovingLeft')
  stateMovingLeft.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-left'][1], movingFrameDuration)
  stateMovingLeft.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-left'][2], movingFrameDuration)
  stateMovingLeft.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-left'][3], movingFrameDuration)
  stateMovingLeft.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-left'][2], movingFrameDuration)
  local stateMovingRight = playerAnimatorController:AddAnimation('MovingRight')
  stateMovingRight.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-right'][1], movingFrameDuration)
  stateMovingRight.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-right'][2], movingFrameDuration)
  stateMovingRight.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-right'][3], movingFrameDuration)
  stateMovingRight.animation:AddFrame(TEXTURES['entities'], QUADS['player-walk-right'][2], movingFrameDuration)

  -- animation states behaviours
  stateMovingLeft:AddStateMachineBehaviour('BehaviourPlayerMovingLeft')
  stateMovingRight:AddStateMachineBehaviour('BehaviourPlayerMovingRight')
  stateMovingUp:AddStateMachineBehaviour('BehaviourPlayerMovingUp')
  stateMovingDown:AddStateMachineBehaviour('BehaviourPlayerMovingDown')
  
  -- transitions
  local idleDownToMovingDownTransition = playerAnimatorController.stateMachine.states[stateIdleDown.name]:AddTransition(stateMovingDown)
  local idleUpToMovingDownTransition = playerAnimatorController.stateMachine.states[stateIdleUp.name]:AddTransition(stateMovingDown)
  local idleLeftToMovingDownTransition = playerAnimatorController.stateMachine.states[stateIdleLeft.name]:AddTransition(stateMovingDown)
  local idleRightToMovingDownTransition = playerAnimatorController.stateMachine.states[stateIdleRight.name]:AddTransition(stateMovingDown)
  local idleDownToMovingUpTransition = playerAnimatorController.stateMachine.states[stateIdleDown.name]:AddTransition(stateMovingUp)
  local idleUpToMovingUpTransition = playerAnimatorController.stateMachine.states[stateIdleUp.name]:AddTransition(stateMovingUp)
  local idleLeftToMovingUpTransition = playerAnimatorController.stateMachine.states[stateIdleLeft.name]:AddTransition(stateMovingUp)
  local idleRightToMovingUpTransition = playerAnimatorController.stateMachine.states[stateIdleRight.name]:AddTransition(stateMovingUp)
  local idleDownToMovingLeftTransition = playerAnimatorController.stateMachine.states[stateIdleDown.name]:AddTransition(stateMovingLeft)
  local idleUpToMovingLeftTransition = playerAnimatorController.stateMachine.states[stateIdleUp.name]:AddTransition(stateMovingLeft)
  local idleLeftToMovingLeftTransition = playerAnimatorController.stateMachine.states[stateIdleLeft.name]:AddTransition(stateMovingLeft)
  local idleRightToMovingLeftTransition = playerAnimatorController.stateMachine.states[stateIdleRight.name]:AddTransition(stateMovingLeft)
  local idleDownToMovingRightTransition = playerAnimatorController.stateMachine.states[stateIdleDown.name]:AddTransition(stateMovingRight)
  local idleUpToMovingRightTransition = playerAnimatorController.stateMachine.states[stateIdleUp.name]:AddTransition(stateMovingRight)
  local idleLeftToMovingRightTransition = playerAnimatorController.stateMachine.states[stateIdleLeft.name]:AddTransition(stateMovingRight)
  local idleRightToMovingRightTransition = playerAnimatorController.stateMachine.states[stateIdleRight.name]:AddTransition(stateMovingRight)
  local movingDownToIdleDownTransition = playerAnimatorController.stateMachine.states[stateMovingDown.name]:AddTransition(stateIdleDown)
  local movingUpToIdleUpTransition = playerAnimatorController.stateMachine.states[stateMovingUp.name]:AddTransition(stateIdleUp)
  local movingLeftToIdleLeftTransition = playerAnimatorController.stateMachine.states[stateMovingLeft.name]:AddTransition(stateIdleLeft)
  local movingRightToIdleRightTransition = playerAnimatorController.stateMachine.states[stateMovingRight.name]:AddTransition(stateIdleRight)
  
  -- transition conditions
  idleDownToMovingDownTransition:AddCondition('MoveDown', tiny.AnimatorConditionOperatorType.Equals, true)
  idleUpToMovingDownTransition:AddCondition('MoveDown', tiny.AnimatorConditionOperatorType.Equals, true)
  idleLeftToMovingDownTransition:AddCondition('MoveDown', tiny.AnimatorConditionOperatorType.Equals, true)
  idleRightToMovingDownTransition:AddCondition('MoveDown', tiny.AnimatorConditionOperatorType.Equals, true)
  idleDownToMovingUpTransition:AddCondition('MoveUp', tiny.AnimatorConditionOperatorType.Equals, true)
  idleUpToMovingUpTransition:AddCondition('MoveUp', tiny.AnimatorConditionOperatorType.Equals, true)
  idleLeftToMovingUpTransition:AddCondition('MoveUp', tiny.AnimatorConditionOperatorType.Equals, true)
  idleRightToMovingUpTransition:AddCondition('MoveUp', tiny.AnimatorConditionOperatorType.Equals, true)
  idleDownToMovingLeftTransition:AddCondition('MoveLeft', tiny.AnimatorConditionOperatorType.Equals, true)
  idleUpToMovingLeftTransition:AddCondition('MoveLeft', tiny.AnimatorConditionOperatorType.Equals, true)
  idleLeftToMovingLeftTransition:AddCondition('MoveLeft', tiny.AnimatorConditionOperatorType.Equals, true)
  idleRightToMovingLeftTransition:AddCondition('MoveLeft', tiny.AnimatorConditionOperatorType.Equals, true)
  idleDownToMovingRightTransition:AddCondition('MoveRight', tiny.AnimatorConditionOperatorType.Equals, true)
  idleUpToMovingRightTransition:AddCondition('MoveRight', tiny.AnimatorConditionOperatorType.Equals, true)
  idleLeftToMovingRightTransition:AddCondition('MoveRight', tiny.AnimatorConditionOperatorType.Equals, true)
  idleRightToMovingRightTransition:AddCondition('MoveRight', tiny.AnimatorConditionOperatorType.Equals, true)
  movingDownToIdleDownTransition:AddCondition('MoveDown', tiny.AnimatorConditionOperatorType.Equals, false)
  movingUpToIdleUpTransition:AddCondition('MoveUp', tiny.AnimatorConditionOperatorType.Equals, false)
  movingLeftToIdleLeftTransition:AddCondition('MoveLeft', tiny.AnimatorConditionOperatorType.Equals, false)
  movingRightToIdleRightTransition:AddCondition('MoveRight', tiny.AnimatorConditionOperatorType.Equals, false)
end