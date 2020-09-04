

function write_dot(path::AbstractString, pg::AbstractPropertyGraph)
    labels = vlabels(pg)
    pinds = [pindex(pg, v) for v in labels]

    open(path, "w") do io
        println(io, "digraph G {")
        println(io, "rankdir=LR;")

        foreach(pinds, labels) do i, l
            println(io, "$i [label=$l];")
        end

        for e in edges(pg)
            u, v = src(e), dst(e)
            println(io, "$u -> $v;")
        end

        println(io, "}")
    end
end
