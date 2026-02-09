extends Node2D

@export var spawn_points_array: Array[Marker2D] = []
var current_spawn: Marker2D
@onready var player_scene = preload("res://Characters/player.tscn")
@onready var spawn_points: Node2D = $SpawnPoints

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in spawn_points.get_children():
		spawn_points_array.append(i)
	
	select_rand_spawn()
	
	var player = player_scene.instantiate()
	self.add_child(player)
	
	# Ensure a spawn point was actually selected before accessing it
	if current_spawn:
		player.global_position = current_spawn.global_position
	else:
		push_warning("No spawn point selected! Player position defaults to (0,0).")

func select_rand_spawn():
	if spawn_points_array.is_empty():
		push_error("Spawn points array is empty!")
		return
		
	# FIX: Removed 'var' to update the class member instead of creating a local variable
	current_spawn = spawn_points_array.pick_random()
