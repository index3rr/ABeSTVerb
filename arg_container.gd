@tool
extends Node2D

@export var arg:Arg

var dragging = false

func _ready() -> void:
	$ArgLabel.text = arg.preview_text
	
func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion and dragging and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		event = event as InputEventMouseMotion
		global_position += event.relative
	if dragging and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragging = false
func _gui_input(event:InputEvent) -> void:
	print(event.get_class())
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragging = true
	if event is InputEventMouseButton and event.double_click and event.button_index == 0:
		pass
	pass # Replace with function body.
