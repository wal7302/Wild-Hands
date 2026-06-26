from dataclasses import dataclass, field


@dataclass
class PlayerProfile:

    player_id: str
    display_name: str
    real_first_name: str | None = None
    nickname: str | None = None

    level: int = 1
    xp: int = 0
    coins: int = 1000

    favorite_host: str = "Grace Lott"
    favorite_table: str = "Grandma's Kitchen"
    favorite_mug: str | None = None
    favorite_phrase: str = "Bless your heart."
    favorite_gift: str = "Wine"

    games_played: int = 0
    games_won: int = 0
    wilds_discarded: int = 0
    gifts_sent: int = 0

    collections: dict = field(default_factory=dict)
    achievements: list = field(default_factory=list)

    def display_for_public_game(self):
        return self.display_name

    def display_for_family_club(self, naming_style):
        if naming_style == "real_first_name" and self.real_first_name:
            return self.real_first_name

        if naming_style == "nickname" and self.nickname:
            return self.nickname

        return self.display_name

    def add_collection_item(self, collection_name, item_id):
        if collection_name not in self.collections:
            self.collections[collection_name] = []

        if item_id not in self.collections[collection_name]:
            self.collections[collection_name].append(item_id)

    def has_collection_item(self, collection_name, item_id):
        return item_id in self.collections.get(collection_name, [])
