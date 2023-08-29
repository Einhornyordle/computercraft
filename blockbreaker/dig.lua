while true do
    for i = 1, 16, 1 do
        turtle.select(i)
        while turtle.getItemSpace() > 0 do
            turtle.dig()
        end
    end
end