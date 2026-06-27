from engine.directors.director_event import DirectorEvent
from engine.directors.animation_director import AnimationDirector
from engine.directors.audio_director import AudioDirector


class DealerDirector:

    def __init__(self):
        self.animation = AnimationDirector()
        self.audio = AudioDirector()

    def start_round(self, players, hand_size, wild_rank):
        events = []

        events.append(
            DirectorEvent(
                event_type="dealer.round_start",
                source="dealer_director",
                message=f"Round starts. {wild_rank}s are wild.",
                payload={
                    "hand_size": hand_size,
                    "wild_rank": wild_rank,
                },
            )
        )

        events.append(self.audio.play("shuffle_cards"))

        delay = 0.0

        for card_number in range(hand_size):
            for player in players:
                card_id = f"card_{card_number + 1}_{player.name}"
                events.append(
                    self.animation.deal_card(
                        card_id=card_id,
                        from_area="deck",
                        to_player=player.name,
                        delay=delay,
                    )
                )
                events.append(self.audio.play("card_deal", volume=0.7))
                delay += 0.18

        events.append(
            DirectorEvent(
                event_type="dealer.wild_reveal",
                source="dealer_director",
                message=f"{wild_rank}s are wild tonight.",
                payload={
                    "wild_rank": wild_rank,
                    "animation": "wild_card_glow",
                },
            )
        )

        return events
