from collections import Counter

from engine.game.events import GameEventType


class MatchHighlights:

    @staticmethod
    def from_match(match):

        highlights = []
        seen = set()

        for round_record in match.rounds:

            round_number = round_record.get("round")
            events = round_record.get("events", [])

            for event in events:

                key = (
                    round_number,
                    event.event_type,
                    event.player_name,
                    event.message,
                )

                if key in seen:
                    continue

                seen.add(key)

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

        seen = set()
        count = 0

        for round_record in match.rounds:

            round_number = round_record.get("round")
            events = round_record.get("events", [])

            for event in events:
                key = (
                    round_number,
                    event.event_type,
                    event.player_name,
                    event.message,
                )

                if event.event_type == GameEventType.WILD_DISCARDED and key not in seen:
                    seen.add(key)
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
