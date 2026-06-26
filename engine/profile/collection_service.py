from engine.profile.collections import CollectionLibrary


class CollectionPurchaseResult:

    def __init__(self, success, message, item=None):
        self.success = success
        self.message = message
        self.item = item


class CollectionService:

    @staticmethod
    def purchase_item(profile, item_id):
        item = CollectionLibrary.find(item_id)

        if item is None:
            return CollectionPurchaseResult(
                False,
                f"Collection item '{item_id}' does not exist."
            )

        if profile.level < item.unlock_level:
            return CollectionPurchaseResult(
                False,
                f"{item.name} unlocks at level {item.unlock_level}."
            )

        if profile.coins < item.coin_cost:
            return CollectionPurchaseResult(
                False,
                f"Not enough coins to purchase {item.name}."
            )

        if profile.has_collection_item(item.collection_type, item.item_id):
            return CollectionPurchaseResult(
                False,
                f"{profile.display_name} already owns {item.name}."
            )

        profile.coins -= item.coin_cost
        profile.add_collection_item(item.collection_type, item.item_id)

        return CollectionPurchaseResult(
            True,
            f"{profile.display_name} purchased {item.name}.",
            item
        )
