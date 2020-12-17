

using PropertyGraphs
using LightGraphs


mutable struct VertexProperties
    color::String
    size::Float64
end

pg = PropertyGraph{String, VertexProperties}()

add_vertex!(pg, "a")
add_vertex!(pg, "b")
add_vertex!(pg, "c")

add_edge!(pg, "a", "b")
add_edge!(pg, "b", "c")
add_edge!(pg, "a", "c")

pg["a"] = VertexProperties("red", 3.4)
pg["b"] = VertexProperties("blue", 1.9)
pg["c"] = VertexProperties("yellow", 7.0)

pg["a"]
pg["b"]
pg["c"]

pg["a"].color
pg["a"].color = "pink"
pg["a"].color

pg["b"].size
pg["b"].size = 100.2
pg["b"].size
