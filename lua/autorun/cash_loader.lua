local function init()
    if SERVER then
        AddCSLuaFile("cash/cash_config.lua")
        AddCSLuaFile("cash/client/cash_player.lua")
        AddCSLuaFile("cash/client/cash_commands.lua")

        include("cash/cash_config.lua")
        include("cash/server/cash_mysql.lua")
        include("cash/server/cash_points.lua")
        include("cash/server/cash_player.lua")
        include("cash/server/cash_commands.lua")
        
        util.AddNetworkString("hzn_cash_notify")

        -- init db
        timer.Simple(1, HZNCash.DB.Initialize)

        MsgC(Color(78, 226, 78), "\n[HZNCash]: ", Color(255, 255, 255), "Loaded!\n")

        timer.Simple(1, function()
            for k,v in ipairs(player.GetAll()) do
                local ply = v
                if (timer.Exists("hzn_cash_playtime_" .. ply:SteamID64())) then
                    timer.Remove("hzn_cash_playtime_" .. ply:SteamID64())
                end
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
            end
        end)
    end

    if CLIENT then
        include("cash/cash_config.lua")
        include("cash/client/cash_player.lua")
        include("cash/client/cash_commands.lua")
    end
end

init()