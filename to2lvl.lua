


-- подключение библиотеки comp
local composer = require("composer")

-- создание сцены
local scene = composer.newScene()

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
  local background = display.newImageRect("background.png", display.contentCenterX, display.contentCenterY, display.contentWidth+200, display.contentHeight)
  background:setFillColor(1, 1, 1)
  background.x = display.contentCenterX
  background.y = display.contentCenterY
  background.width = display.contentWidth + 250
  background.height = display.contentHeight

  local Sound = audio.loadSound("backsound.wav") -- звук попадания
  audio.setVolume(0.02,{ channel = 2 })
  audio.play(Sound)


  local playButton = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, 200,300)
  playButton:setFillColor(1, 1, 1,0.8)
  playButton.cornerRadius = 10

  local playButtonText = display.newText({
    parent = sceneGroup,
    text = "Play",
    x = display.contentCenterX,
    y = display.contentCenterY - 15,
    font = native.systemFont,
    fontSize = 24

  })
  playButtonText:setTextColor(1, 0, 0)

  local logo = display.newImageRect("logo.png", 200,100)
  logo.x = display.contentCenterX
  logo.y = display.contentCenterY - 95


  playButtonText:addEventListener("touch", onPlayButtonTap)

  -- добавление объектов в сцену
  sceneGroup:insert(background)
  sceneGroup:insert(playButton)
  sceneGroup:insert(playButtonText)
  sceneGroup:insert(logo)

  --if (phase == "did") then
  --  -- проигрывание звука на канале 1
  --  audio.play(soundEffect, { channel = 1, loops = -1 })
  --end

  function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
      -- остановка звука на канале 1
      audio.stop(1)
      -- освобождение звука
      audio.dispose(soundEffect)
      soundEffect = nil
    end




  end

end

-- настройка обработчиков событий
scene:addEventListener("create", scene)

return scene

