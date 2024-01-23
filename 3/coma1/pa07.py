def find_first_larger(L, e):
    # variable for list length
    # We will use this variable many times.
    L_len=len(L)

    # If empty list, return 0
    if L_len == 0:
        return 0

    # If larger than the last element, return
    # List length
    if e >= L[-1]:
        return L_len

    if e < L[0]:
        return 0


    m = binsearch(L, e)

    if m < L_len:
        if e == L[m]:
            n = binsearch(L, e+1)
            while L[n] > e:
                n -= 1
            return n + 1

    return m

def binsearch(L, e):
    L_len=len(L)

    # Initialize variables for binary search
    l = 0
    r = L_len - 1
    m = int((l+r)/2)

    while True:
        m = int((l+r)/2)
        if L[m] == e:
            return m
        if (L[m] < e) and (L[m+1] > e):
            return m + 1
        if L[m] < e:
            l = m + 1
        if L[m] > e:
            r = m - 1

def unique(L):
    L_len=len(L)

    # If empty list, return empty list
    if L_len == 0:
        return []

    # set initial index to 0
    idx = 0
    # add first list element to result
    result = [ L[0] ]

    # search for number without duplication
    while idx < L_len:
        idx = find_first_larger(L, L[idx])
        if idx < L_len:
            result.append(L[idx])

    return result
