extends CharacterBody2D

@export var speed :float= 8000.0
@export var card_array :Array = []
@export var player_stats :Stats
@export var health :int = 100
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.play("IDLE")
	Global.connect("start_battle", start_battle)

func start_battle() -> void:
	print("Battle_Started")
	

func stat_manager():
	pass
	

func _physics_process(delta: float) -> void:
	
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if dir.x > 0:
		animated_sprite_2d.flip_h = true
	elif dir.x < 0:
		animated_sprite_2d.flip_h = false
	
	velocity = dir * speed * delta
	move_and_slide()
	
