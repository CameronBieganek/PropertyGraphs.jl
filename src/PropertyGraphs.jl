
module PropertyGraphs

using LightGraphs
using Bijections

export
    NoEdgeProperties,
    NoVertexProperties,
    SimplePropertyGraph,
    SimplePropertyDiGraph,
    PropertyGraph,
    label,
    labels,
    write_dot

include("property_graph_v2.jl")
include("dot.jl")

end
