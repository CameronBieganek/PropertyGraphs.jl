
module PropertyGraphs

using LightGraphs

export AbstractPropertyGraph,
       LabeledVertexPropertyGraph,
       pindex,
       vlabel,
       vlabels,
       write_dot

include("property_graph.jl")
include("dot.jl")

end
