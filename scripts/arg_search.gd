extends Panel

@onready var insert_button: Button = %InsertButton

func _insert_button_pressed() -> void:
	var inst = preload("uid://bdphuxi8wp1pp").instantiate()
	inst.global_position = get_global_mouse_position()
	inst.arg = (insert_button.get_parent() as SearchResult).arg
	add_sibling(inst)
