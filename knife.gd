extends Area2D

signal stuck
signal hit_other

var spd = 800.0 * 6 * 2
var going = false
var log_node


var rad = 195.0


@onready var body = $body

func _ready():
	body.area_entered.connect(on_body_hit)
	spawn_anim()

func spawn_anim():
	scale = Vector2(1, 0)
	modulate = Color(2.5, 2.5, 2.5, 1)
	var t = create_tween()
	t.tween_property(self, "scale", Vector2(1, 1), 0.2) \
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	t.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.1)

func _unhandled_input(ev):
	if going:
		return
	if ev.is_action_pressed("ui_accept"): going = true
	if ev is InputEventMouseButton and ev.pressed: going = true
	if ev is InputEventScreenTouch and ev.pressed: going = true

func _process(delta):
	if not going:
		return
	position.y -= spd * delta
	if overlaps_area(log_node):
		
		var to_center = log_node.global_position - global_position
		var ang = rad_to_deg(to_center.angle())
		
		if ang < -45 and ang > -135.6:
			stick()

func stick():
	going = false
	set_process(false)
	set_process_unhandled_input(false)

	var loc = log_node.to_local(global_position)
	var snapped = loc.normalized() * rad

	reparent(log_node, false)
	position = snapped
	scale = Vector2(1, 1)
	z_index = -1

	log_node.on_hit()
	stuck.emit()

func on_body_hit(area):
	
	if not going:
		return
	
	if area.get_parent() == log_node or area == log_node:
		return  
	
	going = false
	set_process(false)
	set_process_unhandled_input(false)
	hit_other.emit()
