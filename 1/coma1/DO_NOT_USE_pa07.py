import random
def updatePosition(n: int, m: int, pos: int, rnd: float):
    if m == 1 and n == 1:
        return 0
    if rnd < 0.25:                  #rechts
        if (pos + 1) % m == 0:
            return (pos - m + 1)
        else:
            return (pos + 1)
    elif rnd >= 0.25 and rnd < 0.5: #links
        if pos % m == 0:
            return (pos + m - 1)
        else:
            return (pos - 1)
    elif rnd >= 0.5 and rnd < 0.75: #unten
        if (pos + m) > (n * m - 1):
            return (pos - ((n-1) * m))
        else:
            return (pos + m)
    elif rnd >= 0.75 and rnd < 1:   #oben
        if pos - m < 0:
            return (pos + ((n-1) * m))
        else:
            return (pos - m)

def updatePositions(n: int, m: int, positions: list[list[str, int]]):
    for i in positions:
        i[1] = updatePosition(n, m, i[1], random.random())

def takekey(list1):
    return list1[1]

def sortPositions(positions: list[list[str, int]]):
    positions.sort(key = takekey)
    
def extractSquare(positions: list[list[str, int]]):
    square = []
    index = positions[-1][1]
    num = len(positions) - 1
    while num >= 0:
        if positions[num][1] == index:
            square.append(positions.pop())
        else:
            break
        num -= 1
    return positions,square

def giftExchange(square: list[list[str, int]]):
    Harfen_Zombie = 0
    HH = 0
    Z = 0
    for i in square:
        if i[0] == 'ZH':
            Harfen_Zombie = 1
    if Harfen_Zombie:
        for i in square:
            if i[0] == 'H':
                i[0] = 'HH'
    for i in square:
        if i[0] == 'HH':
            HH += 1
        if i[0] == 'Z':
            Z += 1
    if Z > 0:
        if Z >= 2 * HH:
            for i in square:
                if i[0] == 'H' or i[0] =='HH':
                    i[0] = 'Z'
        elif Z < 2 * HH:
            for i in square:
                if i[0] == 'Z':
                    i[0] = 'ZH'

def mergeSquare(square: list[list[str, int]],
                intermediate: list[list[str, int]]):
    for i in square:
        intermediate.append(i)
    return intermediate

def christmasFated(positions: list[list[str, int]]):
    Z = 0
    ZH = 0
    H_HH = 0
    for i in positions:
        if i[0] =='ZH':
            ZH = 1
        if i[0] == 'Z':
            Z = 1
        if i[0] == 'H' or i[0] == 'HH':
            H_HH = 1
    if Z == 0:
        return True
    elif  Z + ZH >= 1 and H_HH == 0:
        return True
    else:
        return False

def christmasFate(positions: list[list[str, int]]):
    Z = 0
    ZH = 0
    H_HH = 0
    for i in positions:
        if i[0] == 'H' or i[0] == 'HH':
            H_HH = 1
        if i[0] == 'Z':
            Z = 1
        if i[0] == 'ZH':
            ZH = 1
    if Z + ZH > 0 and H_HH == 0:
        return 'Zombies ate my Christmas!'
    elif Z == 0 and H_HH == 1:
        return 'Ho, ho, ho, and a merry Zombie-Christmas!'

def zombieChristmas(n,m,positions):
    result = []
    while (not christmasFated(result)):
        for i in result:
            positions.append(i)
        updatePositions(n,m,positions)
        sortPositions(positions)
        while len(positions) != 0:
            positions,square = extractSquare(positions)
            giftExchange(square)
            mergeSquare(square, result)
    return christmasFate(result)


