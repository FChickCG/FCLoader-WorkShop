-- name: ДохераМонет
-- author: FChick
api.log("coins_test.lua loaded (Extera)")

api.setting("Сумма монет", 1000, 1000000)
api.setting("Максимум", false)

local LocalStore = nil
local getBalance = nil

local function balance()
    if not getBalance then
        LocalStore = api.getClassFull("", "LocalStore")
        getBalance = api.getMethodInfo(LocalStore, "get_currencyBalance")
    end
    return api.call(getBalance, nil, 0)
end

local function giveCoins()
    local amount = math.floor(api.setting("Сумма монет"))
    if api.setting("Максимум") then
        amount = 100000000
    end
    local before = balance()
    local ok = pcall(function()
        api.LocalStore_GiveMoney(nil, amount)
    end)
    local after = balance()
    api.log("before=" .. tostring(before) .. " GiveMoney(" .. amount .. ")=" .. tostring(ok) ..
            " after=" .. tostring(after))
    return amount
end


api.addButton("Выдать монеты", function()
    local amount = giveCoins()
    return "coins +" .. amount
end)


api.chatCommand(".coins", function(args)
    local a = tonumber(args)
    if a and a > 0 then
        api.setting("Сумма монет", a)
    end
    local amount = giveCoins()
    return "coins +" .. amount
end)

api.log("coins_test.lua ready: button + cmd .coins")
