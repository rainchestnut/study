module DBUtil
using JSON
using MySQL
using DataStructures

function getconnect end
function init! end


dbmap = missing
struct DBLink
    host::AbstractString
    port::Int
    username::AbstractString
    password::AbstractString
    schema::AbstractString
end
function getconnect(key::AbstractString=[keys(dbmap)...][1])
    global dbmap
    link = dbmap[key];
    return DBInterface.connect(MySQL.Connection, link.host, link.username, link.password, db=link.schema)
end
function init!(;fresh::Bool=false)
    global dbmap
    if dbmap === missing || fresh
        path = normpath(joinpath(@__DIR__, "..","..",".."),"resources","db.json")
        open(path,"r") do io
            dbjsonmap = JSON.parse(io)
            dbmap = SortedDict(k => DBLink(string(v["host"]),Int(v["port"]),string(v["username"]),string(v["password"]),string(v["schema"])) for (k,v) in dbjsonmap)
        end
        println("数据库配置初始化完成")
    end
end
function close!(conn::DBInterface.Connection)
    DBInterface.close!(conn)
end


init!()    
end
