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

def add_to_line(col, line_a, line_b):
    result = line_b[col] // line_a[col]
    for i in range(col, len(line_b)):
        line_b[i] = line_b[i] - result * line_a[i]
    return result, line_b
    

def LU_decomposition(A):
    matA = matrix_string_to_list(A)
    col = len(matA)
    matL = []
    for i in range(col):
        matL.append([])
        for j in range(col):
            matL[-1].append(0)
    for i in range(col):
        matL[i][i] = 1

    for i in range(col):
        for j in range(i+1, col):
            matL[j][i], matA[j] = add_to_line(i, matA[i], matA[j])

    result = []
    for i in range(col):
        result.append([])
        for j in range(col):
            if not i > j:
                result[-1].append(matA[i][j])
            else:
                result[-1].append(matL[i][j])

    return matrix_list_to_string(result)


def transpose(M):
    line_count = len(M)
    col_count = len(M[0])
    result = []
    for i in range(col_count):
        result.append([])
        for j in range(line_count):
            result[-1].append(M[j][i])
    return result

def result_for_one_column(LU, b):
    result_y = []
    result_x = []
    n = len(b)
    for i in range(n):
        ly_sum = 0
        for k in range(i):
            ly_sum += LU[i][k] * result_y[k]
        result_y.append(b[i] - ly_sum)
    result_x.append(result_y[-1] // LU[-1][-1])
    for i in reversed(range(n-1)):
        ux_sum = 0
        for k in range(i+1, n):
            ux_sum += LU[i][k] * result_x[n-k-1]
        result_x.append((result_y[i] - ux_sum) // LU[i][i])
    result_x.reverse()
    return result_x
        
    

def solve_LGS(A, B):
    LU = matrix_string_to_list(LU_decomposition(A))
    transpose_B = transpose(matrix_string_to_list(B))
    transpose_result = []
    for i in transpose_B:
        transpose_result.append(result_for_one_column(LU, i))
    return matrix_list_to_string(transpose(transpose_result))
