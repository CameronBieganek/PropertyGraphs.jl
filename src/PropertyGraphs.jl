
module PropertyGraphs

using LightGraphs
using Bijections

export
    NoEdgeProperties,
    NoVertexProperties,
    SimplePropertyGraph,
    PropertyGraph,
    vlabels,
    vcode

include("property_graph_v2.jl")
# include("dot.jl")

end
