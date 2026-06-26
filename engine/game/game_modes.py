class GameMode:

    QUICK = "quick"
    CLASSIC = "classic"


class GameModeConfig:

    @staticmethod
    def rounds_for(mode, starting_round=3):

        if mode == GameMode.CLASSIC:
            return list(range(3, 14))

        if mode == GameMode.QUICK:
            return [
                starting_round,
                starting_round + 1,
                starting_round + 2,
            ]

        raise ValueError(f"Unknown game mode: {mode}")
