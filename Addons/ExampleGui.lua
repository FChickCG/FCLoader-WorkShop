-- simple interface addon

api.log("FCloader GUI test mod loaded")

api.guiButton("Кто автор форка?", function()
    api.msg("Кнопка 1")
    api.notify("FChick (фчик)!", 2)
end)

api.guiButton("Тгк фчика", function()
    api.msg("Кнопка 2")
    api.notify("@unitygamessr", 1)
end)

api.guiButton("Кто автор ориг. модлоадера?", function()
    api.notify("DarkLord!", 3)
end)

api.log("gui buttons registered")
