

struct NoVertexProperties end
struct NoEdgeProperties end


# TODO: Add rem_vertex!.


# V and E are any types with getproperty() defined.
struct PropertyGraph{T, G <: AbstractGraph{T}, L, V, E} <: AbstractGraph{T}
    g::G
    vmap::Bijection{L, T}
    vprops::Dict{L, V}    # Make these Union{No*, Dict{T, R}} etc?
    eprops::Dict{L, E}    # This should actually be something like Dict{Edge, EP} or Dict{Tuple{VL,VL}, EP}
end


function PropertyGraph{T, G, L, V, E}() where {T, G, L, V, E}
    PropertyGraph(
        G(),
        Bijection{L, T}(),
        Dict{L, V}(),
        Dict{L, E}()
    )
end


function PropertyGraph{T, G, L, V}() where {T, G, L, V}
    PropertyGraph{T, G, L, V, NoEdgeProperties}()
end


function PropertyGraph{T, G, L}() where {T, G, L}
    PropertyGraph{T, G, L, NoVertexProperties}()
end


SimplePropertyGraph{T, L, V, E} = PropertyGraph{T, SimpleGraph{T}, L, V, E}


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


function LightGraphs.is_directed(::Type{PropertyGraph{T,G,L,V,E}}) where {T,G,L,V,E}
    is_directed(G)
end


function LightGraphs.add_vertex!(pg::SimplePropertyGraph, vlabel)
    if vlabel in pg
        return false
    end

    added = add_vertex!(pg.g)
    if added
        pg.vmap[vlabel] = nv(pg)
    end

    added
end


LightGraphs.add_edge!(pg::SimplePropertyGraph, u, v) = add_edge!(pg.g, Edge(pg, u, v))


Base.setindex!(pg::PropertyGraph, val, vlabel) = ( pg.vprops[vlabel] = val )
Base.getindex(pg::PropertyGraph, vlabel) = pg.vprops[vlabel]
