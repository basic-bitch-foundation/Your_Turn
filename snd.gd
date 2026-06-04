extends Node

var s_fire   = preload("res://sounds/fire.wav")

var s_cut    = preload("res://sounds/slice.mp3")
var s_strike = preload("res://sounds/knife_strike.wav")

var s_lose   = preload("res://sounds/lose.wav")

var s_lvl    = preload("res://sounds/level change.wav")

func _play(clip):
	
	var p = AudioStreamPlayer.new()
	
	p.stream = clip
	p.bus = "Master"
	
	
	add_child(p)
	p.play()
	p.finished.connect(func(): p.queue_free())
	

func fire():   _play(s_fire)
func cut():    _play(s_cut)

func strike(): _play(s_strike)


func lose():   _play(s_lose)
func lvl():    _play(s_lvl)
