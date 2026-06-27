from engine.game.match_highlights import MatchHighlights


class MatchSummary:

    @staticmethod
    def build(game):

        results = game.match_results()
        highlights = MatchHighlights.from_match(game.match)

        return {
            "winner": game.winner().name,
            "results": results,
            "highlights": highlights,
            "wild_toss_count": MatchHighlights.wild_toss_count(game.match),
            "most_common_highlight": MatchHighlights.most_common_highlight_type(
                highlights
            ),
        }
