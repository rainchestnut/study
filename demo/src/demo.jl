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
    modulePath = pwd() * "\\src\\julia"
    push!(LOAD_PATH,modulePath)
    println(modulePath)
    using DemoTest1;
    println(DemoTest1.getStringCut("受命于天既寿永昌",1,10));
end