extends Node2D

@onready var log = $wheel
@onready var spawn_pt = $spawn
@onready var flash = $flash/rect
@onready var ui = $knifes_ui

var ready_to_fire = false

var cooldown = 1.2



var knives_thrown = 0
var max_knives = 7




func _ready():
	log.active = true
	spawn()
	await get_tree().create_timer(cooldown).timeout
	ready_to_fire = true
	
	
	

func setup(k):
	k.log_node = log
	
	
	
	k.ready_to_fire_ref = func(): return ready_to_fire
	k.stuck.connect(func(): on_stuck())
	k.hit_other.connect(on_clash)
	
	
	
	k.fired.connect(func(): on_fired())

func on_fired():
	knives_thrown += 1
	if ui:
		ui.on_knife_fired()

func on_stuck():
	if knives_thrown >= max_knives:
		
		await get_tree().create_timer(1.2).timeout
		
		
		
		get_tree().reload_current_scene()
		return
	spawn()
	
	
	

func on_clash():
	
	
	do_flash()
	Engine.time_scale = 0.0
	
	
	
	
	await get_tree().create_timer(0.06, true, false, true).timeout
	Engine.time_scale = 1.0

func do_flash():
	if not flash:
		return
		
		
		
	flash.modulate = Color(1, 1, 1, 1)
	flash.visible = true
	var t = create_tween()
	
	t.tween_property(flash, "modulate", Color(1, 1, 1, 0), 0.18)
	t.tween_callback(func(): flash.visible = false)
	

func spawn():
	
	var k = preload("res://knife.tscn").instantiate()
	
	add_child(k)
	k.global_position = spawn_pt.global_position
	
	
	
	setup(k)
