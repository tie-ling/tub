def abstand(s, t, dateiname="labyrinth.dat"):
    if s == t:
        return 0
    labyrinth_matrix = []
    with open(dateiname, "r") as labyrinth_file:
        labyrinth_list = labyrinth_file.readlines()
        for line in labyrinth_list:
            labyrinth_matrix.append([])
            for single_char in line:
                if single_char == "U":
                    labyrinth_matrix[-1].append([False, False])
                if single_char == "P":
                    labyrinth_matrix[-1].append([True, False])
    start_point = list(s)
    end_point = list(t)
    list_of_steps = [[start_point]]

    while breitensuche(list_of_steps, end_point, labyrinth_matrix):
        if list_of_steps[-1] == []:
            return -1
    else:
        return len(list_of_steps) - 1


def breitensuche(list_of_steps, t, labyrinth_matrix):
    list_of_start_points = list_of_steps[-1]
    list_of_steps.append([])
    for point in list_of_start_points:
        for next_point in next_step(point, labyrinth_matrix):
            list_of_steps[-1].append(next_point)
            if next_point == t:
                return False
    return True


def next_step(s, labyrinth_matrix):
    list_of_possible_points = []
    list_of_possible_points_without_invalid_points = []
    line_number_of_s = s[0]
    col_number_of_s = s[1]
    number_of_lines_in_matrix = len(labyrinth_matrix) - 1
    number_of_cols_in_matrix = len(labyrinth_matrix[0]) - 1
    if line_number_of_s != 0:
        list_of_possible_points.append([line_number_of_s - 1, col_number_of_s])
    if line_number_of_s != number_of_lines_in_matrix:
        list_of_possible_points.append([line_number_of_s + 1, col_number_of_s])
    if col_number_of_s != 0:
        list_of_possible_points.append([line_number_of_s, col_number_of_s - 1])
    if col_number_of_s != number_of_cols_in_matrix:
        list_of_possible_points.append([line_number_of_s, col_number_of_s + 1])
    for point in list_of_possible_points:
        if ((not labyrinth_matrix[point[0]][point[1]][1])
           and labyrinth_matrix[point[0]][point[1]][0]):
            list_of_possible_points_without_invalid_points.append(point)
    for point in list_of_possible_points_without_invalid_points:
        labyrinth_matrix[point[0]][point[1]][1] = True
    return list_of_possible_points_without_invalid_points

def next_pos(s, input_mat):
    test_next_pos = [
        (s[0] - 1, s[1]), (s[0] + 1, s[1]),
        (s[0], s[1] - 1), (s[0], s[1] + 1)]
    result_next_pos = []
    for p in test_next_pos:
        try:
            if input_mat[p[0]][p[1]][0] and (not input_mat[p[0]][p[1]][1]):
                result_next_pos.append(p)
                input_mat[p[0]][p[1]][1] = True
        except IndexError:
            continue
    return result_next_pos
