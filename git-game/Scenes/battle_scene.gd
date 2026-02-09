extends Node2D

@onready var battle_enemy_scn = preload("res://Characters/battle_enemy.tscn")
@export var combat_tracker :Array[Node2D] = []
@export var bot_array :Array[Node2D] = []
@onready var player: CharacterBody2D = $Player

var selected_bot :int = 0
var current_turn :int = 0
var turn_enetity
var player_turn :bool = false
signal turn_ended

func _ready() -> void:
	if Global.player_initiative:
		combat_tracker.append(player)
		var bot = battle_enemy_scn.instantiate()
		$spawns/Marker2D2.add_child(bot)
		bot.global_position = $spawns/Marker2D2.global_position
		combat_tracker.append(bot)
		bot_array.append(bot)
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
			combat_tracker = bot_array
			combat_tracker.shuffle()
	
	print(combat_tracker)
	
	if GameManager.current_card:
		$card_selection/HBoxContainer/TextureButton.texture_normal = GameManager.current_card.icon
	
	start_next_turn()
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_right"):
		selected_bot = (selected_bot + 1) % bot_array.size()
		print(selected_bot)
	elif Input.is_action_just_pressed("ui_left"):
		selected_bot = (selected_bot - 1) % bot_array.size()
		print(selected_bot)
	
	

func start_next_turn() -> void:
	turn_enetity = combat_tracker[current_turn]
	print(turn_enetity)
	if turn_enetity.is_in_group("PLAYER"):
		$AnimationPlayer.play("show")
		player_turn = true
		await turn_ended
		$AnimationPlayer.play_backwards("show")
		current_turn = (current_turn + 1) % combat_tracker.size()
		start_next_turn()
	elif turn_enetity.is_in_group("ENEMY"):
		turn_enetity.animated_sprite.play("ATTACK")
		await turn_enetity.animated_sprite.animation_finished
		player.health -= turn_enetity.enemy_stats.damage
		emit_signal("turn_ended")
		await turn_ended
		current_turn = (current_turn + 1) % combat_tracker.size()
		start_next_turn()
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_select"):
		emit_signal("turn_ended")
	
	if player_turn:
		$enemy_selector_token.global_position = bot_array[selected_bot].global_position
	else:
		$enemy_selector_token.global_position = Vector2(0.0, 0.0)
	

func _on_attack_pressed() -> void:
	print("attack")
	player.animated_sprite_2d.play("ATTACK")
	if bot_array[selected_bot].is_in_group("ENEMY"):
		bot_array[selected_bot].animated_sprite.play("DEATH")
		bot_array[selected_bot].health -= player.player_stats.damage
		if bot_array[selected_bot].health <= 0:
			bot_array.pop_at(selected_bot)
		emit_signal("turn_ended")
	await player.animated_sprite_2d.animation_finished
	player.animated_sprite_2d.play("IDLE")
