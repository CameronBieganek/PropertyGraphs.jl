

# -------- TODO!!! --------

# Add tests.

# Add docs.

# Add get, get!, haskey.

# Implement Edge properties.

# Implement weights functionality.

# Rename labels() to keys() ?
# Although if you have both vertex properties and edge properties, it's
# less clear what the keys are and what the values are, since there's actually
# two dictionaries.

# Perhaps use labels() and edge_labels() instead of keys() ?

# Add vertex_properties() and edge_properties() instead of values() ?

# Add show() method.

# Add merge, join, union, etc, methods.

# ---------------------------



struct NoVertexProperties end
struct NoEdgeProperties end


# V and E are any types with getproperty() defined.
struct PropertyGraph{T, G <: AbstractGraph{T}, L, V, E} <: AbstractGraph{T}
    g::G
    vmap::Bijection{L, T}
    vprops::Dict{L, V}    # Make these Union{No*, Dict{T, R}} etc?
    eprops::Dict{L, E}    # This should actually be something like Dict{Edge, EP} or Dict{Tuple{VL,VL}, EP}
end


Base.broadcastable(pg::PropertyGraph) = Ref(pg)


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
SimplePropertyDiGraph{T, L, V, E} = PropertyGraph{T, SimpleDiGraph{T}, L, V, E}
const SimpleAlias = Union{SimplePropertyGraph, SimplePropertyDiGraph}


(pg::PropertyGraph)(label) = pg.vmap[label]
(pg::SimpleAlias)(src_label, dst_label) = Edge(pg(src_label), pg(dst_label))


label(pg::PropertyGraph, code) = pg.vmap(code)


labels(pg::PropertyGraph) = domain(pg.vmap)
Base.in(label, pg::PropertyGraph) = (label in labels(pg))


LightGraphs.edges(pg::PropertyGraph) = edges(pg.g)
LightGraphs.vertices(pg::PropertyGraph) = vertices(pg.g)
LightGraphs.nv(pg::PropertyGraph) = nv(pg.g)
LightGraphs.ne(pg::PropertyGraph) = ne(pg.g)
LightGraphs.inneighbors(pg::PropertyGraph, code) = inneighbors(pg.g, code)
LightGraphs.outneighbors(pg::PropertyGraph, code) = outneighbors(pg.g, code)


function LightGraphs.is_directed(::Type{PropertyGraph{T,G,L,V,E}}) where {T,G,L,V,E}
    is_directed(G)
end


function LightGraphs.add_vertex!(pg::SimpleAlias, label)
    if label in pg
        return false
    end

    added = add_vertex!(pg.g)
    if added
        pg.vmap[label] = nv(pg)
    end

    added
end


LightGraphs.add_edge!(pg::SimpleAlias, e::Edge) = add_edge!(pg.g, e)

function LightGraphs.add_edge!(pg::SimpleAlias, src_label, dst_label)
    if  src_label in pg  &&  dst_label in pg
        add_edge!(pg, pg(src_label, dst_label))
    else
        return false
    end
end


Base.setindex!(pg::PropertyGraph, val, label) = ( pg.vprops[label] = val )
Base.getindex(pg::PropertyGraph, label) = pg.vprops[label]


function LightGraphs.rem_vertex!(pg::SimpleAlias, _label)
    code = pg(_label)
    last_code = nv(pg)
    removed = rem_vertex!(pg.g, code)

    if removed
        delete!(pg.vprops, _label)
        last_label = label(pg, last_code)

        delete!(pg.vmap, _label)
        # Bijections.jl requires deleting a key before changing its value.
        delete!(pg.vmap, last_label)
        pg.vmap[last_label] = code
    end

    removed
end


Base.reverse!(pg::SimpleAlias) = reverse!(pg.g)
