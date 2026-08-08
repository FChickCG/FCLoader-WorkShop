-- name: ChatCommands
-- author: DarkLord
api.log("Extera chat commands mod loaded")

api.chatCommand("test", function(args)
    api.log("chat command .test args='" .. args .. "'")
    return "Привет! Это тест от Extera"
end)

api.chatCommand("hi", function(args)
    return "Привет всем! (от Extera)"
end)

api.chatCommand("god", function(args)
    api.notify("god command: nothing to do", 2)
    return nil
end)

api.chatCommand("nick", function(args)
    if args == "" then
        return "usage: .nick <имя>"
    end
    return "Меня теперь зовут " .. args
end)

api.log("chat commands registered: .test .hi .god .nick")
