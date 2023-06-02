local composer = require("composer")

-- создание сцены
local scene = composer.newScene("menu")

-- функция обработки события нажатия на кнопку "Play"
local function onPlayButtonTap(event)
  if event.phase == "ended" then
    composer.gotoScene("game") -- переход на сцену с игрой
  end
end

-- функция отображения сцены
function scene:create(event)
  local sceneGroup = self.view

  -- создание фона
  local background = display.newImageRect(sceneGroup, "background.png", display.contentWidth, display.contentHeight)
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  local Sound = audio.loadSound("backsound.wav")
  audio.setVolume(0.02, { channel = 2 })
  audio.play(Sound)

  local playButton = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, 200, 50)
  playButton:setFillColor(0.3, 0.6, 0.8)

  local playButtonText = display.newText({
    parent = sceneGroup,
    text = "Play",
    x = display.contentCenterX,
    y = display.contentCenterY,
    font = native.systemFont,
    fontSize = 24
  })
  playButtonText:setTextColor(1, 1, 1)

  local logo = display.newImageRect(sceneGroup, "logo.png", 200, 100)
  logo.x = display.contentCenterX
  logo.y = display.contentCenterY - 120

  playButton:addEventListener("touch", onPlayButtonTap)

  -- добавление объектов в сцену
  sceneGroup:insert(background)
  sceneGroup:insert(playButton)
  sceneGroup:insert(playButtonText)
  sceneGroup:insert(logo)
end

-- настройка обработчиков событий
scene:addEventListener("create", scene)


function scene:show(event)
  local phase = event.phase
  if phase == "will" then
    self:create()

  elseif phase == "did" then

  end
end

function scene:destroy(event)
  local phase = event.phase
  if phase == "will" then
    -- Сцена будет уничтожена, переходим на сцену "gameover"

  end
end

function scene:show(event)
  local phase = event.phase
  if phase == "will" then

  end
end



scene:addEventListener("destroy", scene)
scene:addEventListener("show", scene)
scene:addEventListener("show", scene)

return scene