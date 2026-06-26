from engine.social.gifts import GiftLibrary


class GiftResult:

    def __init__(self, success, message, gift=None):

        self.success = success
        self.message = message
        self.gift = gift


class GiftService:

    @staticmethod
    def send_gift(sender, receiver, gift_id):

        gift = GiftLibrary.find(gift_id)

        if gift is None:

            return GiftResult(
                False,
                f"Gift '{gift_id}' does not exist."
            )

        if sender.coins < gift.coin_cost:

            return GiftResult(
                False,
                f"{sender.name} does not have enough coins."
            )

        sender.coins -= gift.coin_cost

        return GiftResult(
            True,
            f"{sender.name} sent {receiver.name} {gift.name}.",
            gift
        )
