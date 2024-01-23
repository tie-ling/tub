import random

def updatePosition(nlin, ncol, pos, rnd):
    if nlin == 1 and ncol == 1:
        return 0

    if rnd >= 0.75:
        result = pos - ncol
        if result >= 0:
            return result
        else:
            return result + nlin * ncol
    elif rnd >= 0.5:
        result = pos + ncol
        if result >= nlin * ncol:
            return result - nlin * ncol
        else:
            return result
    elif rnd >= 0.25:
        result = pos - 1
        if pos - (pos // ncol) * ncol == 0:
            return pos + (ncol - 1)
        else:
            return result
    else:
        result = pos + 1
        if result - (result // ncol) * ncol == 0:
            return result - ncol
        else:
            return result

def updatePositions(n, m, positions):
    for position in positions:
        position[1] = updatePosition(n, m, position[1], random.random())

def takekey(list1):
    return list1[1]

def sortPositions(positions):
    positions.sort(key = takekey)


def extractSquare(positions):
    square = []
    max_eintrag = positions[-1][1]
    while True:
        try:
            positions[-1][1]
        except:
            break
        if positions[-1][1] != max_eintrag:
            break
        eintrag = positions.pop()
        square.append(eintrag)
    return positions, square

# Z, ZH, H, HH

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

def mergeSquare(square, intermediate):
    return intermediate + square

def christmasFated(positions):
    all_pos = []
    for i in positions:
        all_pos.append(i[0])
    for i in all_pos:
        if i == 'H' or i == 'HH':
            for j in all_pos:
                if j == 'Z':
                    return False
    return True

def christmasFate(positions):
    all_pos = []
    for i in positions:
        all_pos.append(i[0])
    if 'H' not in all_pos and 'HH' not in all_pos:
        return 'Zombies ate my Christmas!'
    if 'Z' not in all_pos and ('H' in all_pos or 'HH' in all_pos):
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
