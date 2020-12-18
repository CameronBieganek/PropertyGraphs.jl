

using PropertyGraphs
using LightGraphs



mutable struct VertexProperties
    color::String
    size::Float64
end



# -------- String vertex labels. --------

pg = SimplePropertyGraph{Int, String, VertexProperties}()

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



# -------- Integer vertex labels. --------

pg2 = SimplePropertyGraph{Int, Int, VertexProperties}()

add_vertex!(pg2, 101)
add_vertex!(pg2, 102)
add_vertex!(pg2, 103)

add_edge!(pg2, 101, 102)
add_edge!(pg2, 102, 103)
add_edge!(pg2, 101, 103)

pg2[101] = VertexProperties("red", 3.4)
pg2[102] = VertexProperties("blue", 1.9)
pg2[103] = VertexProperties("yellow", 7.0)

pg2[101]
pg2[102]
pg2[103]
