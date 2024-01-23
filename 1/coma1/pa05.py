def get_classes(number_of_nodes, list_of_arrows):
    node = 0
    list_of_classes = []
    while node < number_of_nodes:
        list_of_classes_of_this_node = [node]
        for arrow in list_of_arrows:
            if arrow[0] == node:
                list_of_classes_of_this_node.append(arrow[1])
        else:
            list_of_classes_of_this_node.sort()
            list_of_classes.append(list_of_classes_of_this_node)
        node += 1
    return list_of_classes


def are_equal(int_list1, int_list2):
    set_int_list1 = set(int_list1)
    set_int_list2 = set(int_list2)
    if set_int_list1 == set_int_list2:
        return True
    return False


def are_disjoint(int_list1, int_list2):
    set_int_list1 = set(int_list1)
    set_int_list2 = set(int_list2)
    if set_int_list1.intersection(set_int_list2) == set():
        return True
    return False


def get_eqclasses(number_of_nodes, list_of_arrows):
    list_of_classes = get_classes(number_of_nodes, list_of_arrows)
    number_of_classes = len(list_of_classes)
    list_of_eqclasses = []
    class_index = 0
    while class_index < number_of_classes:
        set_class_index = set(list_of_classes[class_index])
        for relation_class in list_of_classes[class_index::]:
            set_relation_class = set(relation_class)
            if set_class_index == set_relation_class:
                if relation_class not in list_of_eqclasses:
                    list_of_eqclasses.append(relation_class)
            elif ((set_class_index != set_relation_class) and
                  (set_class_index.intersection(set_relation_class) != set())):
                return []
        class_index += 1

    return list_of_eqclasses
