



local composer = require("composer")

local scene = composer.newScene()

local physics = require("physics")
physics.start()
physics.setGravity(0,0)

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then

	elseif ( phase == "did" ) then

        composer.removeScene( "game3" )
		-- выполняется после скрытия сцены
	end
end
-- Отображение сцены
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
		--Сцена выключена но скоро появится на экран
	elseif ( phase == "did" ) then
		-- Сцена полностью загружена на экран
	end
end



function scene:create(event)
    physics.start()
    local sceneGroup = self.view
    local player -- игрок
    local bullets = {} -- массив пуль
    local bulletsE = {} -- массив пуль
    local enemies = {} -- массив инопланетных кораблей
    local background = display.newImageRect(sceneGroup,"background.png",1920,1080 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    background.width = display.contentWidth + 250
    background.height = display.contentHeight
    local score = composer.getVariable("scorex") -- очки игрока
    local lives = 3 -- количество жизней игрока
    local livesboss = 10
    local livesText = display.newText(sceneGroup,"Lives: " .. lives, display.contentWidth - 100, 20, native.systemFont, 20)
     local livesbossText = display.newText(sceneGroup,"Boss Lives: " .. livesboss, display.contentWidth + 15, 20, native.systemFont, 20)
    livesText:setFillColor(1, 1, 1) -- установка цвета текста
    local scoreText = display.newText(sceneGroup,"Score: " .. score, 10, 20, native.systemFont, 18)
    local fireSound = audio.loadSound("fire.wav") -- звук выстрела
    local hitSound = audio.loadSound("hit.wav") -- звук попадания
    audio.setVolume(0.0007, { channel = 1 })
    local shield = {} -- массив объектов защиты
    local shieldWidth = 30
    local shieldHeight = 20

    function clearArrays()
    for i = #bullets, 1, -1 do
        table.remove(bullets, i)
    end
    for i = #bulletsE, 1, -1 do
        table.remove(bulletsE, i)
    end
    for i = #enemies, 1, -1 do
        table.remove(enemies, i)
    end
    end





    -- Функция создания объектов защиты
    local function createShields()
        local shieldCount = 4 -- количество объектов защиты
        local shieldMargin = 100 -- расстояние между объектами защиты
        for i = 1, shieldCount do
            local shieldX = (display.contentWidth / shieldCount) * i - (display.contentWidth / shieldCount / 2) -- расположение объекта защиты по оси X
            local shieldY = display.contentHeight - 100 -- расположение объекта защиты по оси Y
            shield[i] = display.newRect(sceneGroup,shieldX, shieldY, shieldWidth, shieldHeight)
            shield[i].isShield = true -- установка флага, указывающего на то, что объект является защитой
            physics.addBody(shield[i], "static") -- добавление физического тела к объекту защиты
        end
    end



    -- Функция создания игрока
    local function createPlayer()
        player = display.newImageRect(sceneGroup,"player.png", 35, 35)
        player.x = display.contentCenterX
        player.y = display.contentHeight - 50 -- начальные координаты игрока
        player.isAlive = true -- флаг, указывающий, жив ли игрок
        physics.addBody(player, "kinematic", { radius = 25 })
        --player.gravityScale = 0
        player.isSensor = true
        player.isPlayer = true
    end

    -- Функция создания инопланетных кораблей
    local function createEnemies()

            local enemy2 = display.newImageRect(sceneGroup,"boss.png", 50, 50)
            enemy2.x = 100
            enemy2.y = 50
            physics.addBody(enemy2, "dynamic", { radius = 25 })
            enemy2.isenemy2 = true
            enemy2.gravityScale = 0
            table.insert(enemies, enemy2)

    end




    local function movePlayer(event)
    if (event.phase == "moved") then
        local x = event.x -- позиция пальца по оси X
        if (x > player.width / 2 - 120 and x < display.contentWidth + 120 - player.width / 2) then -- проверяем, не выходит ли игрок за границы экрана
            transition.moveTo(player, { x = x, y = player.y, time = 0 }) -- перемещаем игрока только по горизонтали
        end
    end
    end
    Runtime:addEventListener("touch", movePlayer) -- добавляем обработчик события перемещения пальца по экрану



    -- Функция создания пули
    local function createBullet()
        local bullet = display.newImageRect(sceneGroup,"bullet.png", 10, 20)
        bullet.x = player.x
        bullet.y = player.y - 30
        bullet.isBullet = true
        physics.addBody(bullet, "dynamic")
        bullet.gravityScale = 0
        table.insert(bullets, bullet)
        audio.play(fireSound)
        audio.setVolume(0.0007, { channel = 2 })
    end

    local function createBulletE()
        for i = 1, #enemies do
            local enemy2 = enemies[i]
            local bulletE = display.newImageRect(sceneGroup,"bulletE.png", 10, 20)
            bulletE.x = enemy2.x
            bulletE.y = enemy2.y + 50
            bulletE.isBulletE = true
            physics.addBody(bulletE, "dynamic")
            bulletE.gravityScale = 0
            table.insert(bulletsE, bulletE)
            audio.setVolume(0.0007, { channel = 3 })
            audio.play(fireSound,{ channel = 3 })

        end
    end


    -- Функция обработки столкновения
    local function removeenemy2(enemy2)
        for i = #enemies, 1, -1 do
            if (enemies[i] == enemy2) then
                table.remove(enemies, i)
                score = score + 10 -- увеличиваем очки игрока при уничтожении корабля
                scoreText.text = "Score: " .. score
                audio.play(hitSound)
                break
            end
        end
        display.remove(enemy2)
    end

    local function removeEnemyBullet(bulletE)
        for i = #bulletE, 1, -1 do
            if (bulletE[i] == enemy2) then
                table.remove(bulletE, i)
                score = score - 10 -- увеличиваем очки игрока при уничтожении корабля
                scoreText.text = "Score: " .. score
                audio.play(hitSound)
                break
            end
        end
        display.remove(BulletE)
    end







    -- Функция обновления пуль
    local function updateBullets()
        for i = #bullets, 1, -1 do
            local bullet = bullets[i]
            bullet.y = bullet.y - 10 -- двигаем пулю ввер

            if (bullet.y < -20) then
                display.remove(bullet)
                table.remove(bullets, i)
            end

        end
    end

    local function updateBulletsE()
        for i = #bulletsE, 1, -1 do
            local bulletE = bulletsE[i]
            bulletE.y = bulletE.y + 2 -- двигаем пулю вниз
            if (bulletE.y < 20) then
                display.remove(bulletE)
                table.remove(bulletsE, i)
            end
        end
    end






    -- Функция обновления инопланетных кораблей
    local function updateEnemies()
        for i = #enemies, 1, -1 do
            local enemy2 = enemies[i]
            --if (enemy2MoveDown) then
            --enemy2.y = enemy2.y + 10
            --end
            enemy2.x = (enemy2.x + math.sin(enemy2.y * 0.05))  -- двигаем корабль вправо-влево
            enemy2.y = enemy2.y + 0.01-- двигаем корабль вниз








            if (enemy2.y > display.contentHeight + 50) then
                display.remove(enemy2)
                table.remove(enemies, i)
                lives = lives - 1 -- уменьшаем количество жизней игрока при пропуске корабля
                livesText.text = "Lives: " .. lives
                if (lives <= 0) then
                    if (phase == "did") then


                    end
                    Runtime:removeEventListener("enterFrame", checkEnemies)
                    --timer.cancel(myTimer2)
                    composer.setVariable("scorex", score)
                    Runtime:removeEventListener("touch", movePlayer)
                    Runtime:removeEventListener("enterFrame", gameLoop)
                    Runtime:removeEventListener("collision", onCollision)
                    Runtime:removeEventListener("collision", onCollisionE)
                    composer.removeScene("game3")
                    collectgarbage()
                    composer.gotoScene("gameover")
                    --composer.showOverlay("menu")
                    display.remove(player)
                    --player.isAlive = false -- игрок погиб
                    -- здесь может быть код для окончания игры
                end
            end
        end
    end

    -- Функция обновления игры
    local function gameLoop()
        if (player.isAlive) then
            updateBullets()
            updateBulletsE()
            updateEnemies()
        end
    end

    -- Функция выпуска пуль
    local function onFire()
        if math.random(1, 100) <= 40 then -- вероятность выстрела = 40%
            createBulletE(enemy2) -- запускаем выстрел для данного врага
        end
        if (player.isAlive) then

            timer.performWithDelay(250,createBullet(),1)
            timer.performWithDelay(250,createBulletE(),1)
        end
    end
    local myTimer2 = timer.performWithDelay(550,onFire,0)

 local function onCollision(event)
        if (event.phase == "began") then
            local obj1 = event.object1
            local obj2 = event.object2
            if ((obj1.isBullet and obj2.isBulletE) or (obj1.isBulletE and obj2.isBullet)) then
                display.remove(obj1)
                display.remove(obj2)
                for i = #bullets, 1, -1 do
                if (bullets[i] == obj1 or bullets[i] == obj2) then
                    table.remove(bullets, i)
                    break
                end
                end
                for i = #bulletsE, 1, -1 do
                if (bulletsE[i] == obj1 or bulletsE[i] == obj2) then
                    table.remove(bulletsE, i)
                    break
                end
                end
            end
            if ((obj1.isBullet and obj2.isenemy2) or (obj1.isenemy2 and obj2.isBullet)) then
                if obj1.isenemy2 then
                    livesboss = livesboss - 1
                    livesbossText.text = "Boss Lives: " .. livesboss
                    display.remove(obj2)

                elseif obj2.isenemy2 then
                    livesboss = livesboss - 1
                    livesbossText.text = "Boss Lives: " .. livesboss
                    display.remove(obj1)
                end

                for i = #bullets, 1, -1 do
                    if (bullets[i] == obj1 or bullets[i] == obj2) then
                        table.remove(bullets, i)
                        break
                    end
                end

                -- удаляем врага, если его жизни опустились до нуля
                if obj2.isenemy2 and livesboss <= 0 then
                        removeenemy2(obj2)
                end
                if obj1.isenemy2 and livesboss <= 0 then
                        removeenemy2(obj1)
                end
            elseif ((obj1.isPlayer and obj2.isenemy2) or (obj1.isenemy2 and obj2.isPlayer)) then
                lives = lives - 1 -- уменьшаем количество жизней игрока при пропуске корабля
                livesText.text = "Lives: " .. lives
                if (obj1.isPlayer and obj2.isenemy2) then
                    removeenemy2(obj2)
                    for j = #bulletsE, 1, -1 do if (bulletsE[j] == obj1) then
                        table.remove(bulletsE, j)
                        break
                    end end
                elseif (obj1.isenemy2 and obj2.isPlayer) then
                    removeenemy2(obj1)
                    for j = #bulletsE, 1, -1 do if (bulletsE[j] == obj1) then
                        table.remove(bulletsE, j)
                        break
                    end end
                end
                if (lives <= 0) then
                    --player.isAlive = false -- игрок погиб
                    --lives = 3
                    livesText.text = "Lives: " .. lives
                    if (phase == "did") then




                    end
                    Runtime:removeEventListener("enterFrame", checkEnemies)
                    timer.cancel(myTimer2)
                    composer.setVariable("scorex", score)
                    Runtime:removeEventListener("touch", movePlayer)
                    Runtime:removeEventListener("enterFrame", gameLoop)
                    Runtime:removeEventListener("collision", onCollision)
                    --Runtime:removeEventListener("collision", onCollisionE)
                    composer.removeScene("game3")
                    collectgarbage()
                    composer.gotoScene("gameover")
                    --composer.showOverlay("menu")
                    display.remove(player)
                    --clearArrays()

                    -- здесь может быть код для окончания игры
                end
            elseif (obj1.isBullet and obj2.isShield) then
                display.remove(obj1)
                for i = #bullets, 1, -1 do
                    if (bullets[i] == obj1) then
                        table.remove(bullets, i)
                        break
                    end
                end
                obj2.alpha = obj2.alpha - 0.1 -- уменьшаем прозрачность объекта защиты
                if (obj2.alpha <= 0) then
                    physics.removeBody(obj2) -- удаляем физическое тело объекта защиты
                    display.remove(obj2) -- удаляем объект защиты
                    for i = #shield, 1, -1 do
                        if (shield[i] == obj2) then
                            table.remove(shield, i)
                            break
                        end
                    end
                end
            elseif (obj1.isShield and obj2.isBullet) then
                display.remove(obj2)
                for i = #bullets, 1, -1 do
                    if (bullets[i] == obj2) then
                        table.remove(bullets, i)
                        break
                    end
                end
                obj1.alpha = obj1.alpha - 0.1 -- уменьшаем прозрачность объекта защиты
                if (obj1.alpha <= 0) then
                    physics.removeBody(obj1) -- удаляем физическое тело объекта защиты
                    display.remove(obj1) -- удаляем объект защиты
                    for i = #shield, 1, -1 do
                        if (shield[i] == obj1) then
                            table.remove(shield, i)
                            break
                        end
                    end
                end
            end
        end
    end

 local function onCollisionE(event)
        if (event.phase == "began") then
            local obj1 = event.object1
            local obj2 = event.object2
            --if ((obj1.isBulletE and obj2.isPlayer) or (obj1.isPlayer and obj2.isBulletE)) then
            --    display.remove(obj1)
            --    display.remove(obj2)
            --    for i = #bulletsE, 1, -1 do
            --        if (bulletsE[i] == obj1 or bulletsE[i] == obj2) then
            --            table.remove(bulletsE, i)
            --            break
            --        end
            --    end
            if ((obj1.isPlayer and obj2.isBulletE) or (obj1.isBulletE and obj2.isPlayer)) then
                lives = lives - 1 -- уменьшаем количество жизней игрока при пропуске корабля
                livesText.text = "Lives: " .. lives
                if (obj1.isPlayer and obj2.isBulletE) then
                    display.remove(obj2) for i = #bulletsE, 1, -1 do
                    if (bulletsE[i] == obj2) then
                        table.remove(bulletsE, i)
                        break
                    end
                end
                elseif (obj1.isBulletE and obj2.isPlayer) then
                    display.remove(obj1) for i = #bulletsE, 1, -1 do
                    if (bulletsE[i] == obj1) then
                        table.remove(bulletsE, i)
                        break
                    end
                end
                end
                if (lives <= 0) then
                    --player.isAlive = false -- игрок погиб
                    --lives = 3
                    livesText.text = "Lives: " .. lives
                    if (phase == "did") then


                    end
                   Runtime:removeEventListener("enterFrame", checkEnemies)
                    timer.cancel(myTimer2)
                    composer.setVariable("scorex", score)
                    Runtime:removeEventListener("touch", movePlayer)
                    Runtime:removeEventListener("enterFrame", gameLoop )
                    Runtime:removeEventListener("collision", onCollision)
                    Runtime:removeEventListener("collision", onCollisionE)
                    composer.removeScene("game3")
                    collectgarbage()
                    composer.gotoScene("gameover")
                    --composer.showOverlay("menu")
                    display.remove(player)
                      --timer.cancel(myTimer2)

                    --clearArrays()

                    -- здесь может быть код для окончания игры
                end
            elseif (obj1.isBulletE and obj2.isShield) then
                display.remove(obj1)
                for i = #bulletsE, 1, -1 do
                    if (bulletsE[i] == obj1) then
                        table.remove(bulletsE, i)
                        break
                    end
                end
                obj2.alpha = obj2.alpha - 0.1 -- уменьшаем прозрачность объекта защиты
                if (obj2.alpha <= 0) then
                    physics.removeBody(obj2) -- удаляем физическое тело объекта защиты
                    display.remove(obj2) -- удаляем объект защиты
                    for i = #shield, 1, -1 do
                        if (shield[i] == obj2) then
                            table.remove(shield, i)
                            break
                        end
                    end
                end
            elseif (obj1.isShield and obj2.isBulletE) then
                display.remove(obj2)
                for i = #bulletsE, 1, -1 do
                    if (bulletsE[i] == obj2) then
                        table.remove(bulletsE, i)
                        break
                    end
                end
                obj1.alpha = obj1.alpha - 0.1 -- уменьшаем прозрачность объекта защиты
                if (obj1.alpha <= 0) then
                    physics.removeBody(obj1) -- удаляем физическое тело объекта защиты
                    display.remove(obj1) -- удаляем объект защиты
                    for i = #shield, 1, -1 do
                        if (shield[i] == obj1) then
                            table.remove(shield, i)
                            break
                        end
                    end
                end
            end
        end
    end




    -- Функция инициализации игры
    local function initGame()
        createPlayer()
        createEnemies()
        createShields()
        Runtime:addEventListener("collision", onCollision)
        Runtime:addEventListener("collision", onCollisionE)
        Runtime:addEventListener("enterFrame", gameLoop)
        --Runtime:addEventListener("touch", onFire)
    end


    local function checkEnemies()

       if #enemies == 0 then -- если количество врагов равно нулю
           if lives <= 0 then
               timer.cancel(myTimer2)
               Runtime:removeEventListener("enterFrame", checkEnemies)
               composer.setVariable("scorex", score)
               Runtime:removeEventListener("enterFrame", gameLoop)
               composer.gotoScene("gameover")

           end
            if  lives > 0 then
                Runtime:removeEventListener("enterFrame", checkEnemies)
                timer.cancel(myTimer2)
                composer.setVariable("scorex", score)
                Runtime:removeEventListener("touch", movePlayer)
                Runtime:removeEventListener("enterFrame", gameLoop)
                 Runtime:removeEventListener("collision", onCollision)
                Runtime:removeEventListener("collision", onCollisionE)
                composer.removeScene("game3")
                collectgarbage()
                composer.gotoScene("win")
                --composer.showOverlay("menu")
                display.remove(player)
                end
        end
    end

    Runtime:addEventListener("enterFrame", checkEnemies)




    initGame()
end

scene:addEventListener("create", scene)

scene:addEventListener( "hide", scene )
scene:addEventListener( "show", scene )

return scene


