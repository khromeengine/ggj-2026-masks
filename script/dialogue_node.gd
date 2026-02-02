extends Resource
class_name DialogueNode

@export var prompts_choice_if_singular: bool
@export var choice_text: String
@export var node_text: String
@export var node_text_period: float = 0.04
@export var initial_char_count: int = 5
@export var unskippable: bool = true
@export var next_branch: BranchLoader.BranchID
@export var does_end: BranchLoader.EndsPossible = BranchLoader.EndsPossible.DOES_NOT_END
