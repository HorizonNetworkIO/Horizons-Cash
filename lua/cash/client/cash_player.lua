local PLAYER = FindMetaTable("Player")

function PLAYER:GetHZNCash()
    return self:GetNWInt("hzn_cash", 0)
end