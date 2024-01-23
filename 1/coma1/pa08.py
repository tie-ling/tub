def multiply(string_A, string_B):
    matrix_A = string_to_matrix(string_A)
    matrix_B = string_to_matrix(string_B)
    inverted_matrix_B = invert_matrix(matrix_B)
    matrix_C = []
    row_length = len(matrix_A[0])
    for row_in_A in matrix_A:
        matrix_C.append([])
        for row_in_B in inverted_matrix_B:
            list_of_sums = []
            for i in range(row_length):
                list_of_sums.append(row_in_A[i] + row_in_B[i])
            matrix_C[-1].append(min(list_of_sums))
    return matrix_to_string(matrix_C)


def string_to_matrix(my_string):
    my_matrix = []
    for row in my_string.split(","):
        row_sublist = []
        for entry in row.split(" "):
            if entry != '':
                row_sublist.append(int(entry))
        my_matrix.append(row_sublist)
    return my_matrix


def invert_matrix(my_matrix):
    new_matrix = []
    number_of_rows = len(my_matrix)
    number_of_cols = len(my_matrix[0])
    for col_index in range(number_of_cols):
        row_sublist = []
        for row_index in range(number_of_rows):
            row_sublist.append(my_matrix[row_index][col_index])
        new_matrix.append(row_sublist)
    return new_matrix


def matrix_to_string(my_matrix):
    my_string = ''
    for i in my_matrix:
        for j in i:
            my_string = my_string + ' ' + str(j)
        my_string = my_string + ','
    return my_string[1:-1]


def power(string_A, m):
    result = string_A
    for _ in range(2, m+1):
        result = multiply(result, string_A)
    return result
