from engine.table.dealer import Dealer
from engine.table.dealer_rotation import DealerRotation


grace = Dealer(
    name="Grace Lott",
    host_id="grace_lott",
)

jack = Dealer(
    name="Jack",
    host_id="jack",
)

rotation = DealerRotation([grace, jack])

assert rotation.current_dealer.name == "Grace Lott"

rotation.rotate()

assert rotation.current_dealer.name == "Jack"

rotation.rotate()

assert rotation.current_dealer.name == "Grace Lott"

print("Dealer rotation test passed.")
