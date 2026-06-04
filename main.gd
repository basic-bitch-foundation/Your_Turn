extends Node2D

@onready var whl       = $wheel

@onready var spawn_pt  = $spawn

@onready var flash     = $flash/rect

@onready var ui        = $knifes_ui

@onready var prog      = $progression

@onready var instr     = $instruction


@onready var clash_pop = $top_layer/clash_popup

@onready var win_pop   = $top_layer/Node2D/win_popup


enum gst { play, clear, lose, win }
var state = gst.play

var ok_fire   = false

var thrown    = 0
var max_throw = 7
var ft        = 0.0
var base_y    = 0.0

func _ready():
	
	whl.active        = true
	
	clash_pop.visible = false
	
	win_pop.visible   = false
	
	
	prog.setup()
	prog.main_ref = self
	if instr:
		
		
		base_y = instr.position.y
		
		
	 
	await get_tree().physics_frame
	
	
	
	
	await get_tree().physics_frame
	spawn()
	await get_tree().create_timer(1.2).timeout
	ok_fire = true
	
	

func _process(delta):
	if instr and instr.visible:
		ft += delta * 1.8
		instr.position.y = base_y + sin(ft) * 8.0

func setup(k):
	k.log_node          = whl
	k.ready_to_fire_ref = func(): return ok_fire
	k.stuck.connect(func():     on_stuck())
	
	
	
	k.hit_other.connect(        on_clash)
	
	k.fired.connect(func():     on_fired())
	
	
	k.apple_hit.connect(func(): on_apple())
	
	
	k.missed.connect(func():    on_miss())

func on_fired():
	thrown += 1
	if ui:
		ui.on_knife_fired()
	if instr:
		instr.visible = false

func on_apple():
	
	
	
	if state != gst.play:
		return
	prog.advance(0)
	
	
	
	
	




func on_stuck():
	if state != gst.play:
		return
	if thrown >= max_throw:
		lose()
		return
	spawn()

func on_miss():
	if state != gst.play:
		
		
		return
		
		
		
	lose()



func on_clash():
	if state != gst.play:
		
		
		
		return
	state   = gst.lose
	ok_fire = false
	do_flash()
	
	
	Engine.time_scale = 0.0
	await get_tree().create_timer(0.06, true, false, true).timeout
	Engine.time_scale = 1.0
	_show_lose_pop()

func lose():
	if state != gst.play:
		return
		
	state   = gst.lose
	ok_fire = false
	_show_lose_pop()

func _show_lose_pop():
	Snd.lose()
	clash_pop.scale    = Vector2(0.5, 0.5)
	
	clash_pop.modulate = Color(1, 1, 1, 0)
	
	
	
	
	clash_pop.visible  = true
	
	var t = create_tween()
	
	t.tween_property(clash_pop, "scale",    Vector2(1, 1),    0.25) \
	
	
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.parallel().tween_property(clash_pop, "modulate", Color(1, 1, 1, 1), 0.2)
	
	
	
	var tmr = get_tree().create_timer(2.0)
	tmr.timeout.connect(func(): get_tree().reload_current_scene())

func show_win():
	if state != gst.play:
		
		return
		
		
	state   = gst.win
	ok_fire = false
	win_pop.scale    = Vector2(0.5, 0.5)
	
	
	
	
	
	win_pop.modulate = Color(1, 1, 1, 0)
	
	
	win_pop.visible  = true
	
	var t = create_tween()
	t.tween_property(win_pop, "scale",    Vector2(1, 1),    0.3) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
		
		
		
	t.parallel().tween_property(win_pop, "modulate", Color(1, 1, 1, 1), 0.25)
	var btn = win_pop.get_node_or_null("Button")
	
	
	if btn and not btn.pressed.is_connected(_on_play_again):
		
		
		
		btn.pressed.connect(_on_play_again)

func _on_play_again():
	get_tree().reload_current_scene()

func round_clear():
	
	state   = gst.clear
	ok_fire = false
	
	
	
	await get_tree().create_timer(0.6).timeout
	
	for ch in whl.get_children():
		if ch.get_script() != null and not ch.is_in_group("apple"):
			ch.queue_free()
	thrown = 0
	if ui:
		ui.reset()
		
		
		
	await get_tree().create_timer(0.4).timeout
	
	
	
	
	
	prog.set_lvl(prog.lvl)
	Snd.lvl()
	state   = gst.play
	spawn()
	await get_tree().create_timer(0.6).timeout
	
	ok_fire = true

func do_flash():
	if not flash:
		
		return
		
	flash.modulate = Color(1, 1, 1, 1)
	flash.visible  = true
	
	var t = create_tween()
	
	t.tween_property(flash, "modulate", Color(1, 1, 1, 0), 0.18)
	
	
	t.tween_callback(func(): flash.visible = false)

func spawn():
	var k = preload("res://knife.tscn").instantiate()
	add_child(k)
	k.global_position = spawn_pt.global_position
	setup(k)
