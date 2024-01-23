const TupleSet = Vector{Tuple{Int,Int}}

function TupleSet(x::Vector{Tuple{Int, Int}})
    return sort(x)
end

struct Partition
    Sets::Vector{TupleSet}

    function Partition(V::TupleSet)::Partition
        p = []
        for tuple in V
            push!(p, [tuple])
        end
        return new(p)
    end
end

function MakeSet(P::Partition, s::Tuple{Int, Int})
    for tuple_set in P.Sets
        if s == tuple_set[1]
            return P
        end
    end
    push!(P.Sets, [s])
    return P
end

function FindSet(P::Partition, s::Tuple{Int, Int})
    for tuple_set in P.Sets
        if s ∈ tuple_set
            sorted_set = sort(tuple_set)
            return sorted_set[1]
        end
    end
    return -1
end

function del_set_from_sets(Sets::Vector{TupleSet}, t::Tuple{Int, Int})
    sets_length = length(Sets)
    while sets_length ≠ 0
        if t ∈ Sets[sets_length]
            result = Sets[sets_length]
            return result, deleteat!(Sets, sets_length)
        end
        sets_length -= 1
    end
    return [], Sets
end

function union!(P::Partition,
                s1::Tuple{Int, Int},
                s2::Tuple{Int, Int})
    S1, Sets = del_set_from_sets(P.Sets, s1)
    S2, Sets = del_set_from_sets(Sets, s2)
    new_set = []
    for tuple in S1
        push!(new_set, tuple)
    end
    for tuple in S2
        push!(new_set, tuple)
    end
    push!(P.Sets, sort(new_set))
    return P
end
