from engine.table.table_layout import TableLayout


table = TableLayout(seats=6)

chair = table.seat_player("Tasha")

assert chair.seat_number == 1

chair = table.seat_player("Grace")

assert chair.seat_number == 2

assert len(table.occupied_chairs()) == 2
assert len(table.empty_chairs()) == 4

assert table.remove_player("Grace") is True

assert len(table.occupied_chairs()) == 1

print("Table layout test passed.")
