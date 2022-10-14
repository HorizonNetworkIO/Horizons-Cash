HZNCash.DB = HZNCash.DB or {} 

HZNCash.DB.MySQL = {
    host = "",
    port = "",
    user = "",
    password = "",
    database = ""
}

// use mysqloo to connect to a mysql database
function HZNCash.DB.Initialize()
    local db = mysqloo.connect(HZNCash.DB.MySQL.host, HZNCash.DB.MySQL.user, HZNCash.DB.MySQL.password, HZNCash.DB.MySQL.database, HZNCash.DB.MySQL.port)
    db:connect()
    
    MsgC(Color(78, 226, 78), "\n[HZNCash]: ", Color(255, 255, 255), "Starting connection with MySQL...\n")
    

    function db:onConnected()
        MsgC(Color(78, 226, 78), "\n[HZNCash]: ", Color(255, 255, 255), "Connected to MySQL!\n")

        // create the table if it doesn't exist
        local q = db:query("CREATE TABLE IF NOT EXISTS hzn_cash (steamid VARCHAR(50) NOT NULL, cash INT NOT NULL, PRIMARY KEY(steamid))")
        q:start()
    end
    
    function db:onConnectionFailed(err)
        print("[HZNCash] Connection to database failed: "..err)
    end

    HZNCash.DB.db = db
end

function HZNCash.DB.AddCash(steamid, cash)
    local db = HZNCash.DB.db
    local q = db:query("INSERT INTO hzn_cash (steamid, cash) VALUES ('"..steamid.."', "..cash..") ON DUPLICATE KEY UPDATE cash = GREATEST(0, cash + "..cash .. ")")

    function q:onError(err)
        print("[HZNCash] Query error: "..err)
    end

    q:start()
end

function HZNCash.DB.GetCash(steamid, callback)
    local db = HZNCash.DB.db
    local q = db:query("SELECT cash FROM hzn_cash WHERE steamid = '"..steamid.."'")

    function q:onSuccess(data)
        if data[1] then
            callback(tonumber(data[1].cash))
        end
    end

    function q:onError(err)
        print("[HZNCash] Query error: "..err)
    end

    q:start()
end