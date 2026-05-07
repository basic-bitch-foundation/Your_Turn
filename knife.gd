extends Area2D

signal stuck

var speed = 800.0
var flying= false
var wheel_node: Area2D

@onready var sprite = $Sprite2D

func _ready():
	_play_spawn_anim()

func _play_spawn_anim():
	
	modulate = Color(2, 2, 2, 0)
	var origin = position
	position += Vector2(0, 30)

	var t = create_tween()
	t.set_parallel(true)
	
	t.tween_property(self, "position", origin, 0.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	t.tween_property(self, "modulate", Color(2, 2, 2, 1), 0.08)
	t.chain().tween_property(self, "modulate", Color(1, 1, 1, 1), 0.15)

func _unhandled_input(event: InputEvent):
	if flying:
		return
	if event.is_action_pressed("ui_accept"):
		flying = true
	if event is InputEventMouseButton and event.pressed:
		flying = true
	if event is InputEventScreenTouch and event.pressed:
		flying = true

func _process(delta):
	if not flying:
		return
	position.y -= speed * delta
	if overlaps_area(wheel_node):
		_stick()

func _stick():
	flying = false
	set_process(false)
	set_process_unhandled_input(false)
	reparent(wheel_node, true)
	position = position.move_toward(Vector2.ZERO, 40.0)
	z_index = -1
	wheel_node.knife_hit()
	stuck.emit()
