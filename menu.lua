


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

  -- создание кнопки "Play"
  local playButton = display.newText(sceneGroup, "Play", display.contentCenterX, display.contentCenterY, native.systemFont, 28)
  playButton:setFillColor(0, 1, 1)
  playButton:addEventListener("touch", onPlayButtonTap)

  -- добавление объектов в сцену
  sceneGroup:insert(background)
  sceneGroup:insert(playButton)
end

-- настройка обработчиков событий
scene:addEventListener("create", scene)

return scene

