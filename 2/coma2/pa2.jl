mutable struct MaxHeap
    keys::Vector{Int}
    function MaxHeap(A::Vector{Int})
        heapSize = length(A)
        half_length = convert(Int, floor(heapSize / 2))
        for i in 1:half_length
            maxHeapify(A, half_length + 1 - i, heapSize)
        end
        new(A)
    end
end

function left(i::Int)
    return 2 * i
end

function right(i::Int)
    return 2 * i + 1
end

function maxHeapify(A::Vector{Int}, i::Int, heapSize::Int)
    l = left(i)
    r = right(i)
    if l ≤ heapSize && A[l] > A[i]
        largest = l
    else
        largest = i
    end
    if r ≤ heapSize && A[r] > A[largest]
        largest = r
    end
    if largest ≠ i
        exchange = A[largest]
        A[largest] = A[i]
        A[i] = exchange
        maxHeapify(A, largest, heapSize)
    else
        return A
    end
end

function maximum(A::MaxHeap)
    return A.keys[1]
end

function extractMax(A::MaxHeap)
    max = popfirst!(A.keys)
    MaxHeap(A.keys)
    return max
end

function increaseKey(A::MaxHeap, i::Int, k::Int)
    if A.keys[i] ≤ k
        A.keys[i] = k
    end
    return MaxHeap(A.keys)
end

function insert(A::MaxHeap, k::Int)
    push!(A.keys, k)
    return MaxHeap(A.keys)
end

function heapSort(A::MaxHeap)
    heapSize = length(A.keys)
    while heapSize > 1
        exchange = A.keys[heapSize]
        A.keys[heapSize] = A.keys[1]
        A.keys[1] = exchange
        heapSize -= 1
        maxHeapify(A.keys, 1, heapSize)
    end
    return A
end
