concommand.Add("hzncash_add", function(ply, command, args) 
    local steamID64 = tostring(args[1])
    local amount = tonumber(args[2])

    if not steamID64 or not amount then
        print("Invalid arguments")
        return
    end

    HZNCash.DB.AddCash(steamID64, amount)

    local target = player.GetBySteamID64(steamID64)
    if IsValid(target) then
        net.Start("hzn_cash_notify")
            net.WriteString("You have received " .. amount .. " Cash!")
        net.Send(target)
        target:GetHZNCash()
    end
end)