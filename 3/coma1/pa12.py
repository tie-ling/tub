def maxunimod(L):
    trend_folge = folge_zu_trend_folge(L)
    list_von_gipfel = suche_gipfel_position(trend_folge)
    länge_aller_teilfolge = rechnen_länge_aller_teilfolge(trend_folge, list_von_gipfel)
    try:
        result = max(länge_aller_teilfolge)
    except:
        result = len(L)
    return result

def trend(L, position):
    # 趋势
    # if 0, gleich
    # if 1, größer
    # if 2, kleiner
    # if 3, nicht entschieden
    if L[position] > L[position + 1]:
        return 2
    if L[position] < L[position + 1]:
        return 1
    return 0

def folge_zu_trend_folge(L):
    trend_folge = [ 3 ]
    for i in range(len(L)-1):
        trend_folge.append(trend(L, i))
    return trend_folge

def suche_gipfel_position(trend_folge):
    list_von_gipfel = []
    # gipfel im mittel
    for i in range(len(trend_folge)-1):
        if trend_folge[i] == 1:
            j = i + 1
            while j < len(trend_folge):
                if trend_folge[j] == 2:
                    list_von_gipfel.append(i)
                    break
                if trend_folge[j] == 0:
                    j += 1
                    continue
                break

    # gipfel am anfang
    j = 1
    while j < len(trend_folge) - 1:
        if trend_folge[j] == 0:
            j += 1
            continue
        if trend_folge[j] == 2:
            list_von_gipfel.append(0)
        break

    # gipfel am ende
    if trend_folge[-1] == 1:
        list_von_gipfel.append(len(trend_folge)-1)

    if trend_folge[-1] == 0:
        j = -2
        while trend_folge[j] == 0:
            j -= 1
        if trend_folge[j] == 1:
            list_von_gipfel.append(len(trend_folge) + j)

    return list_von_gipfel

def rechnen_länge_aller_teilfolge(trend_folge, list_von_gipfel):
    länge_aller_teilfolge = []
    länge_der_trend_folge = len(trend_folge)
    for gipfel in list_von_gipfel:
        länge = 1
        position = gipfel + 1
        # rechts von gipfel
        while position < länge_der_trend_folge and (trend_folge[position] == 2 or trend_folge[position] == 0):
            länge += 1
            position += 1
        # links von gipfel
        position = gipfel - 1
        while position > 0 and (trend_folge[position] == 1 or trend_folge[position] == 0):
            länge += 1
            position -= 1
        if gipfel != 0:
            länge += 1
        länge_aller_teilfolge.append(länge)
    return länge_aller_teilfolge

# 把输入的数列，转换为trend数列
# [0 0 0 0 1 1 1 1 1 1 2 2 2 2 2 2]
# [4, 5, 3, 2, 1, 3, 6, 4, 7, 3]
# [x, 1, 2, 2, 2, 1, 1, 2, 1, 2]
# 判断峰：峰是1,而且峰后紧跟2

# 输入原数列 -> 转换为趋势数列 -> 判断，峰 -> 判断，峰两侧的坡的长度。->
# 比较所有峰+坡的长度 -> 输出结果。

