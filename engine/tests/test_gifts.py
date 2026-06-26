from engine.models.player import Player
from engine.social.gift_service import GiftService


sender = Player("Tasha")
receiver = Player("Grace")

starting_coins = sender.coins

result = GiftService.send_gift(
    sender,
    receiver,
    "wine"
)

assert result.success is True
assert sender.coins == starting_coins - 25
assert result.gift.name == "Wine"

print("Gift test passed.")
