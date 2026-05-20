extends Node2D


const pre = "res://%d.png"

@onready var ones = $d1
@onready var tens = $d10

var imgs = []

func _ready():
	for i in range(10):
		imgs.append(load(pre % i))
	set_score(0)

func set_score(val: int):
	val = clamp(val, 0, 99)
	ones.texture = imgs[val % 10]
	if val >= 10:
		tens.texture = imgs[val / 10]
		tens.visible = true
	else:
		tens.visible = false
