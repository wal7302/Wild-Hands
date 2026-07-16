class_name GameConfig

enum GameMode
{
	LIGHTNING,
	HALF_LOW,
	HALF_HIGH,
	FULL
}

static func first_hand(mode: GameMode) -> int:

	match mode:

		GameMode.LIGHTNING:
			return randi_range(3,13)

		GameMode.HALF_LOW:
			return 3

		GameMode.HALF_HIGH:
			return 9

		GameMode.FULL:
			return 3

	return 3


static func next_hand(
	mode: GameMode,
	current:int
)->int:

	match mode:

		GameMode.LIGHTNING:
			return randi_range(3,13)

		GameMode.HALF_LOW:

			if current>=7:
				return -1

			return current+1

		GameMode.HALF_HIGH:

			if current>=13:
				return -1

			return current+1

		GameMode.FULL:

			if current>=13:
				return -1

			return current+1

	return -1


static func total_rounds(mode:GameMode)->int:

	match mode:

		GameMode.LIGHTNING:
			return 3

		GameMode.HALF_LOW:
			return 5

		GameMode.HALF_HIGH:
			return 5

		GameMode.FULL:
			return 11

	return 0