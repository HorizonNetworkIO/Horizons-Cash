local PLAYER = FindMetaTable("Player")

function PLAYER:AddHZNCash(amount)
    -- add cash
    HZNCash.DB.AddCash(self:SteamID64(), amount)
    -- update net variable
    self:SetNWInt("hzn_cash", self:GetNWInt("hzn_cash", 0) + amount)
    self:GetHZNCash()
end

function PLAYER:GetHZNCash()
    HZNCash.DB.GetCash(self:SteamID64(), function(cash)
        self:SetNWInt("hzn_cash", cash)
    end)
    return self:GetNWInt("hzn_cash", 0)
end