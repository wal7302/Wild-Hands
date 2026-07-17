class_name GameConfig
extends RefCounted

enum GameMode {
	LIGHTNING,
	HALF_LOW,
	HALF_HIGH,
	FULL
}

static func mode_from_key(game_type: String) -> GameMode:
	match game_type:
		"lightning":
			return GameMode.LIGHTNING
		"half_low":
			return GameMode.HALF_LOW
		"half_high":
			return GameMode.HALF_HIGH
		"full":
			return GameMode.FULL
		_:
			return GameMode.FULL

static func mode_display_name(mode: GameMode) -> String:
	match mode:
		GameMode.LIGHTNING:
			return "Lightning"
		GameMode.HALF_LOW:
			return "Half Game — Low"
		GameMode.HALF_HIGH:
			return "Half Game — High"
		GameMode.FULL:
			return "Full Game"

	return "Full Game"

static func total_rounds(mode: GameMode) -> int:
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

static func hand_value_for_round(
	mode: GameMode,
	round_number: int,
	rng: RandomNumberGenerator
) -> int:
	match mode:
		GameMode.LIGHTNING:
			return rng.randi_range(3, 13)

		GameMode.HALF_LOW:
			return clampi(2 + round_number, 3, 7)

		GameMode.HALF_HIGH:
			return clampi(8 + round_number, 9, 13)

		GameMode.FULL:
			return clampi(2 + round_number, 3, 13)

	return 3

static func rank_label(rank_value: int) -> String:
	match rank_value:
		1:
			return "A"
		11:
			return "J"
		12:
			return "Q"
		13:
			return "K"
		_:
			return str(rank_value)

static func wild_display_name(rank_value: int) -> String:
	var label: String = rank_label(rank_value)

	if rank_value == 6:
		return "6s"

	if rank_value in [11, 12, 13]:
		return label + "s"

	return label + "s"