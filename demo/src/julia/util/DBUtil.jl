module DBUtil
using JSON
using MySQL
export dbmap,init!
struct DBLink
    host::AbstractString
    port::Int
    username::AbstractString
    password::AbstractString
    schema::AbstractString
end
dbmap = missing
function getconnect(key::AbstractString)
    init!()
    global dbmap
    link = dbmap[key];
    return DBInterface.connect(MySQL.Connection, link.host, link.username, link.password, db=link.schema)
end
DBInterface.connect(key::AbstractString) = getconnect(key::AbstractString)
function init!(;fresh::Bool=false)
    global dbmap
    if dbmap === missing || fresh
        path = normpath(joinpath(@__DIR__, "..","..",".."),"resources","db.json")
        open(path,"r") do io
            dbjsonmap = JSON.parse(io)
            dbmap = Dict(k => DBLink(string(v["host"]),Int(v["port"]),string(v["username"]),string(v["password"]),string(v["schema"])) for (k,v) in dbjsonmap)
        end
        println("数据库配置初始化完成")
    end
end
    
end
