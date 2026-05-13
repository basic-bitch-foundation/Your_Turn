extends Node2D


@onready var k1 = $k1
@onready var k2 = $k2

@onready var k3 = $k3

@onready var k4 =    $k4
@onready  var k5 = $k5

@onready  var k6 = $k6

@onready var k7 = $k7


var white = preload("res://icon.svg")
var dark  = preload("res://icon.svg")

var slots = []
var used = 0

func _ready():
	slots = [k1, k2, k3, k4, k5, k6, k7]
	
	for s in slots:
		s.texture = white

func darken_next():
	if used >= slots.size():
		return
	slots[used].texture = dark
	used += 1

func reset():
	used = 0
	for s in slots:
		s.texture = white
