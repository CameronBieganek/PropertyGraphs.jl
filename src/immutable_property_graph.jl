

abstract type AbstractPropertyGraph{T} <: AbstractGraph{T} end


struct PropertyGraph{T, G <: AbstractGraph{T}, L, V <: NamedTuple, E <: NamedTuple} <: AbstractPropertyGraph{T}
    g       ::  G
    vindex  ::  Dict{L, T}     # map from custom index to primitive index
    vmeta   ::  Dict{T, V}     # map from primitive index to vertex meta data
    emeta   ::  Dict{Edge, E}  # map from LightGraphs.Edge to edge meta data
end


function PropertyGraph{T, G, L, V, E}() where {T, G <: AbstractGraph{T}, L, V <: NamedTuple, E <: NamedTuple}
    PropertyGraph(G(), Dict{L, T}(), Dict{T, V}(), Dict{Edge, E}())
end


struct VertexPropertyGraph{T, G <: AbstractGraph{T}, L, V <: NamedTuple} <: AbstractPropertyGraph{T}
    g       ::  G
    vindex  ::  Dict{L, T}     # map from custom index to primitive index
    vmeta   ::  Dict{T, V}     # map from primitive index to vertex meta data
end


function VertexPropertyGraph{T, G, L, V}() where {T, G <: AbstractGraph{T}, L, V <: NamedTuple}
    VertexPropertyGraph(G(), Dict{L, T}(), Dict{T, V}())
end


struct EdgePropertyGraph{T, G <: AbstractGraph{T}, L, E <: NamedTuple} <: AbstractPropertyGraph{T}
    g       ::  G
    vindex  ::  Dict{L, T}     # map from custom index to primitive index
    emeta   ::  Dict{Edge, E}  # map from LightGraphs.Edge to edge meta data
end


function EdgePropertyGraph{T, G, L, E}() where {T, G <: AbstractGraph{T}, L, E <: NamedTuple}
    PropertyGraph(G(), Dict{L, T}(), Dict{Edge, E}())
end


# TODO: Add LabeledPropertyGraph, LabeledVertexPropertyGraph, LabeledEdgePropertyGraph ???
# If there are going to be that many types, it's probably better if they're not directly
# exposed to the user. Use helper constructors like property_grap() or
# immutable_property_graph() instead... ?


# TODO: Ensure methods are properly specialized for different property graph subtypes.


edges(pg::AbstractPropertyGraph) = edges(pg.g)
vertices(pg::AbstractPropertyGraph) = vertices(pg.g)
nv(pg::AbstractPropertyGraph) = nv(pg.g)
ne(pg::AbstractPropertyGraph) = ne(pg.g)
inneighbors(pg::AbstractPropertyGraph, v::Integer) = inneighbors(pg.g, pindex(pg, v))
outneighbors(pg::AbstractPropertyGraph, v::Integer) = outneighbors(pg.g, pindex(pg, v))


# Get the primitive index.
pindex(pg::AbstractPropertyGraph, i::Integer) = i
pindex(pg::AbstractPropertyGraph, label) = pg.vindex[label]

pindex(pg::AbstractPropertyGraph, e::Edge) = e
# pindex(mg::MetaGraph, e::EdgeIndex) = Edge(mg.vindex[e.src], mg.vindex[e.dst])
pindex(pg::AbstractPropertyGraph, u, v) = Edge(pindex(pg, u), pindex(pg, v))


getindex(pg::AbstractPropertyGraph, v) = pg.vmeta[pindex(pg, v)]
getindex(pg::AbstractPropertyGraph, e::Edge) = pg.emeta[pindex(pg, e)]
getindex(pg::AbstractPropertyGraph, u, v) = pg[pindex(pg, u, v)]


# These methods allow setting the meta-data for a vertex or edge in bulk.
setindex!(pg::AbstractPropertyGraph, val, v) = ( pg.vmeta[pindex(pg, v)] = val )
setindex!(pg::AbstractPropertyGraph, val, e::Edge) = ( pg.emeta[pindex(pg, e)] = val )
setindex!(pg::AbstractPropertyGraph, val, u, v) = ( pg[pindex(pg, u, v)] = val )


add_vertex!(pg::AbstractPropertyGraph) = add_vertex!(pg.g)

function add_vertex!(pg::AbstractPropertyGraph, label)
    added = add_vertex!(pg.g)
    if added
        i = nv(pg)
        pg.vindex[label] = i
    end
    added
end

function add_vertex!(pg::AbstractPropertyGraph, i::Integer)
    msg = "The syntax `add_vertex!(pg, label)` is reserved for adding a vertex with a custom index"
    throw(ArgumentError(msg))
end


add_vindex!(pg::AbstractPropertyGraph, i::Integer, label) = ( pg.vindex[label] = i )


add_edge!(pg::AbstractPropertyGraph, e::Edge) = added = add_edge!(pg.g, e)
add_edge!(pg::AbstractPropertyGraph, u, v) = add_edge!(pg, pindex(pg, u, v))
