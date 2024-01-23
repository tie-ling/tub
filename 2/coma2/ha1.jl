struct Queue{Any}
    data::Vector{Any}
end

function isEmpty(Q::Queue)
    return Q.data == []
end

function insert(Q::Queue{Any}, x::Any)
        push!(Q.data, x)
end

pop(Q::Queue) =
    popfirst!(Q.data)

peek(Q::Queue) =
    first(Q.data)


struct Stack{Any}
    q0::Queue{Any}
    q1::Queue{Any}
end

stack_isEmpty(S::Stack{Any}) =
    isEmpty(S.q0) && isEmpty(S.q1)

function stack_insert(S::Stack{Any}, x::Any)
    insert(S.q1, x)
end

function move_to_other_queue(q0, q1)
    result = pop(q0)
    while ! isEmpty(q0)
        insert(q1, result)
        result = pop(q0)
    end
    return result
end

function stack_pop(S::Stack{Any})
    if stack_isEmpty(S)
        return
    end
    if isEmpty(S.q1)
        return move_to_other_queue(S.q0, S.q1)
    else
        return move_to_other_queue(S.q1, S.q0)
    end
end

function Catalan(n::Int)
    if n == 0
        return 1
    end

    result = 0
    for x in 0:n-1
        print("Mul ", "C", x, " C", n-1-x, "\n")
        result += Catalan(x) * Catalan(n-1-x)
    end

    return result
end

∞ = 99

function del_min_element(Y::Matrix)
    m, n = size(Y)
    x = 1
    y = 1

    while x < n && y < m
        if Y[x, y+1] < Y[x+1, y]
            Y[x, y] = Y[x, y+1]
            y += 1
            continue
        end
        if Y[x, y+1] > Y[x+1, y]
            Y[x, y] = Y[x+1, y]
            x += 1
            continue
        end
    end
    if x == n
        while y < m
            Y[x, y] = Y[x, y+1]
            y += 1
        end
    else
        while x < n
            Y[x, y] = Y[x+1, y]
            x += 1
        end
    end
    return Y
end
