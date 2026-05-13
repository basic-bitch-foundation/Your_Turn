extends Node2D

@onready var log = $wheel
@onready var spawn_pt = $spawn
@onready var flash = $flash/rect

func _ready():
	spawn()

func setup_knife(k):
	k.log_node = log
	k.stuck.connect(func(): spawn())
	k.hit_other.connect(on_clash)

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
	setup_knife(k)
