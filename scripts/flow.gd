extends Node2D

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("new_arg"):
		var inst = preload("uid://bdphuxi8wp1pp").instantiate()
		inst.global_position = get_global_mouse_position()
		add_child(inst)
