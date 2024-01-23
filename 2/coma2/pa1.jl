mutable struct myNodeType
    key::Int
    left::Union{myNodeType, Nothing}
    right::Union{myNodeType, Nothing}
end

function Node(key::Int, left::Union{myNodeType, Nothing} = nothing,
    right::Union{myNodeType, Nothing} = nothing)
    return myNodeType(key, left, right)
end

function height(node::myNodeType)
    result = 1
    node_list = [ node ]
    node_list_next = [ ]
    while true
        if node_list == []
            node_list = node_list_next
            node_list_next = []
            result += 1
        end
        this_node = pop!(node_list)
        if this_node.left != nothing
            push!(node_list_next, this_node.left)
        end
        if this_node.right != nothing
            push!(node_list_next, this_node.right)
        end
        if node_list == [] && node_list_next == [ ]
            return result
        end
    end
end

function keys(node::myNodeType)
    node_list = [ node ]
    key_list = [ node.key ]
    while length(node_list) != 0
        this_node = pop!(node_list)
        if this_node.left != nothing
            push!(node_list, this_node.left)
            push!(key_list, this_node.left.key)
        end
        if this_node.right != nothing
            push!(node_list, this_node.right)
            push!(key_list, this_node.right.key)
        end
    end
    return sort(convert(Vector{Any}, key_list))
end

function leaves(node::myNodeType)
    node_list = [ node ]
    node_count = 1
    leaves_list = [ ]
    while length(node_list) != 0
        this_node = pop!(node_list)
        if this_node.left != nothing
            push!(node_list, this_node.left)
        end
        if this_node.right != nothing
            push!(node_list, this_node.right)
        end
        if this_node.left == nothing && this_node.right == nothing
            push!(leaves_list, this_node.key)
        end
    end
    return length(leaves_list)
end
