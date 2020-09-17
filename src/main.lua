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
  
  -- Use canvas to draw UI elements to it
  canvas = love.graphics.newCanvas(VIRTUAL_SIZE.x, VIRTUAL_SIZE.y)
  urutora.setResolution(canvas:getWidth(), canvas:getHeight())
  
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
  urutora.update(dt)
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
  urutora.pressed(x, y)
end

function love.mousereleased(x, y, button)
  urutora.released(x, y)
end

function love.mousemoved(x, y, dx, dy)
  urutora.moved(x, y, dx, dy)
end

function love.draw()
  push:start()
  stateManager:render()
  push:finish()
  
  -- draw GUI stuff
  love.graphics.setCanvas(canvas)
  love.graphics.clear(bgColor)
  urutora.draw()
  love.graphics.setCanvas()
  love.graphics.draw(canvas, 0, 0, 0,
    love.graphics.getWidth() / canvas:getWidth(),
    love.graphics.getHeight() / canvas:getHeight()
  )
end