

function write_dot(path::AbstractString, pg::PropertyGraph)
    open(path, "w") do io
        println(io, "digraph G {")
        println(io, "rankdir=LR;")

        foreach(sort(collect(pg.vmap))) do (label, code)
            println(io, "$code [label=$label];")
        end

        for e in edges(pg)
            u, v = src(e), dst(e)
            println(io, "$u -> $v;")
        end

        println(io, "}")
    end
end
