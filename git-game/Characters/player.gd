extends CharacterBody2D

@export var speed :float= 8000.0
@export var card_array :Array = []
@export var player_stats :Stats
@export var health :int = 100
@onready var card_manager: CardManager = $Camera2D/Card_Manager

func _ready() -> void:
	card_manager.present_choice()

func _physics_process(delta: float) -> void:
	
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	velocity = dir * speed * delta
	move_and_slide()
	
