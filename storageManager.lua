--Imports
local completion = require "cc.completion"

--Peripherals
local modem = -1

--Configureable Variables
local inputIds = {
    
}
local outputIds = {
    
}
local storageIds = {
    
}
local importIds = {
    ""
}
local exportIds = {
    ""
}

--Utility Functions
local function wrapPeripherals(ids)
    local peripherals = {}
    for index, id in pairs(ids) do
        table.insert(peripherals, peripheral.wrap(id));
    end
    return peripherals;
end

--Peripheral Tables
local storages = wrapPeripherals(storageIds)
local inputs = wrapPeripherals(inputIds)
local outputs = wrapPeripherals(outputIds)

--Data Tables
local items = {}
local itemCount = {}
local exports = {}

--Core Functions
local function refreshItemLists()
    while true do
        local tmpItems = {}
        local tmpItemCount = {}
        for i, storage in pairs(storages) do
            for slot, item in pairs(storage.list()) do
                table.insert(tmpItems, item.name)
                if tmpItemCount[item.name] then
                    tmpItemCount[item.name] = tmpItemCount[item.name] + item.count
                else
                    tmpItemCount[item.name] = item.count
                end
                sleep(0.0001)
            end
        end
        table.sort(tmpItems)
        items = tmpItems
        itemCount = tmpItemCount
        modem.transmit(25890, 25890, {items = items, itemCount = itemCount})
    end
end

local function importItems()
    while true do
        for i, storage in pairs(storages) do
            for j, input in pairs(inputs) do
                for slot in pairs(input.list()) do
                    storage.pullItems(peripheral.getName(input), slot)
                end
            end
        end
    end
end

local function exportItems()
    while true do
        for i, output in pairs(outputs) do
            for j, storage in pairs(storages) do
                for slot, item in pairs(storage.list()) do
                    if exports[item.name] then
                        exports[item.name] = exports[item.name] -
                            storage.pushItems(peripheral.getName(output), slot, tonumber(exports[item.name]))
                        if exports[item.name] <= 0 then
                            exports[item.name] = nil
                        end
                    end
                end
            end
        end
    end
end

local function handleMsg()
    while true do
        local data = select(5, os.pullEvent("modem_message"))
        if exports[data.item] then
            exports[data.item] = exports[data.item] + data.amount
        else
            exports[data.item] = data.amount
        end
    end
end

local function processUserInput()
    local inText = ""
    local amount = -1
    local history = {}

    while true do
        write("Item: ")
        inText = read(nil, history, function(txt) return completion.choice(txt, items) end, "minecraft:")
        table.insert(history, inText)
        if itemCount[inText] then
            print("Stored amount: " .. itemCount[inText])
        end
        write("Export amount: ")
        if itemCount[inText] then
            amount = read(nil, { tostring(itemCount[inText]) })
        else
            amount = read()
        end
        if exports[inText] then
            exports[inText] = exports[inText] + amount
        else
            exports[inText] = amount
        end
        term.clear()
        term.setCursorPos(1, 1)
    end
end

--Execute
term.clear()
term.setCursorPos(1, 1)
for i, tmpModem in pairs(table.pack(peripheral.find("modem"))) do
    if tmpModem.isWireless() then
        modem = tmpModem
        break
    end
end
modem.open(25890)
parallel.waitForAll(refreshItemLists, importItems, exportItems, handleMsg, processUserInput)
