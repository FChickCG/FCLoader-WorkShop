-- === Боевой журнал (Battle Log) — addon by FChick ===
-- Считает нанесённый/полученный урон, умеет блокировать урон (god)
-- и показывает статистику в чат/уведомления.

api.log("Battle Log mod loaded")

-- Настройки (персистентные)
api.setting("god", false)          -- блокировать получаемый урон
api.setting("toast", false)        -- показывать каждый удар тостом
api.setting("notifyEvery", 5, 50)  -- через сколько ударов кидать уведомление

local dealt = 0    -- нанесено
local taken = 0    -- получено
local hits = 0     -- всего ударов

local function stats()
    return string.format("Бой: нанесено %d | получено %d | ударов %d", dealt, taken, hits)
end

-- Кнопка в меню Extera (вкладка МОДЫ)
api.guiButton("СТАТИСТИКА", function()
    api.msg(stats())
    api.notify(stats(), 2)
end)

-- Чат-команды
api.chatCommand("stats", function(args)
    return stats()
end)

api.chatCommand("god", function(args)
    local on = api.setting("god")
    api.setting("god", not on)
    return "god: " .. tostring(not on)
end)

-- Хук урона. RVA из дампа (0xCC0A28): s0 = урон, x1 (a1) = источник.
-- a1 == 0 означает, что урон пришёл в тебя.
api.hookRva(0xCC0A28, function(self, a1, a2, a3, a4, a5, a6, a7, s0, s1, s2, s3)
    hits = hits + 1
    if a1 == 0 then
        taken = taken + s0
        if api.setting("god") then
            return { s0 = 0 }
        end
    else
        dealt = dealt + s0
    end
    if api.setting("toast") then
        api.msg(string.format("урон %.1f (%s)", s0, a1 == 0 and "в тебя" or "по врагу"))
    end
    if hits % api.setting("notifyEvery") == 0 then
        api.notify(stats(), 0)
    end
    return nil
end)

api.log("Battle Log ready: .stats, .god, кнопка СТАТИСТИКА")
