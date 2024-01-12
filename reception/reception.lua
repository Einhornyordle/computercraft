local pd = peripheral.find("playerDetector")
local cb = peripheral.find("chatBox")

local radius = 50
local greeting = "Welcome to the Crystal Space Station, please enjoy your stay."
local farewell = "Thank you for visiting the Crystal Space Station, we hope to welcome you back again soon."

local visitors = {}

while true do
  for _, name in pairs(pd.getPlayersInRange(radius)) do
    if not visitors[name] then
      if visitors[name] == nil then
        if cb.sendMessageToPlayer(greeting, name) then
          visitors[name] = true;
        end
      else
        visitors[name] = true;
      end
    end
  end
  for name in pairs(visitors) do
    if visitors[name] then
      visitors[name] = false
    else
      local res, reason = cb.sendMessageToPlayer(farewell, name)
      if res or reason == "incorrect player name/uuid" then
        visitors[name] = nil
      end
    end
  end
end
