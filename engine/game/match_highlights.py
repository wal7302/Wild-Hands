from collections import Counter

from engine.game.events import GameEventType


class MatchHighlights:

    @staticmethod
    def from_match(match):

        highlights = []

        for round_record in match.rounds:

            round_number = round_record.get("round")
            events = round_record.get("events", [])

            for event in events:

                if event.event_type == GameEventType.WILD_DISCARDED:
                    highlights.append(
                        {
                            "type": "wild_toss",
                            "title": "Wild Toss!",
                            "description": event.message,
                            "round": round_number,
                        }
                    )

                if event.event_type == GameEventType.PLAYER_WENT_OUT:
                    highlights.append(
                        {
                            "type": "player_went_out",
                            "title": "Clean Finish",
                            "description": event.message,
                            "round": round_number,
                        }
                    )

        return highlights

    @staticmethod
    def wild_toss_count(match):

        count = 0

        for round_record in match.rounds:

            events = round_record.get("events", [])

            for event in events:
                if event.event_type == GameEventType.WILD_DISCARDED:
                    count += 1

        return count

    @staticmethod
    def most_common_highlight_type(highlights):

        if not highlights:
            return None

        counter = Counter(
            highlight["type"]
            for highlight in highlights
        )

        return counter.most_common(1)[0][0]
