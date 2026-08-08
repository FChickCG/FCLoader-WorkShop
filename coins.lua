-- name: Монеты (Coins)
-- author: FChick
-- === Монеты (Coins) — addon by FChick ===
-- Выдача через нативный auto-search GiveMoney/currencyBalance (без перечисления
-- методов — не падает на некоторых устройствах).
-- Настройки: amount (сумма), enabled (показ кнопки).

api.log("Coins mod loaded")

api.setting("enabled", true)                -- вкл/выкл кнопку монет
api.setting("amount", 100000)               -- сумма выдачи

-- Кнопка в меню и в майн.
api.guiButton("🪙 Монеты", function()
    api.coinWindow()
end)

api.addButton("Выдать монеты", function()
    local n = tonumber(api.setting("amount")) or 100000
    if n <= 0 then
        return
    end
    api.LocalStore_GiveMoney(nil, n)
    api.log("Выдано монет: " .. tostring(n))
end)

api.chatCommand(".coins", function(args)
    local n = tonumber(args and args[1] or api.setting("amount"))
    if not n or n <= 0 then
        return "usage: .coins <сумма>"
    end
    api.LocalStore_GiveMoney(nil, n)
    return "выдано монет: " .. tostring(n)
end)

api.log("Coins ready: кнопка меню, .coins, LocalStore_GiveMoney")
