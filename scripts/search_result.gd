extends HBoxContainer
class_name SearchResult

@export var arg:Arg:
	get:
		return _get_arg()
	set(value):
		_set_arg(value)
#export some sort of file location thingy??
func _set_arg(value):
	arg = value
func _get_arg():
	return arg
func _ready():
	pass
