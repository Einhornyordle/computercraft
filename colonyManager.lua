--Imports

--Peripherals
local col = peripheral.find("colonyIntegrator")

--Configureable Variables

--Utility Functions

--Peripheral Tables

--Data Tables

--Core Functions

--Execute
term.clear()
term.setCursorPos(1, 1)
for i, building in pairs(col.getBuildings()) do
    if building.type == "builder" then
        
    end
end