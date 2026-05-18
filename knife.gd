extends Area2D

signal stuck

signal hit_other
signal fired


var spd = 800.0 * 6 * 2* 1.6

var going = false
var log_node
var rad = 210.0
var ready_to_fire_ref = null

var bouncing = false
var vel = Vector2.ZERO
var spin = 0.0


var pull = 300 *3
var damping = 0.97





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
	if going or bouncing:
		
		
		
		return
	if ready_to_fire_ref != null and not ready_to_fire_ref.call():
		return
	var tapped = false
	if ev.is_action_pressed("ui_accept"): tapped = true
	if ev is InputEventMouseButton and ev.pressed: tapped = true
	
	if ev is InputEventScreenTouch and ev.pressed: tapped = true
	if tapped:
		
		going = true
		fired.emit()

func _process(delta):
	if going:
		position.y -= spd * delta
		
		
		if overlaps_area(log_node):
			
			
			var to_center = log_node.global_position - global_position
			var ang = rad_to_deg(to_center.angle())
			if ang < -45 and ang > -135:
				
				
				stick()
				
				
		return

	if bouncing:
		vel.y += pull * delta
		
		
		vel *= pow(damping, delta)
		
		
		
		spin *= pow(0.93, delta)
		
		
		
		
		
		position += vel * delta
		
		
		rotation += spin * delta

func stick():
	going = false
	set_process_unhandled_input(false)
	
	
	set_process(false)


	var gtip = global_position
	reparent(log_node, true)
	var loc = log_node.to_local(gtip)
	
	
	
	position = loc.normalized() * rad
	
	scale = Vector2(1, 1)
	z_index = -1

	log_node.on_hit()
	stuck.emit()

func on_body_hit(area):
	if not going:
		return

	# apple hit — cut it!
	if area.is_in_group("apple"):
		area.get_parent().cut(log_node)
		
		return
		

	if area == log_node or area.get_parent() == log_node:
		return

	going = false
	set_process_unhandled_input(false)

	var hit = area.get_parent()
	
	var norm = (global_position - hit.global_position).normalized()
	var incoming = Vector2(0, -spd)
	var reflected = incoming - 2.0 * incoming.dot(norm) * norm
	
	var impact = clamp(abs(incoming.normalized().dot(norm)), 0.0, 1.0)


	var bounce_str = lerp(0.08, 0.18, impact)
	
	vel = reflected * bounce_str
	if vel.y < 0:
		vel.y = abs(vel.y) * 0.5

	var side = sign(global_position.x - hit.global_position.x)
	if side == 0: side = 1
	vel.x += side * lerp(60.0, 160.0, impact)
	
	spin = -side * lerp(1.5, 4.0, impact)
	bouncing = true

	if hit.has_method("wobble"):
		
		hit.wobble()

	await get_tree().create_timer(3.0).timeout
	if is_instance_valid(self):
		_finish_bounce()

func wobble():
	var orig = rotation
	
	var t = create_tween()
	t.tween_property(self, "rotation", orig + deg_to_r
	ad(randf_range(-8, 8)), 0.06) \
		.set_trans(Tween.TRANS_SINE)
	t.tween_property(self, "rotation", orig, 0.3) \
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		

func _finish_bounce():
	
	hit_other.emit()
	queue_free()
