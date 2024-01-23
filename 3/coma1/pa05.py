def get_linedistance(points, line):
    result = 0
    a = line[0]
    b = line[1]
    for point in points:
        xi = point[0]
        yi = point[1]
        result += (a * xi + b - yi) ** 2
    return result

def get_optimal_line(points):
    x_mid = 0
    y_mid = 0
    for p in points:
        x_mid += p[0]
        y_mid += p[1]
    x_mid /= len(points)
    y_mid /= len(points)

    a_upper = 0
    a_lower = 0
    for p in points:
        a_upper += (p[0] - x_mid) * (p[1] - y_mid)
        a_lower += (p[0] - x_mid) ** 2
    a = a_upper / a_lower
    b = y_mid - a * x_mid
    return a, b

def distance_to_opt(points, lines):
    list_of_line_distances = []
    for l in lines:
        list_of_line_distances.append(get_linedistance(points, l))
    minimum_quad_distance = min(list_of_line_distances)
    optimal_line_distance = get_linedistance(points, list(get_optimal_line(points)))
    return minimum_quad_distance - optimal_line_distance
