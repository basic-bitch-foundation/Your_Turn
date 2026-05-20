extends Node2D


@onready var k1 = $k1
@onready var k2 = $k2


@onready var k3 = $k3
@onready var k4 = $k4


@onready var k5 = $k5
@onready var k6 = $k6

@onready var k7 = $k7


var img_ready = preload("res://images/knife_shill.png")   
var img_used  = preload("res://images/knife_shill_fade.png")    


var slots = []
var used = 0



func _ready():
	
	slots = [k1, k2, k3, k4, k5, k6, k7]
	reset()

func set_img(node, img):

	if node is Sprite2D:
		
		node.texture = img
		
	elif node is TextureRect:
		node.texture = img
		

func on_knife_fired():
	if used >= slots.size():
		return
		
		
		
	set_img(slots[used], img_used)
	
	
	
	
	used += 1
	if used >= slots.size():
		await get_tree().create_timer(1.0).timeout
		
		
		
		
		reset()
		

func reset():
	used = 0
	
	
	for s in slots:
		set_img(s, img_ready)
