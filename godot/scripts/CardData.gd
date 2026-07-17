class_name CardData
extends RefCounted

var id := ""
var rank := ""
var rank_value := 0
var suit := ""
var suit_code := ""
var is_wild := false

func _init(
	new_id: String = "",
	new_rank: String = "",
	new_rank_value: int = 0,
	new_suit: String = "",
	new_suit_code: String = ""
):
	id = new_id
	rank = new_rank
	rank_value = new_rank_value
	suit = new_suit
	suit_code = new_suit_code

func set_wild_rank(wild_rank: int):
	is_wild = rank_value == wild_rank

func to_dictionary() -> Dictionary:
	return {
		"id": id,
		"rank": rank,
		"rank_value": rank_value,
		"suit": suit,
		"suit_code": suit_code,
		"wild": is_wild
	}