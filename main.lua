local composer = require("composer")

-- загрузка первой сцены
--composer.loadScene("game")
--composer.loadScene("menu")
local scene = composer.newScene("main")
composer.setVariable("scorex", 0)
composer.gotoScene("menu")