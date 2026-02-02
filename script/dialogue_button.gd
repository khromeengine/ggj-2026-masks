extends Button
class_name BranchButton

signal branch_button_pressed(node: DialogueNode)

@export var contained_node: DialogueNode


func _ready():
	pressed.connect(_on_pressed)


func obtain_node(node: DialogueNode):
	text = node.choice_text
	contained_node = node
	visible = true


func _on_pressed():
	branch_button_pressed.emit(contained_node)
