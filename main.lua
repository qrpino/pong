-- cours du 19/10/2018

local ball = {}

local tray = {}

local trayTwo = {}

local screen = {}

local area = {}

local score = {}

local dimensions = {}

local alreadyWon

local function initScreen()

  screen.left = 0
  screen.right = love.graphics.getWidth()
  screen.up = 0
  screen.down = love.graphics.getHeight()
end


local function initArea()
  area.x = screen.right / 5
  area.y = screen.down / 5
  area.w = screen.right - area.x * 2
  area.h = screen.down - area.y * 2
end

local function initTrays()
  tray.w = 20
  tray.h = 100
  tray.x = area.x
  tray.y = area.y + (area.h / 2) - (tray.h / 2)
  tray.speed = 500

  trayTwo.w = tray.w
  trayTwo.h = tray.h
  trayTwo.x = area.w + area.x - tray.w
  trayTwo.y = area.y + (area.h / 2) - (trayTwo.h / 2)
  trayTwo.speed = tray.speed
end

local function initBall()
  ball.x = area.x + (area.w / 2)
  ball.y = area.y + (area.h / 2)
  ball.w = 10
  ball.h = 10
  ball.velocityX = 500
  ball.velocityY = 500
  ball.velocityXDefault = ball.velocityX
  ball.velocityYDefault = ball.velocityY
  ball.launch = false
end

local function initScore()
  score.pOne = 0
  score.pTwo = 0
end
local function Score()
  --   score
  if ball.x >= trayTwo.x + trayTwo.w then
    score.pOne = score.pOne + 1
    ball.velocityX = ball.velocityXDefault
    ball.velocityY = ball.velocityYDefault
    ball.launch = false
    alreadyWon = true
    tray.won = true
  elseif ball.x <= tray.x then
    score.pTwo = score.pTwo + 1
    ball.velocityX = ball.velocityXDefault
    ball.velocityY = ball.velocityYDefault
    ball.launch = false
    alreadyWon = true
    tray.won = false
  end
end
local function Collision()
  --collision ball with area
  if ball.y - ball.h <= area.y then
    ball.y = area.y + ball.h
    --
    ball.velocityY = -ball.velocityY
  elseif ball.y + ball.h >= area.h + area.y then
    ball.y = area.h + area.y - ball.h
    --
    ball.velocityY = -ball.velocityY
  end

--   collision test with tray
  if tray.y <= area.y then
    tray.y = area.y
  elseif tray.y + tray.h >= area.h + area.y then
    tray.y = area.h + area.y - tray.h
  end

  --   collision test with tray two
  if trayTwo.y <= area.y then
    trayTwo.y = area.y
  elseif trayTwo.y + trayTwo.h >= area.h + area.y then
    trayTwo.y = area.h + area.y - trayTwo.h
  end

  --  collision test with ball and tray
  if (ball.x <= tray.x + tray.w and ball.x >= tray.x) and (ball.y >= tray.y and ball.y <= tray.y + tray.h) then
    ball.x = tray.x + tray.w
    -- ball boost
    if ball.velocityX > 0 then
      ball.velocityX = ball.velocityX + 20
    elseif ball.velocityY > 0 then
      ball.velocityY = ball.velocityY + 20
    elseif ball.velocityX < 0 then
      ball.velocityX = ball.velocityX - 20
    elseif ball.velocityY < 0 then
      ball.velocityY = ball.velocityY - 20
    end
    --
    ball.velocityX = -ball.velocityX
  end

  --  collision test with ball and tray two
  if (ball.x >= trayTwo.x) and (ball.y >= trayTwo.y and ball.y <= trayTwo.y + trayTwo.h) then
    ball.x = trayTwo.x
    -- ball boost
    if ball.velocityX > 0 then
      ball.velocityX = ball.velocityX + 20
    elseif ball.velocityY > 0 then
      ball.velocityY = ball.velocityY + 20
    elseif ball.velocityX < 0 then
      ball.velocityX = ball.velocityX - 20
    elseif ball.velocityY < 0 then
      ball.velocityY = ball.velocityY - 20
    end
    --
    ball.velocityX = -ball.velocityX
  end
