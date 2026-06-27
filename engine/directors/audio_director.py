from engine.directors.director_event import DirectorEvent


class AudioDirector:

    def play(self, sound_key, volume=1.0):
        return DirectorEvent(
            event_type="audio.play",
            source="audio_director",
            message=f"Play sound {sound_key}",
            payload={
                "sound_key": sound_key,
                "volume": volume,
            },
        )
