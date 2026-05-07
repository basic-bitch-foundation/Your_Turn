extends Node2D

@onready var wheel = $wheel
@onready var knife_spawn = $spawn
@onready var knife = $knife

var spawn_pending = false

func _ready():
	knife.wheel_node = wheel
	knife.stuck.connect(_on_knife_stuck)

func _process(_delta):
	
	if spawn_pending:
		spawn_pending = false
		_spawn_knife()

func _on_knife_stuck():
	spawn_pending = true

func _spawn_knife():
	var new_knife = preload("res://knife.tscn").instantiate()
	add_child(new_knife)
	new_knife.global_position = knife_spawn.global_position
	new_knife.wheel_node = wheel
	new_knife.stuck.connect(_on_knife_stuck)
