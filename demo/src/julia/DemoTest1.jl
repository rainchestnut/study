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
    export getStringCut
    function getStringCut(s::String ,st::Int,ed::Int)
        index = nextIndex = stIndex = edIndex =  1
        lastIndex::Int = lastindex(s);
        while index <= ed + 1
            if st == index
                stIndex = nextIndex
            end
            if ed == index
                edIndex = nextIndex
            end
            nextIndex = nextind(s,nextIndex)
            if nextIndex == lastIndex
                edIndex = nextIndex
                break
            end
            index = index + 1
        end
        s[stIndex:edIndex]
    end
end
