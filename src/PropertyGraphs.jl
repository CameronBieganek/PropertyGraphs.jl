
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

include("property_graph.jl")
include("dot.jl")

end
