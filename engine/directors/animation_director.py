from engine.directors.director_event import DirectorEvent


class AnimationDirector:

    def deal_card(self, card_id, from_area, to_player, delay=0.0):
        return DirectorEvent(
            event_type="animation.deal_card",
            source="animation_director",
            message=f"Deal {card_id} to {to_player}",
            payload={
                "card_id": card_id,
                "from": from_area,
                "to_player": to_player,
                "delay": delay,
                "duration": 0.45,
                "easing": "spring",
            },
        )

    def discard_card(self, card_id, from_player, to_area="discard_pile"):
        return DirectorEvent(
            event_type="animation.discard_card",
            source="animation_director",
            message=f"{from_player} discards {card_id}",
            payload={
                "card_id": card_id,
                "from_player": from_player,
                "to": to_area,
                "duration": 0.35,
                "hand_reaches": True,
            },
        )
