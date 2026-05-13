extends Area2D

var rot_spd = 1.2
var dir = 1
var origin: Vector2
var shake = 0.0
var active = false

@onready var spr = $Sprite2D

func _ready():
	origin = position

func start():
	active = true

func stop():
	active = false

func _process(delta):
	if active:
		rotation += rot_spd * dir * delta

	if shake > 0.0:
		position = origin + Vector2(randf_range(-shake, shake), randf_range(-shake, shake))
		shake = lerp(shake, 0.0, 0.25)
		if shake < 0.1:
			shake = 0.0
			position = origin

func on_hit():
	shake = 9.0
	do_bounce()
	do_flash()

func do_bounce():
	var t = create_tween()
	t.tween_property(self, "position", origin + Vector2(0, -16), 0.07).set_trans(Tween.TRANS_SINE)
	t.tween_property(self, "position", origin, 0.22).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

func do_flash():
	var t = create_tween()
	t.tween_property(spr, "modulate", Color(2, 2, 2, 1), 0.04)
	t.tween_property(spr, "modulate", Color(1, 1, 1, 1), 0.25)
