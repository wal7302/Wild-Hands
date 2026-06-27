from engine.experience.house_state import HouseState


class HouseBuilder:

    @staticmethod
    def default_friday_night():

        return HouseState(
            time_label="Friday Evening",
            weather="clear",
            cookie_of_the_day="Chocolate Chip Cookies",
            drink_of_the_night="Red Wine",
            music="Soft country music",
            decorations=[
                "solid walnut table",
                "fresh flowers",
                "family photos",
                "card box",
            ],
        )

    @staticmethod
    def rainy_evening():

        return HouseState(
            time_label="Rainy Evening",
            weather="rain",
            cookie_of_the_day="Oatmeal Raisin Cookies",
            drink_of_the_night="Red Wine",
            music="Soft jazz",
            decorations=[
                "solid walnut table",
                "rain on the windows",
                "warm blankets",
                "fresh flowers",
            ],
        )
