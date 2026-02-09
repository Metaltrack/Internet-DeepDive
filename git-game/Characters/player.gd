extends CharacterBody2D

@export var speed :float= 8000.0
@export var card_array :Array = []
@export var player_stats :Stats
@export var health :int = 100
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
#@onready var card_manager: CardManager = $Camera2D/Card_Manager

func _ready() -> void:
	animated_sprite_2d.play("IDLE")
	Global.connect("start_battle", start_battle)

func start_battle() -> void:
	print("Battle_Started")
	

func stat_manager():
	pass
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_select"):
		for body in $initiation_area.get_overlapping_bodies():
			if body.is_in_group("ENEMY"):
				Global.player_initiative = true
				get_tree().change_scene_to_file("res://Scenes/battle_scene.tscn")

func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if dir.x > 0:
		animated_sprite_2d.flip_h = true
	elif dir.x < 0:
		animated_sprite_2d.flip_h = false
	
	velocity = dir * speed * delta
	move_and_slide()
	
