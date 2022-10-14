net.Receive("hzn_cash_notify", function()
    local text = net.ReadString()
    chat.AddText("{*HZN} | ", Color(226, 226, 226), text)
end)