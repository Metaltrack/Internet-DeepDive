extends Node2D

@onready var battle_enemy_scn = preload("res://Characters/battle_enemy.tscn")
@export var combat_tracker :Array[Node2D] = []
@export var bot_array :Array = []
@onready var player: CharacterBody2D = $Player

var selected_bot :int = 0
var current_turn :int = 0

func _ready() -> void:
	if Global.player_initiative:
		combat_tracker.append(player)
		var bot = battle_enemy_scn.instantiate()
		$spawns/Marker2D2.add_child(bot)
		bot.global_position = $spawns/Marker2D2.global_position
		combat_tracker.append(bot)
	else:
		var bot1 = battle_enemy_scn.instantiate()
		var bot2 = battle_enemy_scn.instantiate()
		var bot3 = battle_enemy_scn.instantiate()
		$spawns/Marker2D.add_child(bot1)
		$spawns/Marker2D2.add_child(bot2)
		$spawns/Marker2D3.add_child(bot3)
		bot1.global_position = $spawns/Marker2D.global_position
		bot2.global_position = $spawns/Marker2D2.global_position
		bot3.global_position = $spawns/Marker2D3.global_position
		bot_array.append(bot1)
		bot_array.append(bot2)
		bot_array.append(bot3)
		bot_array.append(player)
		for i in range(4):
			var obj = bot_array.pick_random()
			combat_tracker.append(obj if obj not in combat_tracker else bot_array.pick_random())
	
	print(combat_tracker)
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_right"):
		selected_bot = (selected_bot + 1) % bot_array.size()
		print(selected_bot)
	elif Input.is_action_just_pressed("ui_left"):
		selected_bot = (selected_bot - 1) % bot_array.size()
		print(selected_bot)
	

func _process(delta: float) -> void:
	pass
	
