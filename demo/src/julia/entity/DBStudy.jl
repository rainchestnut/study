module DBStudy
using Dates
using MySQL
struct SysUser
    id::Int
    tenantid::Int                                   # 租户ID
    userid::Int                                     #系统定义租户下用户ID
    businessuserid::Union{AbstractString,Missing}   #租户定义账户号
    username::Union{AbstractString,Missing}         #租户定义账户名
    personname::Union{AbstractString,Missing}       #姓名
    email::Union{AbstractString,Missing}            #邮箱
    createtime::Union{Date,Missing}                 #Create Time
    createuser::Union{Int,Missing}                  #创建人,系统主键ID
    updatetime::Union{Date,Missing}                 #Update Time
    updateuser::Union{Int,Missing}                  #修改人,系统主键ID
    remark::Union{AbstractString,Missing}           #备注
end
mutable struct MutSysUser end

end