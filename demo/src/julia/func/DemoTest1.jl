"""
# module demo_test1

- Julia version: 1.6.2
- Author: 王冠
- Date: 2021-10-30

# Examples

```jldoctest
julia>
```
"""
module DemoTest1
export getStringCut, readfileline, getWordFrequency, sumarrayofstatistics, getRandomWord
function getStringCut end
function readfileline end
function getWordFrequency end
function getCommonWord end
function sumarrayofstatistics end
function getRandomWord end
function getArrayIndex end
function getStringCut(s::String, st::Int, ed::Int)
    index = nextIndex = stIndex = edIndex = 1
    lastIndex::Int = lastindex(s)
    while index <= ed + 1
        if st == index
            stIndex = nextIndex
        end
        if ed == index
            edIndex = nextIndex
            break
        end
        nextIndex = nextind(s, nextIndex)
        if nextIndex == lastIndex
            edIndex = nextIndex
            break
        end
        index = index + 1
    end
    return s[stIndex:edIndex]
end

function readfileline(path::String)
    io = open(path, "r")
    worldCount = Dict{String,Int}()
    for lineStr in eachline(io)
        println(lineStr)
        str = ""
        for ch in lineStr
            if isletter(ch)
                str *= lowercase(ch)
            else
                if str != ""
                    worldCount[str] = get(worldCount, str, 0) + 1
                    str = ""
                end
            end
        end
    end
    println(worldCount)
    close(io)
    return worldCount
end

function getWordFrequency(path::String)
    io = open(path, "r")
    wordCount = Dict{String,Int}()
    for lineStr in eachline(io)
        lineStr = lowercase(replace(lineStr, r"[^a-zA-Z]" => " "))
        for word in split(lineStr)
            wordCount[word] = get(wordCount, word, 0) + 1
        end
    end
    close(io)
    return wordCount
end

function getCommonWord(path::String, rank::Int=10)
    wordCount = getWordFrequency(path)
    frequencyWords = Array{Tuple{Int,String},1}()
    for (k, v) in wordCount
        push!(frequencyWords, (v, k))
    end
    return sort(frequencyWords; rev=true)[1:rank]
end

function sumarrayofstatistics(wordCount::Dict{String,Int})
    wordSta = Array{Int,1}()
    for v in values(wordCount)
        push!(wordSta, get(wordSta, lastindex(wordSta), 0) + v)
    end
    return wordSta
end

function getRandomWord(wordKeys::Array{String,1}, wordSta::Array{Int,1}, count::Int=last(wordSta))
    index = getArrayIndex(wordSta, rand(1:count))
    return wordKeys[index]
end

function getArrayIndex(arr::Array{Int,1}, rand::Int)
    index = (1, length(arr))
    while index[2] - index[1] > 1
        idx = (index[1] + index[2]) ÷ 2
        if arr[idx] > rand
            index = (index[1], idx)
        else
            index = (idx, index[2])
        end
    end
    return index[2]
end
# readfileline(pwd() * "\\resources\\" * "Pride and Prejudice.txt")
end
