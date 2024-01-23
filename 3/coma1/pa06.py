def abstand(s, t, dateiname="labyrinth.dat"):
    if s == t:
        return 0
    M = read_to_matrix(dateiname)
    BFS(s, t, M)
    return count_steps(s, M, t, 0)

def read_to_matrix(dateiname):
    result = []
    with open(dateiname, "r") as datei:
        lines = datei.readlines()
        for l in lines:
            result.append([])
            for c in l:
                if c == "U":
                    result[-1].append([False, False])
                if c == "P":
                    result[-1].append([True, False])
    return result

def possible_next_steps(s, M):
    tests = [
        (s[0] + 1, s[1]),
        (s[0], s[1] + 1),
    ]
    if s[0] - 1 >= 0:
        tests.append((s[0] - 1, s[1]))
    if s[1] - 1 >= 0:
        tests.append((s[0], s[1] - 1))
    result = []
    for p in tests:
        try:
            if M[p[0]][p[1]][0] and (not M[p[0]][p[1]][1]):
                result.append(p)
        except:
            continue
    return result

def BFS(s, t, M):
    Q = []
    M[s[0]][s[1]][1] = True
    Q.append(s)
    while len(Q) != 0:
        v = Q.pop(0)
        if v == t:
            return v
        for w in possible_next_steps(v, M):
            if not M[w[0]][w[1]][1]:
                M[w[0]][w[1]][1] = True
                M[w[0]][w[1]].append(v)
                Q.append(w)

def count_steps(s, M, now, count):
    if now == s:
        return count
    try:
        M[now[0]][now[1]][2]
    except:
        return -1
    else:
        return count_steps(s, M, M[now[0]][now[1]][2], count + 1)
