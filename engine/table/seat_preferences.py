class SeatPreference:

    HOST_LEFT = "host_left"
    HOST_RIGHT = "host_right"
    RANDOM = "random"
    SAME_AS_LAST_GAME = "same_as_last_game"


class SeatAssignment:

    @staticmethod
    def assign(players, table):

        for player in players:

            table.seat_player(player.name)

        return table
