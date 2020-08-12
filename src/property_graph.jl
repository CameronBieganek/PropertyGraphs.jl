

abstract type AbstractPropertyGraph{T} <: AbstractGraph{T} end


struct LabeledVertexPropertyGraph{L, P <: NamedTuple, T, G <: AbstractGraph{T}} <: AbstractPropertyGraph{T}
    g       ::  G
    vindex  ::  Dict{L, T}   # map from custom index to primitive index
    vprops  ::  P            # vertex property data
end


function LabeledVertexPropertyGraph(
        g::AbstractGraph{T};
        vertex_label_type::Type,
        vertex_properties_type::NamedTuple
    ) where T

    vindex = Dict{vertex_label_type, T}()

    props = keys(vertex_properties_type)
    prop_types = values(vertex_properties_type)

    ps = map(props, prop_types) do p, PT
        p => Dict{T, PT}()
    end

    vprops = (; ps...)

    LabeledVertexPropertyGraph(g, vindex, vprops)
end


edges(pg::AbstractPropertyGraph) = edges(pg.g)
vertices(pg::AbstractPropertyGraph) = vertices(pg.g)
nv(pg::AbstractPropertyGraph) = nv(pg.g)
ne(pg::AbstractPropertyGraph) = ne(pg.g)
inneighbors(pg::AbstractPropertyGraph, v) = inneighbors(pg.g, pindex(pg, v))
outneighbors(pg::AbstractPropertyGraph, v) = outneighbors(pg.g, pindex(pg, v))



# Get the primitive index.
pindex(pg::AbstractPropertyGraph, i::Integer) = i
pindex(pg::AbstractPropertyGraph, vlabel) = pg.vindex[vlabel]

pindex(pg::AbstractPropertyGraph, e::Edge) = e
pindex(pg::AbstractPropertyGraph, u, v) = Edge(pindex(pg, u), pindex(pg, v))


struct VertexProperties{G <: AbstractPropertyGraph, L}
    g::G
    vlabel::L
end


get_graph(vp::VertexProperties) = getfield(vp, :g)
get_vlabel(vp::VertexProperties) = getfield(vp, :vlabel)


getindex(pg::AbstractPropertyGraph, v) = VertexProperties(pg, v)


function getproperty(vp::VertexProperties, prop::Symbol)
    g = get_graph(vp)
    vlabel = get_vlabel(vp)
    g.vprops[prop][pindex(g, vlabel)]
end


function setproperty!(vp::VertexProperties, prop::Symbol, val)
    g = get_graph(vp)
    vlabel = get_vlabel(vp)
    g.vprops[prop][pindex(g, vlabel)] = val
end


getindex(vp::VertexProperties, prop::Symbol) = getproperty(vp, prop)
setindex!(vp::VertexProperties, val, prop::Symbol) = setproperty!(vp, prop, val)


function setindex!(pg::LabeledVertexPropertyGraph, kvs, vlabel)
    for (k, v) in pairs(kvs)
        pg[vlabel][k] = v
    end
    pairs
end


add_vertex!(pg::AbstractPropertyGraph) = add_vertex!(pg.g)

function add_vertex!(pg::AbstractPropertyGraph, vlabel)
    added = add_vertex!(pg.g)
    if added
        i = nv(pg)
        pg.vindex[vlabel] = i
    end
    added
end

function add_vertex!(pg::AbstractPropertyGraph, i::Integer)
    msg = "The syntax `add_vertex!(pg, vlabel)` is reserved for adding a vertex with a custom index"
    throw(ArgumentError(msg))
end


add_edge!(pg::AbstractPropertyGraph, e::Edge) = add_edge!(pg.g, e)
add_edge!(pg::AbstractPropertyGraph, u, v) = add_edge!(pg, pindex(pg, u, v))


# TODO: Add add_vertex!(pg, vlabel, props) method.

# TODO: Figure out if this should be included:
# add_vindex!(pg::AbstractPropertyGraph, i::Integer, vlabel) = ( pg.vindex[vlabel] = i )

# TODO: Add print methods.

# TODO: Support get, get!, haskey, keys, values, etc, methods on VertexProperties?
