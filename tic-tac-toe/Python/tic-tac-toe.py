table = {
    "1": -1,
    "2": -1,
    "3": -1,
    "4": -1,
    "5": -1,
    "6": -1,
    "7": -1,
    "8": -1,
    "9": -1,
}

empty_table = table.copy()

player = False


def get_player_num():
    return 1 if player else 0


def print_table():
    def fmt(x, i):
        if x == 0:
            return "O"
        elif x == 1:
            return "X"
        return str(i)

    print(
        "".join(
            f"|{fmt(table[e], i)}|" + ("\n" if i % 3 == 0 else "")
            for i, e in enumerate(table, start=1)
        )
    )


def check_for_win():
    pnum = get_player_num()

    def check_vertical(offset):
        return (
            table[str(offset)] == pnum
            and table[str(offset + 3)] == pnum
            and table[str(offset + 6)] == pnum
        )

    def check_horizontal(offset):
        return (
            table[str(offset)] == pnum
            and table[str(offset + 1)] == pnum
            and table[str(offset + 2)] == pnum
        )

    def check_diagonal():
        return (table["1"] == pnum and table["5"] == pnum and table["9"] == pnum) or (
            table["3"] == pnum and table["5"] == pnum and table["7"] == pnum
        )

    vertical = any(check_vertical(i) for i in range(1, 4))
    horizontal = any(check_horizontal(i) for i in range(1, 10, 3))
    diagonal = check_diagonal()

    return vertical or horizontal or diagonal


def check_for_tie():
    return all(table[e] != -1 for e in table)


loop = True

while loop:
    while 1:
        print_table()

        print(f"Turn: Player {player+1}.")
        x = input("Pos: ")

        try:
            f = table[x]
        except:
            print("Err: Invalid pos.")
            continue

        if f != -1:
            print("Err: This field is taken.")
            continue

        table[x] = get_player_num()

        if check_for_win():
            print_table()
            print(f"Player {player+1} wins!")
            break

        if check_for_tie():
            print_table()
            print(f"Tie!")
            break

        player = not player

    while 1:
        x = input("Play again? (1/0): ")

        if x == "1":
            table = empty_table.copy()
            player = False
            break

        elif x == "0":
            loop = False
            print("Goodbye!")
            break
