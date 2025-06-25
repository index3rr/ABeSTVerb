extends SearchResult
@onready var text_edit: TextEdit = $TextEdit

func get_arg():
	return Arg.new(text_edit.text)
