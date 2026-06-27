from engine.persistence.player_serializer import PlayerSerializer


class GameSerializer:

    @staticmethod
    def serialize(game):

        return {

            "round": game.round_number,

            "mode": game.mode,

            "players": [

                PlayerSerializer.serialize(player)

                for player in game.players

            ]
        }
