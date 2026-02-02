extends Node

enum BranchID {
	NULL = 0,
	INTRO = 1,
	GOOD = 2,
	MEH = 3,
	BAD = 4,
	CARD_GOOD = 5,
	CARD_SUS = 6,
	CARD_EARLY_SKIP_GOOD = 7,
	CARD_EARLY_SKIP_BAD = 8,
	STONEWALL = 9,
	ELLIPSES_CARD = 10,
	MENTION_CARD = 11,
	FACE = 13,
	FACE_LOOP = 14,
	NEVERMIND_END = 15,
	NEVERMIND_END_2 = 16,
	ELLIPSES_SWIPE = 18,
	MENTION_SWIPE = 19,
}

enum EndsPossible {
	DOES_NOT_END,
	STATIC_END,
	PUNCH_END,
}

func get_branch(id: BranchID) -> DialogueBranch:
	print(str("res://resource/branch", id))
	var new_instance = load(str("res://resource/branch", id,".tres")) as DialogueBranch
	return new_instance
