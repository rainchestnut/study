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
const ROOT_DIR = normpath(joinpath(@__DIR__, ".."))
    function pathPush()
        push!(LOAD_PATH,joinpath(ROOT_DIR,"src","julia","func"))
        push!(LOAD_PATH,joinpath(ROOT_DIR,"src","julia","entity"))
        push!(LOAD_PATH,joinpath(ROOT_DIR,"src","julia","util"))
        push!(LOAD_PATH,joinpath(ROOT_DIR,"src","julia","main"))
        push!(LOAD_PATH,joinpath(ROOT_DIR,"resources"))
    end
    pathPush()
    using DemoTest1;
    using MySQL
    using Tables
    using DBUtil
    using DBStudy
    # println(DemoTest1.getStringCut("受命于天既寿永昌",1,6));
    # DemoTest1.readfileline(pwd() * "\\demo\\resources\\" * "Pride and Prejudice.txt");
    # DemoTest1.readfileline("demo\\resources\\" * "Pride and Prejudice.txt");
    # DemoTest1.getWordFrequency("demo\\resources\\" * "Pride and Prejudice.txt");
    # @time println(DemoTest1.getCommonWord("demo\\resources\\" * "Pride and Prejudice.txt",10))
    # @time println(DemoTest1.getCommonWord("demo\\resources\\" * "Pride and Prejudice.txt"))
    # wordCount = DemoTest1.getWordFrequency(joinpath(ROOT_DIR,"resources","Pride and Prejudice.txt"))
    # wordSta = DemoTest1.sumarrayofstatistics(wordCount)
    # wordKeys = [keys(wordCount)...]
    # randomWord = DemoTest1.getRandomWord(wordKeys , wordSta)
    # println(randomWord)
    sql = "select * from t_sys_user limit 10"
    result = DBUtil.querylist("julia_study",sql;dt=DBStudy.SysUser)
    println(result)
end