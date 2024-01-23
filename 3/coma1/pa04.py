def sieve(n):
    if n < 2:
        return None

    list_of_all_numbers = [True] * (n+1)

    i = 2
    while i ** 2 <= n:
        if not list_of_all_numbers[i]:
            i += 1
            continue
        j = 2
        while i * j - 1 < n:
            list_of_all_numbers[i*j] = False
            j += 1
        i += 1

    result = []
    for i in range(2, len(list_of_all_numbers)):
        if list_of_all_numbers[i]:
            result.append(i)

    return result

def isprime(n):
    if n < 2:
        return None

    sieve_result = sieve(n)
    if sieve_result[-1] == n:
        return True

    return False

def factorization(n):
    if n < 2:
        return None

    candidates = sieve(int(n/2)+1)

    is_dividable = False
    for prime_factor in candidates:
        if (n % prime_factor) == 0:
            is_dividable = True
            break
    if not is_dividable:
        return [[n, 1]]

    result = []
    for prime_factor in candidates:
        if n % prime_factor != 0:
            continue
        j = 2
        while n % (prime_factor ** j) == 0:
            j += 1
        result.append([prime_factor, j-1])

    return result

def euler_phi(n):
    if n < 1:
        return None
    if n == 1:
        return 1
    list_of_prime_factors = factorization(n)
    result = 1
    for prime_factor in list_of_prime_factors:
        p = prime_factor[0]
        e = prime_factor[1]
        result *= p ** e - p ** (e-1)
    return result

def iscoprime(m, n):
    if m < 1 or n < 1:
        return None
    if m == 1 or n == 1:
        return True
    m_factorization = factorization(m)
    n_factorization = factorization(n)
    factors_m = set()
    factors_n = set()
    for i in m_factorization:
        factors_m.add(i[0])
    for i in n_factorization:
        factors_n.add(i[0])
    return factors_m.isdisjoint(factors_n)
