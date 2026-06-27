from dataclasses import dataclass


@dataclass
class Chair:

    seat_number: int
    occupied_by: str | None = None
    style: str = "wood"
    cushion_color: str = "cranberry"

    @property
    def occupied(self):
        return self.occupied_by is not None
