extends Area2D

@onready var full   = $full
@onready var half_l = $half_l
@onready var half_r = $half_r


var been_cut = false

var l_wpos = Vector2.ZERO
var r_wpos = Vector2.ZERO
var l_vel  = Vector2.ZERO

var r_vel  = Vector2.ZERO

var l_spin = 0.0

var r_spin = 0.0
var l_rot  = 0.0

var r_rot  = 0.0

var pull   = 1900.0

var flying = false


var cut_id = 0

func _ready():
	add_to_group("apple")
	full.visible   = true
	half_l.visible = false
	
	half_r.visible = false
	

func reset_apple():
	been_cut = false
	
	flying   = false
	
	cut_id  += 1
	full.visible   = true
	
	half_l.visible = false
	half_r.visible = false
	
	half_l.position = Vector2.ZERO
	
	half_r.position = Vector2.ZERO
	
	var col = get_node_or_null("CollisionShape2D")
	
	if col:
		col.set_deferred("disabled", false)

func do_cut(whl):
	
	if been_cut:
		return
		
	been_cut  = true
	cut_id   += 1
	
	var my_id = cut_id




	var col = get_node_or_null("CollisionShape2D")
	
	if col:
		col.set_deferred("disabled", true)

	full.visible   = false
	half_l.visible = true
	half_r.visible = true

	var to_apl  = global_position - whl.global_position
	
	var tangent = Vector2(-to_apl.y, to_apl.x).normalized()
	
	
	var tang_v  = tangent * whl.rot_spd * float(whl.dir) * 55.0
	
	
	

	
	l_wpos = global_position + Vector2(-18.0, 0.0)
	
	r_wpos = global_position + Vector2( 18.0, 0.0)
	
	

	l_vel  = tang_v + Vector2(-280.0, -80.0)
	r_vel  = tang_v + Vector2( 280.0, -80.0)
	
	l_spin = -3.5
	
	
	r_spin =  3.5
	l_rot  = 0.0
	
	r_rot  = 0.0

	flying = true

	await get_tree().create_timer(1.8).timeout
	
	
	
	if is_instance_valid(self) and cut_id == my_id:
		queue_free()
		
		

func _process(delta):
	
	
	if not flying:
		return

	l_vel.y += pull * delta
	r_vel.y += pull * delta
	l_vel   *= pow(0.995, delta)
	
	r_vel   *= pow(0.995, delta)
	
	
	l_spin  *= pow(0.97,  delta)
	
	r_spin  *= pow(0.97,  delta)

	l_wpos  += l_vel * delta
	r_wpos  += r_vel * delta
	
	
	
	l_rot   += l_spin * delta
	
	
	r_rot   += r_spin * delta

	half_l.global_position = l_wpos
	
	
	half_r.global_position = r_wpos
	half_l.global_rotation = l_rot
	half_r.global_rotation = r_rot
