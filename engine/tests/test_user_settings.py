from engine.settings.user_settings import UserSettings
from engine.settings.settings_serializer import SettingsSerializer


settings = UserSettings()

assert settings.animation_speed == "standard"
assert settings.music_enabled is False
assert settings.family_friendly_mode is True

settings.set_animation_speed("lightning")
settings.set_card_sort_preference("meld")

assert settings.animation_speed == "lightning"
assert settings.card_sort_preference == "meld"

serialized = SettingsSerializer.serialize(settings)

assert serialized["animation_speed"] == "lightning"
assert serialized["card_sort_preference"] == "meld"

print("User settings test passed.")
