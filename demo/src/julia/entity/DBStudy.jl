module DBStudy
using Dates
using MySQL
struct SysUser
    id::Int
    tenantid::Int                      # 租户ID
    userid::Int                        #系统定义租户下用户ID
    businessuserid::AbstractString     #租户定义账户号
    username::AbstractString           #租户定义账户名
    email::AbstractString              #邮箱
    createtime::Date                   #Create Time
    createuser::Int                    #创建人,系统主键ID
    updatetime::Date                   #Update Time
    updateuser::Int                    #修改人,系统主键ID
    remark::AbstractString             #备注
end
mutable struct MutSysUser end

end