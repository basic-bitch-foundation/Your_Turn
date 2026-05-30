extends Node2D


const game_scene  = "res://main.tscn"
const github_link = "https://github.com/basic-bitch-foundation/Your_Turn"

@onready var play_btn = $play_btn
@onready var i_btn    = $i_btn

var float_t      = 0.0
var float_base_y = 0.0

func _ready():
	float_base_y = i_btn.position.y
	
	play_btn.pressed.connect(go_play)
	i_btn.pressed.connect(go_github)

func _process(delta):
	
	float_t += delta * 1.8
	i_btn.position.y = float_base_y + sin(float_t) * 6.0

func go_play():
	get_tree().change_scene_to_file(game_scene)

func go_github():
	OS.shell_open(github_link)
