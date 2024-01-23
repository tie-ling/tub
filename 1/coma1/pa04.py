def get_min(int_list):
    list_index = len(int_list) - 1

    if list_index == -1:
        return

    min = int_list[list_index]
    list_index -= 1

    while list_index >= 0:
        if int_list[list_index] <= min:
            min = int_list[list_index]
        list_index -= 1

    return min


def get_linedistance(points, line):
    line_a = line[0]
    line_b = line[1]
    sum = 0

    number_of_points = len(points) - 1

    while number_of_points >= 0:
        point_x = points[number_of_points][0]
        point_y = points[number_of_points][1]
        sum += (line_a * point_x + line_b - point_y) ** 2
        number_of_points -= 1

    return sum


def linear_regression(points, lines):
    number_of_lines = len(lines) - 1
    list_of_sums = []

    while number_of_lines >= 0:
        list_of_sums.append(get_linedistance(points, lines[number_of_lines]))
        number_of_lines -= 1

    return get_min(list_of_sums)
