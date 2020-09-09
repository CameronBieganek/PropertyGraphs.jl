

include("/Users/bieganek/projects/PropertyGraphs.jl/src/PropertyGraphs.jl")
using .PropertyGraphs
using LightGraphs

pg = LabeledVertexPropertyGraph(
    SimpleGraph{Int}();
    vertex_label_type = String,
    vertex_properties_type = (color=String, size=Int)
)

pg.name = "this is a property graph"
pg.weight = 123.456

add_vertex!(pg, "a")
add_vertex!(pg, "b")
add_vertex!(pg, "c")

pg["a"].color = "blue"
pg["b"].color = "red"
pg["c"].color = "yellow"

pg["a"].size = 10
pg["b"].size = 123
pg["c"].size = 42

propertynames(pg["a"])

add_edge!(pg, 1, 2)
add_edge!(pg, "b", "c")
add_edge!(pg, 1, "c")

add_vertex!(pg, "d")
pg["d"] = (color="pink", size=213)
add_edge!(pg, "c", "d")

dijkstra_shortest_paths(pg, pindex(pg, "a"))
enumerate_paths(dijkstra_shortest_paths(pg, pindex(pg, "a")), pindex(pg, "c"))

vlabel(pg, 1)
vlabel(pg, 2)

is_directed(pg)

"b" in pg
"asdf" in pg
"b" ∉ pg
"asdf" ∉ pg

write_dot("/Users/bieganek/test.dot", pg)

rem_vertex!(pg, "a")

add_vertex!(pg, "e")
pg["e"].color = "black"
get(pg["e"], :size, -1)
