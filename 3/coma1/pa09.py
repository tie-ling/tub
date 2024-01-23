def matrix_string_to_list(matrix_string):
    result = []
    for i in matrix_string.split(","):
        result.append([])
        for j in i.split(" "):
            try:
                result[-1].append(int(j))
            except:
                continue
    return result

def matrix_list_to_string(matrix_list):
    result = ""
    for i in matrix_list:
        len_i = len(i)
        idx_j = 1
        for j in i:
            result += str(j)
            if idx_j == len_i:
                result += ", "
            else:
                result += " "
            idx_j += 1
    return result[:-2]


def multiply(A, B):
    matA = matrix_string_to_list(A)
    matB = matrix_string_to_list(B)
    result = []
    for i in matA:
        line_result = []
        for j in range(len(matB[0])):
            left = i
            right = []
            for k in matB:
                right.append(k[j])
            minimum_result = []
            for p in range(len(left)):
                minimum_result.append(left[p] + right[p])
            line_result.append(min(minimum_result))
        result.append(line_result)
    return matrix_list_to_string(result)
        
def power(A, m, B = 0):
    if m == 1:
        return A
    if B == 0:
        B = A
    return power(multiply(A, B), m - 1, B)
