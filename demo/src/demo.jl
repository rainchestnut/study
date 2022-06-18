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
    dbconnect = DBUtil.getconnect()
    sql = "select * from t_sys_user limit 10"
    dbiterator = DBInterface.execute(dbconnect,sql)
    for item in dbiterator
        if Base.haskey(item,:id)
            println("id:"* Tables.getcolumn(item,:id)) 
        end
    end
    DBUtil.close!(dbconnect)
end