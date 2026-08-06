-- === Авто-лечение (Auto Heal) — addon by FChick ===
-- Пассивная регенерация: раз в секунду +2 HP.
-- Таймер построен на хуке урона (вызывается в бою) + api.now(),
-- поэтому не блокирует игровой поток.

api.log("Auto Heal mod loaded")

api.setting("enabled", true)      -- вкл/выкл регенерацию
api.setting("healPerSec", 2, 20)  -- сколько HP добавлять за тик

local Health = api.findClass("Health")
local healthOff = Health and api.field(Health, "m_Health") or nil

if not healthOff then
    api.log("autoheal: поле Health.m_Health не найдено (нужен дамп твоей версии)")
end

local lastTick = 0

api.chatCommand("autoheal", function(args)
    local on = api.setting("enabled")
    api.setting("enabled", not on)
    return "autoheal: " .. tostring(not on) .. " | +" .. tostring(api.setting("healPerSec")) .. " HP/s"
end)

api.chatCommand("hp", function(args)
    return "regen +" .. tostring(api.setting("healPerSec")) .. " HP/s, enabled=" .. tostring(api.setting("enabled"))
end)

-- Хук урона. RVA из дампа (0xCC0A28): self = объект, s0 = урон, a1 = источник.
-- Раз в секунду (по накопленному времени) доливаем +2 HP, если значение выглядит как ХП.
api.hookRva(0xCC0A28, function(self, a1, a2, a3, a4, a5, a6, a7, s0, s1, s2, s3)
    if not api.setting("enabled") or not healthOff then
        return nil
    end
    local now = api.now()
    if now - lastTick >= 1000 then
        local hp = api.readInt(self + healthOff)
        if hp >= 0 and hp <= 500 then
            api.writeInt(self + healthOff, hp + api.setting("healPerSec"))
            lastTick = now
        end
    end
    return nil
end)

api.log("Auto Heal ready: +" .. tostring(api.setting("healPerSec")) .. " HP/s, команда .autoheal")
