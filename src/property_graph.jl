

abstract type AbstractPropertyGraph{T} <: AbstractGraph{T} end


struct LabeledVertexPropertyGraph{L, P <: NamedTuple, T, G <: AbstractGraph{T}} <: AbstractPropertyGraph{T}
    g       ::  G
    gprops  ::  Dict{Symbol, Any}
    pindex  ::  Dict{L, T}         # map from vertex label to primitive index
    vlabel  ::  Dict{T, L}         # map from primitive index to vertex label
    vprops  ::  P                  # vertex property data
end


function LabeledVertexPropertyGraph(
        g::AbstractGraph{T};
        vertex_label_type::Type,
        vertex_properties_type::NamedTuple
    ) where T

    gprops = Dict{Symbol, Any}()
    pindex = Dict{vertex_label_type, T}()
    vlabel = Dict{T, vertex_label_type}()

    props = keys(vertex_properties_type)
    prop_types = values(vertex_properties_type)

    ps = map(props, prop_types) do p, PT
        p => Dict{T, PT}()
    end

    vprops = (; ps...)

    LabeledVertexPropertyGraph(g, gprops, pindex, vlabel, vprops)
end


get_gprops(pg::AbstractPropertyGraph) = getfield(pg, :gprops)


getproperty(pg::AbstractPropertyGraph, sym::Symbol) = get_gprops(pg)[sym]
setproperty!(pg::AbstractPropertyGraph, sym::Symbol, val) = get_gprops(pg)[sym] = val
propertynames(pg::AbstractPropertyGraph) = (keys(get_gprops(pg))..., )


get_graph(pg::AbstractPropertyGraph) = getfield(pg, :g)
get_pindex(pg::AbstractPropertyGraph) = getfield(pg, :pindex)
get_vlabel(pg::AbstractPropertyGraph) = getfield(pg, :vlabel)
get_vprops(pg::AbstractPropertyGraph) = getfield(pg, :vprops)


edges(pg::AbstractPropertyGraph) = edges(get_graph(pg))
vertices(pg::AbstractPropertyGraph) = vertices(get_graph(pg))
nv(pg::AbstractPropertyGraph) = nv(get_graph(pg))
ne(pg::AbstractPropertyGraph) = ne(get_graph(pg))
inneighbors(pg::AbstractPropertyGraph, v) = inneighbors(get_graph(pg), pindex(pg, v))
outneighbors(pg::AbstractPropertyGraph, v) = outneighbors(get_graph(pg), pindex(pg, v))


# Get the primitive index.
pindex(pg::AbstractPropertyGraph, i::Integer) = i
pindex(pg::AbstractPropertyGraph, vlabel) = get_pindex(pg)[vlabel]

pindex(pg::AbstractPropertyGraph, e::Edge) = e
pindex(pg::AbstractPropertyGraph, u, v) = Edge(pindex(pg, u), pindex(pg, v))


# Get the vertex label.
vlabel(pg::AbstractPropertyGraph, pindex::Integer) = get_vlabel(pg)[pindex]


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
    get_vprops(g)[prop][pindex(g, vlabel)]
end


function setproperty!(vp::VertexProperties, prop::Symbol, val)
    g = get_graph(vp)
    vlabel = get_vlabel(vp)
    get_vprops(g)[prop][pindex(g, vlabel)] = val
end


getindex(vp::VertexProperties, prop::Symbol) = getproperty(vp, prop)
setindex!(vp::VertexProperties, val, prop::Symbol) = setproperty!(vp, prop, val)


function setindex!(pg::LabeledVertexPropertyGraph, kvs, vlabel)
    for (k, v) in pairs(kvs)
        pg[vlabel][k] = v
    end
    pairs
end


function add_vertex!(pg::AbstractPropertyGraph, vlabel)
    added = add_vertex!(get_graph(pg))
    if added
        pindex = nv(pg)
        get_pindex(pg)[vlabel] = pindex
        get_vlabel(pg)[pindex] = vlabel
    end
    added
end

function add_vertex!(pg::AbstractPropertyGraph, i::Integer)
    msg = "The syntax `add_vertex!(pg, vlabel)` is reserved for adding a vertex with a custom index"
    throw(ArgumentError(msg))
end


add_edge!(pg::AbstractPropertyGraph, e::Edge) = add_edge!(get_graph(pg), e)
add_edge!(pg::AbstractPropertyGraph, u, v) = add_edge!(pg, pindex(pg, u, v))


# TODO: Add add_vertex!(pg, vlabel, props) method.

# TODO: Figure out if this should be included:
# add_vlabel!(pg::AbstractPropertyGraph, i::Integer, vlabel) = ( get_pindex(pg)[vlabel] = i )

# TODO: Add print methods.

# TODO: Support get, get!, haskey, keys, values, etc, methods on VertexProperties?

# TODO: Make property graphs broadcast like a scalar. This enables vlabel.(g, inneighbors(g, label))
