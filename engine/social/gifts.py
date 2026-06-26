class GiftCategory:

    FOOD = "food"
    DRINK = "drink"
    CELEBRATION = "celebration"
    COMFORT = "comfort"
    FUNNY = "funny"


class Gift:

    def __init__(
        self,
        gift_id,
        name,
        category,
        coin_cost,
        animation_key,
        unlock_level=1,
    ):

        self.gift_id = gift_id
        self.name = name
        self.category = category
        self.coin_cost = coin_cost
        self.animation_key = animation_key
        self.unlock_level = unlock_level


class GiftLibrary:

    DEFAULT_GIFTS = [

        Gift(
            "coffee",
            "Coffee",
            GiftCategory.DRINK,
            10,
            "gift_coffee",
        ),

        Gift(
            "cookies",
            "Cookies",
            GiftCategory.FOOD,
            15,
            "gift_cookies",
        ),

        Gift(
            "whiskey",
            "Whiskey",
            GiftCategory.DRINK,
            25,
            "gift_whiskey",
        ),

        Gift(
            "wine",
            "Wine",
            GiftCategory.DRINK,
            25,
            "gift_wine",
        ),

        Gift(
            "pizza",
            "Pizza",
            GiftCategory.FOOD,
            30,
            "gift_pizza",
        ),

        Gift(
            "birthday_cake",
            "Birthday Cake",
            GiftCategory.CELEBRATION,
            50,
            "gift_birthday_cake",
        ),

        Gift(
            "crying_towel",
            "Crying Towel",
            GiftCategory.FUNNY,
            20,
            "gift_crying_towel",
        ),

        Gift(
            "smoke",
            "Smoke",
            GiftCategory.FUNNY,
            20,
            "gift_smoke",
        ),
    ]

    @staticmethod
    def all_default():

        return GiftLibrary.DEFAULT_GIFTS

    @staticmethod
    def find(gift_id):

        for gift in GiftLibrary.DEFAULT_GIFTS:

            if gift.gift_id == gift_id:

                return gift

        return None
