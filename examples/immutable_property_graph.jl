

using PropertyGraphs
using LightGraphs



# -------- Property graph. --------

pg = PropertyGraph{
    Int,
    SimpleGraph{Int},
    Symbol,
    NamedTuple{(:color, :size), Tuple{String, Int}},
    NamedTuple{(:capacity, ), Tuple{String}}
}()

add_vertex!(pg)
add_vindex!(pg, 1, :a)

add_vertex!(pg, :b)
add_vertex!(pg, :c)

add_edge!(pg, 1, 2)
add_edge!(pg, :b, :c)
add_edge!(pg, 1, :c)

pg[1] = (color="red", size=7)
pg[2] = (color="blue", size=1)
pg[3] = (color="yellow", size=3)

pg[1, 2] = (capacity="low", )
pg[:b, :c] = (capacity="medium", )
pg[:a, 3] = (capacity="high", )

dijkstra_shortest_paths(pg, pindex(pg, :a))
enumerate_paths(dijkstra_shortest_paths(pg, pindex(pg, :a)), pindex(pg, :c))



# -------- Vertex property graph. --------

vg = VertexPropertyGraph{
    Int,
    SimpleGraph{Int},
    Symbol,
    NamedTuple{(:color, :size), Tuple{String, Int}}
}()

add_vertex!(vg)
add_vindex!(vg, 1, :a)

add_vertex!(vg, :b)
add_vertex!(vg, :c)

add_edge!(vg, 1, 2)
add_edge!(vg, :b, :c)
add_edge!(vg, 1, :c)

vg[1] = (color="red", size=7)
vg[2] = (color="blue", size=1)
vg[3] = (color="yellow", size=3)
