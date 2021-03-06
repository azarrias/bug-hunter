require 'globals'

function love.load()
  if DEBUG_MODE then
    if arg[#arg] == "-debug" then 
      require("mobdebug").start() 
    end
    io.stdout:setvbuf("no")
  end
  
  math.randomseed(os.time())

  -- use nearest-neighbor (point) filtering on upscaling and downscaling to prevent blurring of text and 
  -- graphics instead of the bilinear filter that is applied by default 
  love.graphics.setDefaultFilter('nearest', 'nearest')
  
  -- Set up window
  push:setupScreen(VIRTUAL_SIZE.x, VIRTUAL_SIZE.y, WINDOW_SIZE.x, WINDOW_SIZE.y, {
    vsync = true,
    fullscreen = MOBILE_OS,
    resizable = not (MOBILE_OS or WEB_OS),
    stencil = not WEB_OS and true or false
  })
  love.window.setTitle(GAME_TITLE)
  
  -- use a stack for the game state machine
  -- this way, all data and behavior is preserved between state changes
  stateManager = tiny.StackFSM()
  stateManager:Push(StateStart())
  
  love.keyboard.keysPressed = {}
  love.mouse.buttonPressed = {}
  love.mouse.buttonReleased = {}
end

function love.update(dt)
  -- exit if esc is pressed
  if love.keyboard.keysPressed['escape'] then
    love.event.quit()
  end
  
  Timer.update(dt)
  if MOBILE_OS then
    urutora.update(dt)
  end
  stateManager:update(dt)
  
  love.keyboard.keysPressed = {}
  love.mouse.buttonPressed = {}
  love.mouse.buttonReleased = {}
end

function love.resize(w, h)
  push:resize(w, h)
end
  
-- Callback that processes key strokes just once
-- Does not account for keys being held down
function love.keypressed(key)
  love.keyboard.keysPressed[key] = true
end

function love.mousepressed(x, y, button)
  love.mouse.buttonPressed[button] = true
  if MOBILE_OS then
    x, y = push:toGame(x, y)
    if x and y and x > 0 and y > 0 then
      urutora.pressed(x, y)
    end
  end
end

function love.mousereleased(x, y, button)
  love.mouse.buttonReleased[button] = true
  if MOBILE_OS then
    x, y = push:toGame(x, y)
    if x and y and x > 0 and y > 0 then
      urutora.released(x, y)
    end
  end
end

function love.mousemoved(x, y, dx, dy)
  if MOBILE_OS then
    x, y = push:toGame(x, y)
    if x and y and x > 0 and y > 0 then
      urutora.moved(x, y, dx, dy)
    end
  end
end

function love.draw()
  push:start()
  stateManager:render()
  if MOBILE_OS then
    urutora.draw()
  end
  push:finish()
end