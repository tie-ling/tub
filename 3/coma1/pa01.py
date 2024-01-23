def roots(a2, a1, a0, b2, b1, b0):
    clist = [
        1,
        a2 * b2,
        a2 * b1 + a1 * b2,
        a2 * b0 + a1 * b1 + a0 * b2,
        a1 * b0 + a0 * b1,
        a0 * b0,
    ]

    not_negative = True
    vorzeichenwechsel = 0
    for i in clist:
        if i < 0:
            if not_negative == True:
                not_negative = False
                vorzeichenwechsel += 1
        elif not_negative == False and i != 0:
            not_negative = True
            vorzeichenwechsel += 1
    if vorzeichenwechsel % 2 == 0:
        return "Das Polynom hat eine gerade Anzahl von positiven reellen Nullstellen."
    else:
        return "Das Polynom hat eine ungerade Anzahl von positiven reellen Nullstellen."
