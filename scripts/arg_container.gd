extends Node2D
class_name ArgContainer

@export var connection_renderer: Node2D
@export var port: Control
@onready var nine_patch_rect: NinePatchRect = $ArgLabel/NinePatchRect

@export var arg:Arg:
	set(value):
		arg = value
		$ArgLabel.text = arg.preview_text
@export var connections:Array[Node2D]:
	set(value):
		connections = value
		_update_renderer()

var draggingOffset
var current_column = 0
var separation_speed = 5.0
var separation_force = Vector2.ZERO

const COLUMN_SIZE = 600

func calculate_column() -> int:
	return int(round(global_position.x / COLUMN_SIZE))

func get_bounds() -> Rect2:
	var np:NinePatchRect = $ArgLabel/NinePatchRect
	return Rect2(np.position + global_position, np.size)

func check_overlap(other: Node2D) -> float:
	var my_bounds = get_bounds()
	var other_bounds = other.get_bounds()
	
	if my_bounds.intersects(other_bounds):
		var top = max(my_bounds.position.y, other_bounds.position.y)
		var bottom = min(my_bounds.position.y + my_bounds.size.y, other_bounds.position.y + other_bounds.size.y)
		var y_overlap = bottom - top
		
		var direction = global_position.y - other.global_position.y
		return sign(direction) * y_overlap
	
	return 0.0

# Calculate the target column position
func calculate_column_target() -> float:
	var rem = int(round(global_position.x)) % COLUMN_SIZE
	return global_position.x + (COLUMN_SIZE - rem if rem > COLUMN_SIZE/2 else -rem)

# Handle column snapping
func snap_to_column() -> void:
	var target = calculate_column_target()
	DebugDraw2D.circle(Vector2(target,global_position.y))
	var frame_target = lerp(global_position.x, target, 0.1)
	DebugDraw2D.circle(Vector2(frame_target,global_position.y),10,16,Color.CORNFLOWER_BLUE)
	global_position.x = frame_target

# Handle mouse dragging
func handle_dragging() -> void:
	var mouse_pos = get_global_mouse_position()
	var drag_target = mouse_pos - draggingOffset
	
	# Calculate column target based on drag position
	var target = drag_target.x + (COLUMN_SIZE - int(round(drag_target.x)) % COLUMN_SIZE if int(round(drag_target.x)) % COLUMN_SIZE > COLUMN_SIZE/2 else -int(round(drag_target.x)) % COLUMN_SIZE)
	
	# Draw debug visuals
	DebugDraw2D.circle(Vector2(target,global_position.y))
	DebugDraw2D.arrow(mouse_pos, drag_target)
	
	# Calculate and apply pull target
	var pull_target = lerp(target, drag_target.x, 0.4)
	DebugDraw2D.circle(Vector2(pull_target,global_position.y),10,16,Color.BROWN)
	
	# Smoothly move to target
	var frame_target = lerp(global_position.x, pull_target, 0.2)
	DebugDraw2D.circle(Vector2(frame_target,global_position.y),10,16,Color.CORNFLOWER_BLUE)
	global_position = Vector2(frame_target, drag_target.y)

# Handle vertical separation from overlapping containers
func handle_vertical_separation(delta: float) -> void:
	var vertical_separation = 0.0
	var siblings = get_tree().get_nodes_in_group("arg_container")
	
	for sibling in siblings:
		if sibling == self:
			continue
			
		var other = sibling as Node2D
		if other and other.current_column == current_column:
			var overlap = check_overlap(other)
			if overlap != 0.0:
				vertical_separation += overlap
	
	if vertical_separation != 0.0:
		global_position.y += vertical_separation * separation_speed * delta

func _update_renderer():
	connection_renderer.update_connections(connections)

func _ready() -> void:
	_update_renderer()
	pass

func _process(delta: float) -> void:
	# Update column number
	current_column = calculate_column()
	
	# Handle vertical separation when not dragging
	if not draggingOffset:
		handle_vertical_separation(delta)
	# Handle column snapping or dragging
		snap_to_column()
	else:
		handle_dragging()
		
	connection_renderer.queue_redraw()

func _input(event: InputEvent) -> void:
	

	if draggingOffset and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		draggingOffset = null

func begin_drag():
	draggingOffset = get_global_mouse_position() - global_position
	DebugDraw2D.arrow(get_global_mouse_position(), global_position)

func _gui_input(event:InputEvent) -> void:
	if event is InputEventMouseButton and Input.is_action_just_pressed("drag") and not draggingOffset:
		event = event as InputEventMouseButton
		if event.position.x > 0.8 * $ArgLabel/NinePatchRect.size.x:
			#handle creation of new arg connected to this one
			var inst = preload("uid://bdphuxi8wp1pp").instantiate()
			inst.global_position = get_global_mouse_position()
			inst.arg = Arg.new("dragging arg test")
			add_sibling(inst)
			connections += [inst]
			inst.begin_drag()
		else:
			begin_drag()
	if event is InputEventMouseButton and event.double_click and event.button_index == 0:
		pass
