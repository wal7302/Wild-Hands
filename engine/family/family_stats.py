from dataclasses import dataclass


@dataclass
class FamilyStats:

    total_games_played: int = 0
    total_rounds_played: int = 0
    wilds_discarded: int = 0
    gifts_sent: int = 0
    closest_finish_points: int | None = None
    biggest_comeback_points: int = 0

    def record_game_played(self):

        self.total_games_played += 1

    def record_round_played(self):

        self.total_rounds_played += 1

    def record_wild_discarded(self):

        self.wilds_discarded += 1

    def record_gift_sent(self):

        self.gifts_sent += 1

    def record_closest_finish(self, point_difference):

        if self.closest_finish_points is None:
            self.closest_finish_points = point_difference
            return

        if point_difference < self.closest_finish_points:
            self.closest_finish_points = point_difference
