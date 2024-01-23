function getFactor(v::Int)::Tuple{Int, Int}
    factor = convert(Int, floor(sqrt(v)))
    while mod(v, factor) ≠ 0
        factor -= 1
    end
    # returns tuple of factor (smaller, larger)
    return factor, v / factor
end

mutable struct FactorTree
    value::Int
    left::Union{Int, FactorTree}
    right::Union{Int, FactorTree}
    function FactorTree(v::Int)::FactorTree
        l, r = getFactor(v)
        if v == r
            return new(v, 1, v)
        else
            return new(v, FactorTree(l), FactorTree(r))
        end
    end
end

function leaves(t::FactorTree)
    leaves_list = []
    node_list = [ t ]
    while length(node_list) != 0
        this_node = pop!(node_list)
        if typeof(this_node.left) != Int
            push!(node_list, this_node.left)
        else
            push!(leaves_list, this_node.left)
        end
        if typeof(this_node.right) != Int
            push!(node_list, this_node.right)
        else
            push!(leaves_list, this_node.right)
        end
    end
    return sort(leaves_list)
end

function list_to_dict(list_of_factors::Vector)::Dict{Int, Int}
    dictionary = []
    factor = list_of_factors[1]
    counter = 0
    while length(list_of_factors) ≠ 0
        if factor == list_of_factors[1]
            counter += 1
            popfirst!(list_of_factors)
        else
            pushfirst!(dictionary, (factor, counter))
            counter = 0
            factor = list_of_factors[1]
        end
    end
    pushfirst!(dictionary, (factor, counter))
    return Dict(dictionary)
end

function getFactors(t::FactorTree)::Dict{Int, Int}
    # get all the leaves
    list_of_factors = leaves(t)
    # count them
    return list_to_dict(list_of_factors)
end

function getShape(t::Union{Int, FactorTree})::String
    if typeof(t) == Int
        return "p"
    end
    if typeof(t.left) == Int && typeof(t.right) == Int
        return "q"
    elseif typeof(t.left) == Int
        return "(" * "p" * getShape(t.right) * ")"
    elseif typeof(t.right) == Int
        return "(" * getShape(t.left) * "p" * ")"
    else
        return "(" * getShape(t.left) * getShape(t.right) * ")"
    end
end

function compareShape(t::FactorTree, h::FactorTree)::Bool
    return getShape(t) == getShape(h)
end

function computeShapes(n::Int)::Dict{String, Vector{Int}}
    result = Dict{String, Vector{Int}}()
    i = 1
    while i ≤ n
        shape = getShape(FactorTree(i))
        list_of_values = get!(result, shape, [])
        push!(result[shape], i)
        i += 1
    end
    return result
end
