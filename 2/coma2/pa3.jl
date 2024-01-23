mutable struct Node
    successors::Vector{Node}
    name::String
    color::Symbol

    function Node(name::String)::Node
        new([], name, :white)
    end
end

function top_sort(G::Vector{Node})::Vector{Node}
    return dfs(G)
end

function dfs(G::Vector{Node}, L::Vector{Any} = [])
    for u in G
        if u.color == :white
            dfs_visit(G, u, L)
        end
    end
    return L
end

function dfs_visit(G::Vector{Node}, u::Node, L::Vector{Any})
    if u.color == :black
        return
    end
    if u.color == :gray
        error("Der Graph enthaelt einen Kreis!")
    end
    u.color = :gray
    for v in u.successors
        dfs_visit(G, v, L)
    end
    u.color = :black
    pushfirst!(L, u)
end
