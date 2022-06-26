module DBUtil
using Pkg
using TOML
using DBInterface
using DataStructures
using Tables

global dbmap = missing

function getconnect end
function init! end
function querylist end
function queryone end
struct DBLink
    modu::AbstractString
    conn::AbstractString
end
function update(sql::AbstractString, param::Dict{}, conn::DBInterface.Connection)
    stmt = buildstmt(sql, param, conn)
    res = DBInterface.execute(stmt...)
    effect = res.rows_affected
    DBInterface.close!(stmt[1])
    return effect
end
function update(sql::AbstractString, param::Dict{}, connstr::AbstractString=[keys(dbmap)...][1])
    dbconnect = getconnect(connstr)
    try
        return update(sql, param, dbconnect)
    finally
        close!(dbconnect)
    end
end
function querylist(sql::AbstractString, param::Dict{}, conn::DBInterface.Connection; dt::DataType=Dict{AbstractString,Any})
    stmt = buildstmt(sql, param, conn)
    list::Vector{dt} = []
    DBInterface.execute(stmt...) do dbiterator
        clmnamemap = missing
        for item in dbiterator
            if clmnamemap === missing
                clmnames = string.(Tables.columnnames(item))
                clmnamemap = Dict(replace(clm, "_" => "") => clm for clm in clmnames)
            end
            push!(list, convertobject(item, clmnamemap; dt=dt))
        end
    end
    DBInterface.close!(stmt[1])
    return list
end
function querylist(sql::AbstractString, param::Dict{}, connstr::AbstractString=[keys(dbmap)...][1]; dt::DataType=Dict{AbstractString,Any})
    dbconnect = getconnect(connstr)
    try
        return querylist(sql, param, dbconnect; dt=dt)
    finally
        close!(dbconnect)
    end
end
function queryone(sql::AbstractString, param::Dict{}, conn::DBInterface.Connection; dt::DataType=Dict{AbstractString,Any})
    stmt = buildstmt(sql, param, conn)
    dbiterator = DBInterface.execute(stmt...)
    clmnamemap = missing
    for item in dbiterator
        if clmnamemap === missing
            clmnames = string.(Tables.columnnames(item))
            clmnamemap = Dict(replace(clm, "_" => "") => clm for clm in clmnames)
        end
        return convertobject(item, clmnamemap; dt=dt)
    end
    DBInterface.close!(stmt[1])
    return list
end
function queryone(sql::AbstractString, param::Dict{}, connstr::AbstractString=[keys(dbmap)...][1]; dt::DataType=Dict{AbstractString,Any})
    dbconnect = getconnect(connstr)
    try
        return queryone(sql, param, dbconnect; dt=dt)
    finally
        close!(dbconnect)
    end
end
function getconnect(key::AbstractString=[keys(dbmap)...][1])::DBInterface.Connection
    conn = dbmap[key].conn
    eva = Meta.parse(conn)
    @time eval(eva)
end
function buildstmt(sql::AbstractString, param::Dict{AbstractString,Any}, conn::DBInterface.Connection)
    matcher = eachmatch(r"#{(.*?)}", sql)
    if matcher === nothing
        params = []
    else
        params = [param[tag.captures...] for tag in matcher]
        sql = replace(sql, r"#{(.*?)}" => "?")

    end
    println(sql, params)
    stmt = DBInterface.prepare(conn, sql)
    return stmt, params
end
function convertobject(item::Tables.AbstractRow, clmnamemap::Dict; dt::DataType=Dict{AbstractString,Any})
    fieldnames = [keys(clmnamemap)...]
    if dt <: Dict
        return Dict(k => Tables.getcolumn(item, Symbol(v)) for (k, v) in clmnamemap)
    else
        args = []
        for fldname in string.(Base.fieldnames(dt))
            if fldname in (fieldnames)
                push!(args, Tables.getcolumn(item, Symbol(clmnamemap[fldname])))
            else
                push!(args, nothing)
            end
        end
        return dt(args...)
    end
end
function close!(conn::DBInterface.Connection)
    DBInterface.close!(conn)
end
if dbmap === missing
    path = normpath(joinpath(@__DIR__, "..", "..", ".."), "resources", "db.toml")
    dbjsonmap = TOML.parsefile(path)
    global dbmap = SortedDict(k => DBLink(string(v["modu"]), string(v["conn"])) for (k, v) in dbjsonmap)
    for item in values(dbmap)
        db = Symbol(item.modu)
        eval(:(using $db))
    end
    println("数据库配置初始化完成了")
end
end
