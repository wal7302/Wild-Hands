from dataclasses import dataclass


@dataclass
class Dealer:

    name: str
    host_id: str
    seat_number: int | None = None

    def announce(self, message):
        return f"{self.name}: {message}"
