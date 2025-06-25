extends Panel

@onready var insert_button: Button = %InsertButton

func _insert_button_pressed() -> void:
	var inst = preload("uid://bdphuxi8wp1pp").instantiate()
	inst.global_position = get_global_mouse_position()
	var parent = insert_button.get_parent()
	inst.arg = parent.get_arg()
	add_sibling(inst)
