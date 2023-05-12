--Imports
local completion = require "cc.completion"

--Static Peripherals
local modem = peripheral.find("modem")

--Data Tables
local items = {}
local itemCount = {}

--Core Functions
local function handleMsg()
    while true do
        local data = select(5, os.pullEvent("modem_message"))
        items = data.items
        itemCount = data.itemCount
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
        modem.transmit(25890, 25890, {item = inText, amount = amount})
        term.clear()
        term.setCursorPos(1, 1)
    end
end

--Execute
term.clear()
term.setCursorPos(1, 1)
modem.open(25890)
parallel.waitForAll(handleMsg, processUserInput)