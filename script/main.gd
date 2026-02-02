extends Control

@export var anim: AnimationPlayer
@export var effects: AnimationPlayer
@export var reader: DialogueReader

func _ready() -> void:
	anim.play("idle")
	reader.read_branch(1)
	reader.ending_reached.connect(process_ending)


func _process(_delta: float):
	if effects.is_playing():
		return
	if Input.is_action_just_pressed("act"):
		reader.handle_input()


func process_ending(ending: BranchLoader.EndsPossible):
	effects.play("static")
	reader.read_branch(1)
