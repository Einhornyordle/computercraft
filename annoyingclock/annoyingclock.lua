local ed = peripheral.find("environmentDetector")
local cb = peripheral.find("chatBox")

if not (ed and cb) then
  print("This program needs a chatbox and a environment detector peripheral, both from the Advanced Peripherals mod, connected to this pc to work!")
  return
end

local state = -1;

while true do
  local time = ed.getTime()%24000
  if (state == -1 or state == 0) and time > 0 and time < 1000 then
    state = 1
    cb.sendMessage("Rise and shine! A new day has arrived!")
  elseif (state == -1 or state == 1) and time > 5500 and time < 6500 then
    state = 2
    cb.sendMessage("It's high noon!")
  elseif (state == -1 or state == 2) and time > 12541 and time < 13000 then
    state = 3
    cb.sendMessage("The night is approaching, you might want to get some rest...")
  elseif (state == -1 or state == 3) and time > 17500 and  time < 18500 then
    state = 0
    cb.sendMessage("The bloodmoon is rising... just kidding, it's midnight tho.")
  end
end
