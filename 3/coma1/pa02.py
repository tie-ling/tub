def get_lattice_point_number(P, Q, T):
    for coord in T:
        if coord < 0:
            return "Die Eingabe ist fehlerhaft."
    standard_P, standard_Q = convert_to_standard(P, Q)
    if not intersects(standard_P, standard_Q, T):
        return "Der Schnitt der gegebenen Rechtecke ist leer."
    delta_x1 = get_delta_x1(standard_P[0], standard_Q[0], T[0])
    delta_x2 = get_delta_x2(standard_P[1], standard_Q[1], T[1])
    result = (delta_x1 + 1) * (delta_x2 + 1)
    return "Die Anzahl der Gitterpunkte im Rechteck betraegt " + str(result) + "."

def convert_to_standard(P, Q):
    list_of_x_coord = []
    list_of_y_coord = []
    for input_points in [P, Q]:
        list_of_x_coord.append(input_points[0])
        list_of_y_coord.append(input_points[1])
    standard_P = (min(list_of_x_coord), min(list_of_y_coord))
    standard_Q = (max(list_of_x_coord), max(list_of_y_coord))
    return standard_P, standard_Q

def intersects(P, Q, T):
    if P[0] > T[0]:
        return False
    if P[1] > T[1]:
        return False
    if Q[0] < 0:
        return False
    if Q[1] < 0:
        return False
    return True

def get_delta_x1(p1, q1, t1):
    if p1 < 0:
        return min(q1, t1)
    if q1 < t1:
        return q1 - p1
    return t1 - p1

def get_delta_x2(p2, q2, t2):
    if p2 < 0:
        return min(q2, t2)
    if q2 < t2:
        return q2 - p2
    return t2 - p2
