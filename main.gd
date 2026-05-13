extends Node2D

@onready var log = $wheel
@onready var spawn_pt = $spawn


@onready var flash = $flash/rect




@onready var ui = $knives_ui

var started = false

func _ready():
	log.stop()
	
	
	spawn()

func setup(k):
	k.log_node = log
	
	k.stuck.connect(func(): on_stuck())
	k.hit_other.connect(on_clash)

func on_stuck():
	if not started:
		started = true
		log.start()
	ui.darken_next()
	spawn()

func on_clash():
	do_flash()
	
	Engine.time_scale = 0.0
	await get_tree().create_timer(0.06, true, false, true).timeout
	Engine.time_scale = 1.0

func do_flash():
	if not flash:
		return
	flash.visible = true
	flash.modulate = Color(1, 1, 1, 1)
	
	
	var t = create_tween()
	t.tween_property(flash, "modulate", Color(1, 1, 1, 0), 0.35)
	
	t.tween_callback(func(): flash.visible = false)

func spawn():
	
	var k = preload("res://knife.tscn").instantiate()
	add_child(k)
	
	k.global_position = spawn_pt.global_position
	setup(k)
