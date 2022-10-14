HZNCash.Points = {}
HZNCash.Points.AFKPlayers = {}

hook.Add("PlayerInitialSpawn", "HZNCash:InitialSpawn", function(ply)
    timer.Create("hzn_cash_playtime_" .. ply:SteamID64(), HZNCash.Config.Points.PlayTimeInterval, 0, function()
        if (not HZNCash.Config.Points.Enabled) then return end
        if (HZNCash.Points.AFKPlayers[ply:SteamID64()]) then return end

        if (ply:IsValid()) then
            local reward = HZNCash.Config.Points.PlayTimeReward * HZNEvents.Multipliers["Cash"]
            local newReward = hook.Run("HZNCash:OnPlayTimeReward", ply, reward)
            if (newReward) then
                reward = newReward
            end
            ply:AddHZNCash(reward)

            net.Start("hzn_cash_notify")
                net.WriteString("You have received " .. reward .. " credits for playing!")
            net.Send(ply)
        end
    end)

    ply:GetHZNCash()
end)

hook.Add("PlayerDisconnected", "HZNCash:Disconnect", function(ply)
    timer.Remove("hzn_cash_playtime_" .. ply:SteamID64())
end)