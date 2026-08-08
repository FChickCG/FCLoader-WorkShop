-- name: God Mode (Бессмертие)
-- author: FChick
api.log("God Mode loaded")

-- Бессмертие: урон по игроку обнуляется.
-- Метод урона ищется по имени (работает на arm64 и armv7),
-- в отличие от hookRva с RVA из дампа (arm64-only).

api.setting("god", true)               -- вкл/выкл бессмертие
api.chatCommand("god", function(args)
    local on = api.setting("god")
    api.setting("god", not on)
    return "god: " .. tostring(not on)
end)

local CANDIDATES = { "TakeDamage", "Damage", "ApplyDamage", "ReciveDamage", "ReceiveDamage", "TakeHit" }

local cls = api.findClass("DamageReciver2")
local m = nil
if cls then
    for _, name in ipairs(CANDIDATES) do
        if api.methodAddr(cls, name) then
            m = name
            break
        end
    end
end

if not m then
    local names = api.methods(cls) or {}
    api.log("GodMode: метод урона не найден. methods=" .. table.concat(names, ","))
else
    api.hook(cls, m, function(self, a1, a2, a3, a4, a5, a6, a7, s0, s1, s2, s3)
        if api.setting("god") then
            return { s0 = 0 }
        end
        return nil
    end)
    api.log("GodMode: hooked " .. m .. " (урон обнуляется)")
    api.notify("God Mode активен", 2)
end
