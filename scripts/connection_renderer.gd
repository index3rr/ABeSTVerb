extends Node2D
var connections: Array[Node2D]

func update_connections(remote_connections):
	connections = remote_connections

func _draw() -> void:
	for connection in connections:
		var target = connection as ArgContainer
		if not target:
			continue
		#DebugDraw2D.arrow(global_position, target.global_position,)
		draw_line(Vector2(0,0), target.global_position-global_position + target.port.get_parent().position + target.port.position, Color.WHITE, 2)
		
	pass
