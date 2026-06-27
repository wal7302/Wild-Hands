class SettingsSerializer:

    @staticmethod
    def serialize(settings):
        return {
            "animation_speed": settings.animation_speed,
            "sound_enabled": settings.sound_enabled,
            "music_enabled": settings.music_enabled,
            "haptics_enabled": settings.haptics_enabled,
            "card_sort_preference": settings.card_sort_preference,
            "large_cards": settings.large_cards,
            "high_contrast_cards": settings.high_contrast_cards,
            "reduce_motion": settings.reduce_motion,
            "captions_enabled": settings.captions_enabled,
            "table_talk_enabled": settings.table_talk_enabled,
            "gifts_enabled": settings.gifts_enabled,
            "family_friendly_mode": settings.family_friendly_mode,
        }
