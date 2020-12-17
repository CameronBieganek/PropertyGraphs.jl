

struct NoVertexProperties end
struct NoEdgeProperties end


# TODO: Properly handle the case where there are no custom vertex labels.


# VP, EP, GP are any types with getproperty() defined.
struct PropertyGraph{VL, VP, EP, G, T <: Integer} <: AbstractGraph{T}
    g::G
    vmap::Bijection{VL, T}
    vprops::Dict{VL, VP}     # Make these Union{No*, Dict{T, R}} etc?
    eprops::Dict{VL, EP}     # This should actually be something like Dict{Edge, EP}
                             # or Dict{Tuple{VL,VL}, EP}
end


function PropertyGraph{VL, VP, EP, G, T}() where {VL, VP, EP, G, T}
    if VL <: Integer
        throw(ArgumentError("Vertex labels cannot be integers"))
    end

    PropertyGraph(
        G(),
        Bijection{VL, T}(),
        Dict{VL, VP}(),
        Dict{VL, EP}()
    )
end


function PropertyGraph{VL, VP, EP}() where {VL, VP, EP}
    PropertyGraph{VL, VP, EP, SimpleGraph, Int64}()
end


function PropertyGraph{VL, VP}() where {VL, VP}
    PropertyGraph{VL, VP, NoEdgeProperties}()
end


vlabels(pg::PropertyGraph) = domain(pg.vmap)

vcode(pg::PropertyGraph, vlabel) = pg.vmap[vlabel]
LightGraphs.Edge(pg::PropertyGraph, u, v) = Edge(vcode(pg, u), vcode(pg, v))


Base.in(vlabel, pg::PropertyGraph) = (vlabel in vlabels(pg))


LightGraphs.edges(pg::PropertyGraph) = edges(pg.g)
LightGraphs.vertices(pg::PropertyGraph) = vertices(pg.g)
LightGraphs.nv(pg::PropertyGraph) = nv(pg.g)
LightGraphs.ne(pg::PropertyGraph) = ne(pg.g)
LightGraphs.inneighbors(pg::PropertyGraph, vcode) = inneighbors(pg.g, vcode)
LightGraphs.outneighbors(pg::PropertyGraph, vcode) = outneighbors(pg.g, vcode)


function LightGraphs.is_directed(::Type{PropertyGraph{VL,VP,EP,G,T}}) where {VL,VP,EP,G,T}
    is_directed(G)
end


function LightGraphs.add_vertex!(pg::PropertyGraph{VL,VP,EP,G,T}, vlabel) where {VL,VP,EP,G<:SimpleGraph,T}
    if vlabel in pg
        return false
    end

    added = add_vertex!(pg.g)
    if added
        pg.vmap[vlabel] = nv(pg)
    end

    added
end


# TODO: Make this error occur when there is a vertex label, but not occur when vertex labels
# are not being used.
function LightGraphs.add_vertex!(::PropertyGraph, ::Integer)
    msg = "The syntax `add_vertex!(pg, vlabel)` is reserved for adding a vertex with a non-integer label"
    throw(ArgumentError(msg))
end


function LightGraphs.add_edge!(pg::PropertyGraph{VL,VP,EP,G,T}, u, v) where {VL,VP,EP,G<:SimpleGraph,T}
    add_edge!(pg.g, Edge(pg, u, v))
end


Base.setindex!(pg::PropertyGraph, val, vlabel) = ( pg.vprops[vlabel] = val )
Base.getindex(pg::PropertyGraph, vlabel) = pg.vprops[vlabel]
