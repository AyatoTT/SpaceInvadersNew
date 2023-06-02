local composer = require("composer")

local scene = composer.newScene("gameover")

composer.loadScene("game")

function scene:create(event)
    local sceneGroup = self.view
    local background = display.newImageRect(sceneGroup,"background.png", display.contentCenterX, display.contentCenterY, display.contentWidth+200, display.contentHeight)
    background:setFillColor(1, 1, 1)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    background.width = display.contentWidth + 250
    background.height = display.contentHeight

    -- Создание кнопок
    --local button1 = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY + 65, 100, 35)
    --button1:setFillColor(1, 0.8, 0)

    -- Функция обработки события нажатия на кнопку

    local score2 = composer.getVariable("scorex") -- очки игрока
    -- Создание текста для кнопок
    local buttonText1 = display.newText(sceneGroup, "Ctr + R Чтобы начать заново", display.contentCenterX + 10, display.contentCenterY + 70, native.systemFont, 24)
    --buttonText1:setFillColor(1, 1, 0)
    local score2 = composer.getVariable("scorex") -- очки игрока
    local text1 = display.newText(sceneGroup, "Вы проиграли", display.contentCenterX + 15, display.contentCenterY - 10 , native.systemFont, 24)
    text1:setFillColor(1, 1, 1)
    local textScore = display.newText(sceneGroup, "Счёт:", display.contentCenterX - 15, display.contentCenterY + 30, native.systemFont, 24)
    textScore:setFillColor(1, 1, 1)
    local score = display.newText(sceneGroup, score2, display.contentCenterX + 40, display.contentCenterY + 30, native.systemFont, 22)
    score:setFillColor(1, 1, 1)

    --button1:addEventListener("tap", onButtonTap)
end

function scene:hide(event)
    local phase = event.phase
    if phase == "will" then
      -- код перед скрытием сцены
    elseif phase == "did" then
      composer.removeScene("scenes.gameover") -- удаление текущей сцены
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("hide", scene)

return scene