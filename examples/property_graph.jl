

using PropertyGraphs
using LightGraphs

pg = LabeledVertexPropertyGraph(
    SimpleGraph{Int}(),
    Dict{String, Int}(),
    (color=Dict{Int, String}(), size=Dict{Int, Int}())
)

# Alternative constructor: (Doesn't work.)
# pg = LabeledVertexPropertyGraph{String, (:color, :size), Tuple{String, Int}}(SimpleGraph{Int}())

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
