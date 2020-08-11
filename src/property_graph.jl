

abstract type AbstractPropertyGraph{T} <: AbstractGraph{T} end


struct LabeledVertexPropertyGraph{L, P <: NamedTuple, T, G <: AbstractGraph{T}} <: AbstractPropertyGraph{T}
    g       ::  G
    vindex  ::  Dict{L, T}   # map from custom index to primitive index
    vprops  ::  P            # vertex property data
end


# This doesn't seem to work. The input parameters seem to have to be compatible with the struct definition.
# function LabeledVertexPropertyGraph{L, K, V}(g::AbstractGraph{T}) where {L, K, V <: Tuple, T <: Integer}
#     println("hello world!")

#     # vindex = Dict{L, T}()
#     # @show vindex

#     # d = [Dict{T, v}() for v in fieldtypes(V)]
#     # @show d

#     # vprops = (; Pair.(K, d)...)
#     # @show vprops

#     # LabeledVertexPropertyGraph(g, vindex, vprops)
# end


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
pindex(pg::AbstractPropertyGraph, u, v) = Edge(pindex(pg, u), pindex(pg, v))


struct VertexProperties{G <: AbstractPropertyGraph, L}
    g::G
    label::L
end


get_graph(vp::VertexProperties) = getfield(vp, :g)
get_label(vp::VertexProperties) = getfield(vp, :label)


getindex(pg::AbstractPropertyGraph, v) = VertexProperties(pg, v)



function getproperty(vp::VertexProperties, sym::Symbol)
    g = get_graph(vp)
    label = get_label(vp)
    g.vprops[sym][pindex(g, label)]
end


function setproperty!(vp::VertexProperties, sym::Symbol, val)
    g = get_graph(vp)
    label = get_label(vp)
    g.vprops[sym][pindex(g, label)] = val
end


# TODO: Add setindex! to allow setting all vertex properties at once.


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


# TODO: Figure out if this should be included:
# add_vindex!(pg::AbstractPropertyGraph, i::Integer, label) = ( pg.vindex[label] = i )


add_edge!(pg::AbstractPropertyGraph, e::Edge) = add_edge!(pg.g, e)
add_edge!(pg::AbstractPropertyGraph, u, v) = add_edge!(pg, pindex(pg, u, v))
