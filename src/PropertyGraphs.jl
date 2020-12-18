
module PropertyGraphs

using LightGraphs
using Bijections

export
    NoEdgeProperties,
    NoVertexProperties,
    SimplePropertyGraph,
    PropertyGraph,
    label,
    labels

include("property_graph_v2.jl")
# include("dot.jl")

end
