from dataclasses import dataclass, field
from datetime import datetime


@dataclass
class HouseState:

    name: str = "Grace's House"
    room: str = "Game Room"

    time_label: str = "Friday Evening"
    season: str = "default"
    holiday: str | None = None
    weather: str = "clear"

    porch_light_on: bool = True
    fireplace_on: bool = True
    coffee_on: bool = True

    cookie_of_the_day: str = "Chocolate Chip Cookies"
    drink_of_the_night: str = "Red Wine"
    music: str = "Soft country music"

    decorations: list[str] = field(default_factory=list)

    generated_at: datetime = field(default_factory=datetime.now)

    def sensory_details(self):
        details = []

        if self.porch_light_on:
            details.append("The porch light is on.")

        if self.fireplace_on:
            details.append("The fireplace glows softly.")

        if self.coffee_on:
            details.append("Coffee is brewing.")

        details.append(f"{self.cookie_of_the_day} are cooling on the counter.")
        details.append(f"{self.music} plays quietly.")
        details.append(f"Grace has {self.drink_of_the_night.lower()} nearby.")

        return details
