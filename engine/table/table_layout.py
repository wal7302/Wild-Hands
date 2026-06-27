from engine.table.chair import Chair


class TableLayout:

    def __init__(self, seats=6):

        self.chairs = [
            Chair(seat_number=i + 1)
            for i in range(seats)
        ]

    def seat_player(self, player_name):

        for chair in self.chairs:

            if not chair.occupied:

                chair.occupied_by = player_name

                return chair

        return None

    def remove_player(self, player_name):

        for chair in self.chairs:

            if chair.occupied_by == player_name:

                chair.occupied_by = None

                return True

        return False

    def occupied_chairs(self):

        return [
            chair
            for chair in self.chairs
            if chair.occupied
        ]

    def empty_chairs(self):

        return [
            chair
            for chair in self.chairs
            if not chair.occupied
        ]

    def seating_chart(self):

        return [
            {
                "seat": chair.seat_number,
                "player": chair.occupied_by
            }
            for chair in self.chairs
        ]
