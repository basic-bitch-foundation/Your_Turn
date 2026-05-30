extends Area2D

signal stuck

signal hit_other

signal fired

signal apple_hit


signal missed

var spd     = 800.0 * 6 * 2 * 1.6

var going   = false

var log_node

var rad     = 210.0

var ready_to_fire_ref = null

var bouncing      = false
var vel           = Vector2.ZERO

var spin          = 0.0

var pull          = 900.0
var damping       = 0.97

var hit_something = false

const log_r   = 210.0
const miss_y  = -200.0




const apl_arc = 0.25

const knf_arc = 0.15


@onready var body = $body

func _ready():
	spawn_anim()

func spawn_anim():
	scale    = Vector2(1, 0)
	
	modulate = Color(2.5, 2.5, 2.5, 1)
	var t = create_tween()
	t.tween_property(self, "scale",    Vector2(1, 1),     0.2) \
	
	
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		
	t.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.1)
	

func _unhandled_input(ev):
	
	if going or bouncing:
		
		return
	if ready_to_fire_ref != null and not ready_to_fire_ref.call():
		
		return
	var tapped = false
	
	if ev.is_action_pressed("ui_accept"):            tapped = true
	if ev is InputEventMouseButton and ev.pressed:   tapped = true
	
	if ev is InputEventScreenTouch   and ev.pressed: tapped = true
	if tapped:
		going = true
		fired.emit()
		

func _process(delta):
	if going:
		global_position.y -= spd * delta


		
		var dist = global_position.distance_to(log_node.global_position)
		
		if dist <= log_r:
			arrive_at_log()
			
			return

		# flew past everything
		if global_position.y < miss_y:
			going = false
			
			set_process(false)
			
			set_process_unhandled_input(false)
			
			missed.emit()
		return

	if bouncing:
		vel.y    += pull * delta
		vel      *= pow(damping, delta)
		
		spin     *= pow(0.93, delta)
		
		
		position += vel * delta
		rotation += spin * delta
		


func arrive_at_log():
	
	var from_ctr = global_position - log_node.global_position
	
	
	if from_ctr.length() < 0.001:
		
		from_ctr = Vector2.DOWN
	var cdir = from_ctr.normalized()
	
	global_position = log_node.global_position + cdir * log_r

	
	var cang = cdir.angle()

	
	for ch in log_node.get_children():
		if ch == self:
			continue
			
		if ch.is_in_group("apple"):
			
			continue
		if not ch.has_method("wobble"):
			continue
		
		var kdir = (ch.global_position - log_node.global_position).normalized()
		
		
		var diff = wrapf(cang - kdir.angle(), -PI, PI)
		if abs(diff) < knf_arc:
			
			do_clash(ch)
			return

	
	for ch in log_node.get_children():
		if not ch.is_in_group("apple"):
			
			
			continue
		if not ch.visible:
			
			continue
			
		if ch.been_cut:
			continue
		var adir = (ch.global_position - log_node.global_position).normalized()
		var diff = wrapf(cang - adir.angle(), -PI, PI)
		
		if abs(diff) < apl_arc:
			
			
			ch.do_cut(log_node)
			hit_something = true
			
			apple_hit.emit()
			break   
			
			


	
	hit_something = true
	
	stick()


func stick():
	going = false
	set_process_unhandled_input(false)
	set_process(false)
	
	var gtip = global_position
	
	reparent(log_node, true)
	
	var loc  = log_node.to_local(gtip)
	
	position = loc.normalized() * rad
	scale    = Vector2(1, 1)
	
	z_index  = -1
	log_node.on_hit()
	stuck.emit()

func do_clash(other):
	going = false
	set_process_unhandled_input(false)
	hit_something = true

	var norm = (global_position - other.global_position).normalized()
	if norm.length() < 0.001:
		norm = Vector2.UP

	var incoming  = Vector2(0, -spd)
	var reflected = incoming - 2.0 * incoming.dot(norm) * norm
	
	var impact    = clamp(abs(incoming.normalized().dot(norm)), 0.0, 1.0)
	

	var bstr = lerp(0.08, 0.18, impact)
	
	vel = reflected * bstr
	if vel.y < 0:
		
		vel.y = abs(vel.y) * 0.5

	var side = sign(global_position.x - other.global_position.x)
	
	if side == 0:
		side = 1
		
	vel.x   += side * lerp(60.0, 160.0, impact)
	
	spin     = -side * lerp(1.5, 4.0, impact)
	
	bouncing = true

	hit_other.emit()


	if other.has_method("wobble"):
		
		other.wobble()


	await get_tree().create_timer(3.0).timeout
	
	if is_instance_valid(self):
		queue_free()

func wobble():
	var orig = rotation
	var t = create_tween()
	
	t.tween_property(self, "rotation", orig + deg_to_rad(randf_range(-8, 8)), 0.06) \
	
		.set_trans(Tween.TRANS_SINE)
	t.tween_property(self, "rotation", orig, 0.3) \
	
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		
