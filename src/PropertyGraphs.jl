
module PropertyGraphs

import Base: getindex, setindex!
using LightGraphs
import LightGraphs: add_vertex!, add_edge!, edges, vertices, nv, ne, inneighbors, outneighbors

export AbstractPropertyGraph,
       PropertyGraph,
       VertexPropertyGraph,
       EdgePropertyGraph,
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
