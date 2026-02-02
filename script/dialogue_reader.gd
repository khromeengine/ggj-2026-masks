extends Node
class_name DialogueReader

enum Reading {
	NEITHER,
	BRANCH,
	NODE,
}

signal ending_reached(ending: BranchLoader.EndsPossible)

@export var text_medium: Label
@export var char_timer: Timer
@export var button_container: VBoxContainer
@export var button_array: Array[BranchButton]


var active_branch: DialogueBranch
var active_node: DialogueNode


var reading: Reading

var char_period: float = 0
var _num_char: int = 0
var next_node_override: DialogueNode


func _ready():
	button_container.visible = false
	char_timer.one_shot = false
	char_timer.autostart = false
	char_timer.timeout.connect(_on_char_timeout)
	for button in button_array:
		button.branch_button_pressed.connect(_on_button_pressed)


func read_branch(id: BranchLoader.BranchID):
	next_node_override = null
	reading = Reading.BRANCH
	button_container.visible = false
	active_branch = BranchLoader.get_branch(id)
	if !active_branch:
		ending_reached.emit(BranchLoader.EndsPossible.STATIC_END)
		return
	char_timer.start(active_branch.branch_text_period)
	_num_char = active_branch.initial_char_count
	text_medium.text = active_branch.branch_text
	text_medium.visible_characters = _num_char
	
	for dbutton in button_array:
		dbutton.visible = false

	if len(active_branch.no_skip_nodes) == 1 and !active_branch.no_skip_nodes.front().prompts_choice_if_singular:
		next_node_override = active_branch.no_skip_nodes.front()
	else:
		next_node_override = null
		for i in len(active_branch.no_skip_nodes):
			button_array[i].obtain_node(active_branch.no_skip_nodes[i])


func read_node(node: DialogueNode):
	reading = Reading.NODE
	button_container.visible = false
	active_node = node
	char_timer.start(active_node.node_text_period)
	_num_char = active_node.initial_char_count
	text_medium.text = active_node.node_text
	text_medium.visible_characters = _num_char


func handle_input():
	match(reading):
		Reading.NEITHER:
			pass
		Reading.BRANCH:
			if _num_char > active_branch.branch_text.length():
				if !next_node_override:
					reading = Reading.NEITHER
					button_container.visible = true
					active_branch = null
				else:
					read_node(next_node_override)
			else:
				print(_num_char)
				print(active_branch.initial_char_count + active_branch.early_skip_char_threshold)
				if !active_branch.branch_text_unskippable:
					if (active_branch.early_skip_node and
						_num_char < active_branch.initial_char_count + active_branch.early_skip_char_threshold):
						read_node(active_branch.early_skip_node)
					else:
						read_node(active_branch.late_skip_node)
		Reading.NODE:
			if _num_char > active_node.node_text.length():
				read_branch(active_node.next_branch)
			elif !active_node.unskippable:
				_num_char = active_node.node_text.length()
				text_medium.visible_characters = active_node.node_text.length()
		_:
			push_error("whatfg")


func _on_char_timeout():
	_num_char += 1
	text_medium.visible_characters = _num_char
	if reading == Reading.BRANCH and _num_char > active_branch.branch_text.length() + 3:
		if active_branch.does_end != BranchLoader.EndsPossible.DOES_NOT_END:
			ending_reached.emit(active_branch.does_end)
		else:
			reading = Reading.NEITHER
			button_container.visible = true
			active_branch = null
	elif reading == Reading.NODE and _num_char > active_node.node_text.length() + 3:
		if active_node.does_end != BranchLoader.EndsPossible.DOES_NOT_END:
			ending_reached.emit(active_node.does_end)
			
func _on_button_pressed(node: DialogueNode):
	read_node(node)
