mutable struct Stack{T}
    data::Vector{T}
end

function isEmpty(Q::Stack)
    return Q.data == []
end

function insert(Q::Stack, x)
    push!(Q.data, x)
    return Q
end

function pop(Q::Stack)
    return pop!(Q.data)
end

function peek(Q::Stack)
    return last(Q.data)
end

mutable struct Queue
    reversed::Stack
    not_reversed::Stack
    function Queue(data::Vector)
        return new(Stack([]), Stack(data))
    end
end

function queue_isEmpty(Q::Queue)
    return isEmpty(Q.reversed) && isEmpty(Q.not_reversed)
end

function queue_insert(Q::Queue, x)
    insert(Q.not_reversed, x)
    return Q
end

function queue_pop(Q::Queue)
    #
    # Case 1:
    ## if the reversed stack is not empty,
    ## pop the reversed stack first.
    #
    if ! isEmpty(Q.reversed)
        return pop(Q.reversed)

    #
    # Case 2:
    ## if the reversed stack of queue is empty,
    ## and not_reversed stack is not empty,
    ##
    ## pop all elements in not_reversed stack, then
    ## insert all but last popped element into reversed stack.
    ## Return the last popped element as result.
    #
    elseif ! isEmpty(Q.not_reversed)
        result = pop(Q.not_reversed)
        while ! isEmpty(Q.not_reversed)
            insert(Q.reversed, result)
            result = pop(Q.not_reversed)
        end
        return result
    else
    #
    # Case 3:
    ## Both stacks are empty. Then the queue is empty.
    #
        return "Queue is empty!"
    end
end

function Catalan(n::Int, list_of_results::Vector{Union{Nothing, Int}})
    if n == 0
        return 1
    end

    if list_of_results[n] != nothing
        return list_of_results[n]
    end

    result = 0
    for x in 0:n-1
        result += Catalan(x, list_of_results) * Catalan(n-1-x, list_of_results)
    end

    return result
end

function Catalan2(n::Int)
    if n == 0
        return 1
    end

    list_of_results = Vector{Union{Nothing, Int}}(nothing, n)

    for x in 1:n
        list_of_results[x] = Catalan(x, list_of_results)
    end

    return last(list_of_results)
end


function CatalanTriangle(n::Int)
    # only the last two lines of the triangle is needed
    l0 = Vector{Union{Nothing, Int}}(nothing, n+1)
    l1 = Vector{Union{Nothing, Int}}(nothing, n+1)

    # be careful, julia array indices begin with 1 (number one)
    for x in 0:n-1
        l0 = copy(l1)
        l0[1] = 1;  l1[1] = 1
        l0[2] = x;  l1[2] = x+1
        for k in 2:x+1
            l1[k] = l1[k-1] + l0[k]
        end
        if x > 0
            l1[x + 2] = l1[x + 1]
        end
    end

    return l1[n]
end
