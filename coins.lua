-- name: ДохераМонет
-- author: FChick

api.log("Coins mod loaded")

api.setting("enabled", true)       -- вкл/выкл кнопку монет

-- Кнопка в меню и в майн (внутриигровая кнопка открывается через натив).
api.guiButton("🪙 Монеты", function()
    api.coinWindow()
end)

api.chatCommand("coins", function(args)
    local n = tonumber(args and args[1] or "100000")
    if not n or n <= 0 then
        return "usage: .coins <сумма>"
    end
    api.coinWindow()
    return "окно монет открыто, выдача " .. tostring(n)
end)

api.log("Coins ready: кнопка меню, .coins, окно со слайдером")
