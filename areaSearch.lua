local geo = peripheral.find("geoScanner")

local blocks = {
    ["allthemodium:allthemodium_ore"] = true,
    ["minecraft:ancient_debris"] = true,
    ["minecraft:emerald_ore"] = true,
    ["minecraft:deepslate_emerald_ore"] = true,
    ["minecraft:diamond_ore"] = true,
    ["minecraft:deepslate_diamond_ore"] = true
}

while true do
    term.clear()
    term.setCursorPos(1, 1)
    local result = geo.scan(16)
    local table = {}
    if result then
        for index, block in pairs(result) do
            if blocks[block.name] then
                local direction = ""
                if block.z > 0 then
                    direction = direction .. "S"
                elseif block.z < 0 then
                    direction = direction .. "N"
                end
                if block.x > 0 then
                    direction = direction .. "E"
                elseif block.x < 0 then
                    direction = direction .. "W"
                end
                table.insert(table, { block.name, block.x + block.y + block.z, direction, block.x, block.y, block.z })
            end
        end
    end
    sleep(geo.getOperationCooldown("scanBlocks") / 1000)
end
