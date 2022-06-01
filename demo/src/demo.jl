"""
# module demo

- Julia version: 1.6.2
- Author: 王冠
- Date: 2022-05-31

# Examples

```jldoctest
julia>
```
"""
module demo
    function pathPush()
        push!(LOAD_PATH,pwd() * "\\src\\julia\\func")
        push!(LOAD_PATH,pwd() * "\\src\\julia\\until")
        push!(LOAD_PATH,pwd() * "\\src\\julia\\main")
    end
    pathPush()
    using DemoTest1;
    println(DemoTest1.getStringCut("受命于天既寿永昌",1,6));
end