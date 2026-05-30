extends Node2D

@onready var a1 = $"../wheel/apple"
@onready var a2 = $"../wheel/apple2"
@onready var a3 = $"../wheel/apple3"
@onready var a4 = $"../wheel/apple4"
@onready var a5 = $"../wheel/apple5"

@onready var d1  = $dot
@onready var ln1 = $line
@onready var d2  = $dot2
@onready var ln2 = $line2
@onready var d3  = $dot3

var dot_off = preload("res://images/okay_dot_mo.png")
var ln_off  = preload("res://images/okay_line_no.png")
var dot_on  = preload("res://images/okay_dot.png")
var ln_on   = preload("res://images/okay_line.png")

var lvl      = 1
var hits     = 0
var main_ref = null

const tgts = [1, 2, 3, 4, 5]

func setup():
	lvl  = 1
	hits = 0
	set_lvl(1)

func advance(_unused):
	hits += 1
	if hits < tgts[lvl - 1]:
		return
	
	lvl  += 1
	hits  = 0
	if lvl > 5:
		if main_ref:
			main_ref.show_win()
		return

	
	if main_ref:
		main_ref.round_clear()

func set_lvl(r: int):
	show_apl(a1, r >= 1)
	show_apl(a2, r >= 2)
	show_apl(a3, r >= 3)
	show_apl(a4, r >= 4)
	show_apl(a5, r >= 5)

	d1.texture  = dot_on
	ln1.texture = ln_on  if r >= 2 else ln_off
	d2.texture  = dot_on if r >= 3 else dot_off
	ln2.texture = ln_on  if r >= 4 else ln_off
	d3.texture  = dot_on if r >= 5 else dot_off

func show_apl(apl, on: bool):
	if not apl:
		return
	if on:
		apl.reset_apple()
	apl.visible = on
	var col = apl.get_node_or_null("CollisionShape2D")
	if col:
		col.set_deferred("disabled", not on)
