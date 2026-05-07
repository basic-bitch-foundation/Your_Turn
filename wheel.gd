extends Area2D

var rotation_speed= 1.2
var direction: = 1
var origin_position: Vector2
var shake_strength = 0.0

@onready var sprite = $Sprite2D

func _ready():
	origin_position = position

func _process(delta):
	rotation += rotation_speed * direction * delta

	
	if shake_strength > 0.0:
		position = origin_position + Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		shake_strength = lerp(shake_strength, 0.0, 0.25)
		if shake_strength < 0.1:
			shake_strength = 0.0
			position = origin_position

func knife_hit():
	shake_strength = 9.0
	_do_bounce()
	_do_flash()

func _do_bounce():
	var t = create_tween()
	t.tween_property(self, "position", origin_position + Vector2(0, -16), 0.07)\
		.set_trans(Tween.TRANS_SINE)
	t.tween_property(self, "position", origin_position, 0.22)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_BOUNCE)

func _do_flash():
	var t = create_tween()
	t.tween_property(sprite, "modulate", Color(2, 2, 2, 1), 0.04)
	t.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.25)