end
local function ballMoving(dt)
  if ball.launch == false then
    ball.x = area.x + (area.w / 2)
    ball.y = area.y + (area.h / 2)
  elseif ball.launch == true and alreadyWon == false then 
    ball.x = ball.x + (ball.velocityX * dt)
    ball.y = ball.y + (ball.velocityY * dt)
  elseif ball.launch == true and alreadyWon == true and tray.won == true then
    ball.x = ball.x + ball.velocityX * dt
    ball.y = ball.y + ball.velocityY * dt
  elseif ball.launch == true and alreadyWon == true and tray.won == false then
    ball.x = ball.x - ball.velocityX * dt
    ball.y = ball.y - ball.velocityY * dt
  end
end
local function iaPlaying(dt)
  if trayTwo.ia == true then
    if ball.y > trayTwo.y + trayTwo.h / 2 then
      trayTwo.y = trayTwo.y + trayTwo.speed * dt
    end
    if ball.y < trayTwo.y + trayTwo.h / 2 then
      trayTwo.y = trayTwo.y - trayTwo.speed * dt
    end
  end
end
local function traysKeys(dt)
  if love.keyboard.isDown("z") then
    tray.y = tray.y - tray.speed * dt
  end
  if love.keyboard.isDown("s") then
    tray.y = tray.y + tray.speed * dt
  end
  if love.keyboard.isDown("up") and trayTwo.ia == false then
    trayTwo.y = trayTwo.y - trayTwo.speed * dt
  end
  if love.keyboard.isDown("down") and trayTwo.ia == false then
    trayTwo.y = trayTwo.y + trayTwo.speed * dt
  end
end
function love.load()

  -- dimensions declaration
  initScreen()
  -- game area declaration
  initArea()

  -- trays declaration
  initTrays()


  -- ball declaration
  initBall()

  -- score initialisation
  initScore()


  dimensions.windowed = screen.right

  tray.won = false
  trayTwo.ia = true
  alreadyWon = false

end

function love.update(dt)

  -- ball moving
  ballMoving(dt)

  -- ia playing
  iaPlaying(dt)

  Score()

  traysKeys(dt)

  Collision()

end

function love.draw()
  if love.window.getFullscreen(true) then
--    screen.right = love.graphics.getWidth()
--    screen.down = love.graphics.getHeight()
--    dimensions.fullscreen = screen.right * screen.down
    love.graphics.scale((dimensions.fullscreen / (dimensions.windowed)))
  end
  love.graphics.setColor(1, 1, 1)
  -- draws ball and tray
  love.graphics.circle("fill", ball.x, ball.y, ball.w, ball.h)
  love.graphics.rectangle("fill", tray.x, tray.y, tray.w, tray.h)
  love.graphics.rectangle("fill", trayTwo.x, trayTwo.y, trayTwo.w, trayTwo.h)
  -- draws area
  love.graphics.rectangle("line", area.x, area.y, area.w, area.h)
  love.graphics.rectangle("line", area.x + (area.w / 2), area.y, 1, area.h)
  love.graphics.circle("line", area.x + (area.w / 2), area.y + (area.h / 2), 20)
  -- draws score
  love.graphics.print("Player 1 score ".. score.pOne, area.x, area.y - (area.y / 10))
  if trayTwo.ia == true then 
    love.graphics.print("I.A. score ".. score.pTwo, trayTwo.x, area.y - (area.y / 10))
  elseif trayTwo.ia == false then
    love.graphics.print("Player 2 score ".. score.pTwo, trayTwo.x, area.y - (area.y / 10))
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "f11" then
    love.window.setFullscreen(not love.window.getFullscreen())
    screen.right = love.graphics.getWidth()
    screen.down = love.graphics.getHeight()
    dimensions.fullscreen = screen.right
  elseif key == "f11" then
    love.window.setFullscreen()
  elseif trayTwo.ia == false and key == "f1" then
    trayTwo.ia = true
  elseif key == "f1" then
    trayTwo.ia = false
  elseif key == "space" then
    ball.launch = true
  end

end