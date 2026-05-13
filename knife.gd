extends Area2D

signal stuck

signal hit_other

var  spd =  800.0 * 6 * 2
var going =  false
var log_node

var rad = 210.0

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
		if ang < -45 and ang > -135:
			stick()

func stick():
	going = false
	set_process(false)
	set_process_unhandled_input(false)

	
	
	var  global_tip = global_position
	
	
	reparent(log_node, true)
	
	
	var  loc = log_node.to_local(global_tip)
	position = loc.normalized() * rad
	scale = Vector2(1, 1)
	z_index = -1

	log_node.on_hit()
	stuck.emit()

func on_body_hit(area):
	if not going:
		return
	
	
	
	if area == log_node or area.get_parent() == log_node:
		return
	going = false
	set_process(false)
	set_process_unhandled_input(false)

	var hit_knife = area.get_parent()
	
	
	
	var side = sign(global_position.x - hit_knife.global_position.x)
	
	clash_bounce(side)

func clash_bounce(side):
	var spin = side
	var start_rot = rotation
	
	
	
	var start_pos = position

	var t = create_tween()
	t.set_parallel(false)

	# phase 1 — initial hit impact, spin hard in clash dir
	t.tween_property(self, "rotation", start_rot + deg_to_rad(spin * 8*10), 0.1) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	t.parallel().tween_property(self, "position", start_pos + Vector2(spin * 25, 50), 0.1) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	t.tween_property(self, "rotation", start_rot + deg_to_rad(spin * 280), 0.25) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	t.parallel().tween_property(self, "position", start_pos + Vector2(spin * 6*10, 180), 0.25) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	
	t.tween_property(self, "rotation", start_rot + deg_to_rad(spin * 560), 0.3) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	
	t.parallel().tween_property(self, "position", start_pos + Vector2(spin * 100, 420), 0.3) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	
	t.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.1)

	
	t.tween_callback(func():
		hit_other.emit()
		queue_free()
	)
