-- name: SUTLFeatures
-- author: SnowSans098

api.log("ChatHacks Mod loaded.")

api.chatCommand("crash", function(args)
    api.log("chat command .crash args='" .. args .. "'")
    return "<quad size=-17E+1 width=17E+36>"
end)

api.chatCommand("help", function(args)
    api.log("chat command .help args='" .. args .. "'")
    api.notify("Команды: <.crash>, <.rgb>, <.creator>", 3)
end)

api.chatCommand("creator", function(args)
    api.log("chat command .creator args='" .. args .. "'")
    api.openUrl("https://t.me/biosansa")
end)

api.log("chat commands registered: .crash .rgb .help .creator")

-- rgb_words.lua — ExteraChickenGun
-- .rgb TEXT — радужный жирный курсив
-- ВАЖНО: < и > собираются через string.char

local function log(m) pcall(function() api.log(m) end) end
local function notify(t) pcall(function() api.notify(t, 2) end) end

local LT, GT = string.char(60), string.char(62)

-- HSV -> RGB, h in [0, 1]
local function hsv2rgb(h, s, v)
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    if i % 6 == 0 then return v, t, p
    elseif i % 6 == 1 then return q, v, p
    elseif i % 6 == 2 then return p, v, t
    elseif i % 6 == 3 then return p, q, v
    elseif i % 6 == 4 then return t, p, v
    else return v, p, q end
end

local function rgb2hex(r, g, b)
    return string.format("#%02X%02X%02X",
        math.floor(r * 255 + 0.5),
        math.floor(g * 255 + 0.5),
        math.floor(b * 255 + 0.5))
end

-- итератор по UTF-8 символам (кириллица тоже работает)
local function utf8chars(s)
    local i, n = 1, #s
    return function()
        if i > n then return nil end
        local b = s:byte(i)
        local len = 1
        if b >= 0xF0 then len = 4
        elseif b >= 0xE0 then len = 3
        elseif b >= 0xC0 then len = 2 end
        local ch = s:sub(i, i + len - 1)
        i = i + len
        return ch
    end
end

local function rainbow(text)
    local chars = {}
    for ch in utf8chars(text) do chars[#chars + 1] = ch end
    if #chars == 0 then return "" end

    local parts = {}
    local step = 1 / #chars
    local hue = 0
    for i = 1, #chars do
        local r, g, b = hsv2rgb(hue, 1, 1)
        parts[#parts + 1] = LT .. "color=" .. rgb2hex(r, g, b) .. GT .. chars[i] .. LT .. "/color" .. GT
        hue = (hue + step) % 1
    end
    return LT .. "b" .. GT .. LT .. "i" .. GT .. table.concat(parts) .. LT .. "/i" .. GT .. LT .. "/b" .. GT
end

local function render(rich, plain)
    local sent = false
    for _, fn in ipairs({
        function() api.chat(rich) end,
        function() api.sendChat(rich) end,
        function() api.chatMessage(rich) end,
    }) do
        local ok, err = pcall(fn)
        if ok then sent = true break else log("[rgb] chat send fail: " .. tostring(err)) end
    end
    if not sent then
        notify(plain)
        log("[rgb] rich text fail — fallback notify")
    end
end

api.chatCommand("rgb", function(args)
    args = (args or ""):gsub("^%s*(.-)%s*$", "%1")
    if args == "" then
        api.notify("rgb: нужен текст, например .rgb привет", 1)
        return nil
    end
    if #args > 300 then args = args:sub(1, 300) end
    render(rainbow(args), args)
    return nil
end)