-- name: WorkingServers
-- author: FChick
-- === WorkingServers — автонастройка Photon серверов ===
-- Автоматически ставит кастомный Photon AppId (сервера).
-- Работает через встроенный механизм загрузчика: файл
--   ExteraMods/photon_appid.txt
-- который читает native-хук Photon.Realtime.AppSettings.get_AppIdRealtime.

api.log("WorkingServers mod loaded")

local APPID = "4459e6bb-5706-4f98-bbbd-9d9f1bc5d4ae"
local APPID_FILE = "/sdcard/Android/data/com.promptycompany.ExteraCGForkFChick/files/ExteraMods/photon_appid.txt"

local function writeAppId(path)
    local f = io.open(path, "w")
    if not f then
        return false
    end
    f:write(APPID .. "\n")
    f:close()
    return true
end

-- Читаем текущий value (если файл уже содержит тот же AppId — пропускаем запись).
local function currentAppId(path)
    local f = io.open(path, "r")
    if not f then
        return nil
    end
    local s = (f:read("*l") or ""):gsub("%s+$", "")
    f:close()
    return s ~= "" and s or nil
end

if currentAppId(APPID_FILE) == APPID then
    api.log("WorkingServers: AppId уже установлен")
    api.notify("WorkingServers: сервера уже рабочие", 2)
elseif writeAppId(APPID_FILE) then
    api.log("WorkingServers: Photon AppId = " .. APPID)
    api.notify("WorkingServers: сервера установлены", 2)
else
    api.log("WorkingServers: не удалось записать " .. APPID_FILE)
    api.notify("WorkingServers: не удалось записать AppId", 1)
end
