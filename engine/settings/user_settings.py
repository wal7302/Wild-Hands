from dataclasses import dataclass


@dataclass
class UserSettings:

    animation_speed: str = "standard"
    sound_enabled: bool = True
    music_enabled: bool = False
    haptics_enabled: bool = True

    card_sort_preference: str = "manual"

    large_cards: bool = False
    high_contrast_cards: bool = False
    reduce_motion: bool = False
    captions_enabled: bool = True

    table_talk_enabled: bool = True
    gifts_enabled: bool = True
    family_friendly_mode: bool = True

    def set_animation_speed(self, speed):
        allowed = ["relaxed", "standard", "lightning"]

        if speed not in allowed:
            raise ValueError(f"Animation speed must be one of {allowed}")

        self.animation_speed = speed

    def set_card_sort_preference(self, preference):
        allowed = ["manual", "rank", "suit", "meld"]

        if preference not in allowed:
            raise ValueError(f"Card sort preference must be one of {allowed}")

        self.card_sort_preference = preference
