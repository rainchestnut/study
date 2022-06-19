module DBUtil
using JSON
using MySQL
using DataStructures
using Tables

function getconnect end
function init! end
function querylist end

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
    link = dbmap[key]
    return DBInterface.connect(MySQL.Connection, link.host, link.username, link.password, db=link.schema)
end


function querylist(conn::DBInterface.Connection, sql::AbstractString; dt::DataType)
    dbiterator = DBInterface.execute(conn, sql)
    list::Vector{dt} = []
    clmnamemap = missing
    for item in dbiterator
        if clmnamemap === missing
            clmnames = string.(Tables.columnnames(item))
            clmnamemap = Dict(replace(clm ,"_"=>"") => clm for clm in clmnames)
            fieldnames = [keys(clmnamemap)...]
        end
        args = []
        for fldname in string.(Base.fieldnames(dt))
            if fldname in(fieldnames)
                push!(args,Tables.getcolumn(item,Symbol(clmnamemap[fldname])))
            else
                push!(args,nothing)  
            end
        end
        push!(list,dt(args...))
    end
    return list
end
function querylist(connstr::AbstractString, sql::AbstractString; dt::DataType)
    dbconnect = getconnect(connstr)
    try
        return querylist(dbconnect,sql,dt=dt)
    finally
        close!(dbconnect)
    end
end
function init!(; fresh::Bool=false)
    global dbmap
    if dbmap === missing || fresh
        path = normpath(joinpath(@__DIR__, "..", "..", ".."), "resources", "db.json")
        open(path, "r") do io
            dbjsonmap = JSON.parse(io)
            dbmap = SortedDict(k => DBLink(string(v["host"]), Int(v["port"]), string(v["username"]), string(v["password"]), string(v["schema"])) for (k, v) in dbjsonmap)
        end
        println("数据库配置初始化完成")
    end
end
function close!(conn::DBInterface.Connection)
    DBInterface.close!(conn)
end


init!()
end
