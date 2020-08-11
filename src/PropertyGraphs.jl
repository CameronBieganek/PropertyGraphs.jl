
module PropertyGraphs

import Base: getindex, getproperty, setproperty!
using LightGraphs
import LightGraphs: add_vertex!, add_edge!, edges, vertices, nv, ne, inneighbors, outneighbors

export AbstractPropertyGraph,
       LabeledVertexPropertyGraph,
       pindex,
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
