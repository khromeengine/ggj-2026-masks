extends Resource
class_name DialogueBranch

@export var branch_text: String
@export var branch_text_period: float = 0.1
@export var branch_text_unskippable: bool = false
@export var initial_char_count: int = 5
@export var early_skip_char_threshold: int = 0
@export var early_skip_node: DialogueNode = null
@export var late_skip_node: DialogueNode = null
@export var no_skip_nodes: Array[DialogueNode]
@export var does_end: BranchLoader.EndsPossible = BranchLoader.EndsPossible.DOES_NOT_END
