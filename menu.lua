


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
  local background = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth+200, display.contentHeight)
  background:setFillColor(0.1, 0.1, 0.1)





  local playButton = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, 200,300)
  playButton:setFillColor(1, 1, 1)
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
end

-- настройка обработчиков событий
scene:addEventListener("create", scene)

return scene

