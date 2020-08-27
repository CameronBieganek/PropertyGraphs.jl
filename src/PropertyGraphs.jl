
module PropertyGraphs

using LightGraphs

export AbstractPropertyGraph,
       LabeledVertexPropertyGraph,
       pindex,
       vlabel,
       vlabels

# LightGraphs re-exports
export add_vertex!,
       add_edge!,
       edges,
       vertices,
       nv,
       ne,
       inneighbors,
       outneighbors,
       is_directed

include("property_graph.jl")

end
