from engine.experience.house_builder import HouseBuilder


house = HouseBuilder.default_friday_night()

assert house.name == "Grace's House"
assert house.cookie_of_the_day == "Chocolate Chip Cookies"
assert "The porch light is on." in house.sensory_details()

rainy = HouseBuilder.rainy_evening()

assert rainy.weather == "rain"
assert rainy.music == "Soft jazz"

print("House state test passed.")
