class PlayerSerializer:

    @staticmethod
    def serialize(player):

        return {

            "name": player.name,

            "coins": player.coins,

            "xp": player.xp,

            "total_score": player.total_score,

            "hand": [

                {

                    "rank": card.rank,

                    "suit": card.suit.name,

                    "is_wild": card.is_wild

                }

                for card in player.hand

            ]
        }
