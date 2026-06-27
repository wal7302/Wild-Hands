from engine.models.player import Player
from engine.game.match import Match
from engine.game.events import EventLog, GameEventType
from engine.game.match_highlights import MatchHighlights


player = Player("Tasha")

match = Match([player])

event_log = EventLog()

event_log.add(
    GameEventType.WILD_DISCARDED,
    player_name="Tasha",
    message="Tasha discarded a wild!"
)

match.add_round(
    3,
    {"Tasha": 10},
    events=event_log.events,
)

highlights = MatchHighlights.from_match(match)

assert len(highlights) == 1
assert highlights[0]["title"] == "Wild Toss!"
assert MatchHighlights.wild_toss_count(match) == 1

print("Match highlights test passed.")
