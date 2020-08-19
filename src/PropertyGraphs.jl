
module PropertyGraphs

import Base: getindex, setindex!, getproperty, setproperty!, propertynames
using LightGraphs
import LightGraphs: add_vertex!, add_edge!, edges, vertices, nv, ne, inneighbors, outneighbors

export AbstractPropertyGraph,
       LabeledVertexPropertyGraph,
       pindex,
       vlabel,
       add_vindex!

# LightGraphs re-exports
export add_vertex!,
       add_edge!,
       edges,
       vertices,
       nv,
       ne,
       inneighbors,
       outneighbors

include("property_graph.jl")

end
