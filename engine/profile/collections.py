class CollectionType:

    MUGS = "mugs"
    HATS = "hats"
    CARD_BACKS = "card_backs"
    PETS = "pets"
    GIFTS = "gifts"
    PHRASES = "phrases"
    ROOM_DECOR = "room_decor"


class CollectionItem:

    def __init__(
        self,
        item_id,
        name,
        collection_type,
        rarity,
        unlock_level=1,
        coin_cost=0,
        description="",
    ):
        self.item_id = item_id
        self.name = name
        self.collection_type = collection_type
        self.rarity = rarity
        self.unlock_level = unlock_level
        self.coin_cost = coin_cost
        self.description = description


class CollectionLibrary:

    DEFAULT_ITEMS = [

        CollectionItem(
            "mug_worlds_okayest",
            "World's Okayest Card Player",
            CollectionType.MUGS,
            "common",
            unlock_level=1,
            coin_cost=100,
            description="For guests who know winning is optional.",
        ),

        CollectionItem(
            "mug_professional_wild_tosser",
            "Professional Wild Tosser",
            CollectionType.MUGS,
            "rare",
            unlock_level=5,
            coin_cost=250,
            description="Unlocked by guests with questionable discard choices.",
        ),

        CollectionItem(
            "hat_cowboy",
            "Cowboy Hat",
            CollectionType.HATS,
            "common",
            unlock_level=1,
            coin_cost=100,
            description="For guests who bring big table energy.",
        ),

        CollectionItem(
            "hat_tiara",
            "Tiara",
            CollectionType.HATS,
            "common",
            unlock_level=1,
            coin_cost=100,
            description="Because someone has to be royalty at the table.",
        ),

        CollectionItem(
            "cardback_quilt",
            "Patchwork Quilt",
            CollectionType.CARD_BACKS,
            "common",
            unlock_level=1,
            coin_cost=150,
            description="A cozy card back inspired by family traditions.",
        ),
    ]

    @staticmethod
    def all_default():
        return CollectionLibrary.DEFAULT_ITEMS

    @staticmethod
    def find(item_id):
        for item in CollectionLibrary.DEFAULT_ITEMS:
            if item.item_id == item_id:
                return item

        return None
