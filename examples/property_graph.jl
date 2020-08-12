

using PropertyGraphs
using LightGraphs

pg = LabeledVertexPropertyGraph(
    SimpleGraph{Int}();
    vertex_label_type = String,
    vertex_properties_type = (color=String, size=Int)
)

add_vertex!(pg, "a")
add_vertex!(pg, "b")
add_vertex!(pg, "c")

pg["a"].color = "blue"
pg["b"].color = "red"
pg["c"].color = "yellow"

pg["a"].size = 10
pg["b"].size = 123
pg["c"].size = 42

add_edge!(pg, 1, 2)
add_edge!(pg, "b", "c")
add_edge!(pg, 1, "c")

add_vertex!(pg, "d")
pg["d"] = (color="pink", size=213)

dijkstra_shortest_paths(pg, pindex(pg, "a"))
enumerate_paths(dijkstra_shortest_paths(pg, pindex(pg, "a")), pindex(pg, "c"))
