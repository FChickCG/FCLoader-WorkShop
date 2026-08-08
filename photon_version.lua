-- name: АппВершн
-- author: DarkLord
api.log("Extera photon version mod loaded")

-- Настройка Photon AppVersion (0 = выкл / оставить родную)
api.setting("appVersion", 105, 999)

local v = api.setting("appVersion")
api.log("photon appVersion set to: " .. tostring(v))
api.notify("Photon AppVersion = " .. tostring(v), 1)
