extends CharacterBody2D

@export var speed :float = 5000.0
@export var health :int = 100
@export var enemy_stats :Stats
@onready var look: Area2D = $look

var player :Node2D = null
var patrol_dir :Vector2

func _ready() -> void:
	patrol_dir = random_dir()
	

func random_dir() -> Vector2:
	return Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized()

func _physics_process(delta: float) -> void:
	
	if not player:
		look_at(global_position + patrol_dir)
		speed = 5000.0
	else:
		look_at(player.global_position)
		speed = 8000.0
	
	if player:
		patrol_dir = global_position.direction_to(player.global_position)
	
	if patrol_dir.x < 0:
		$AnimatedSprite2D.flip_v = true
	else:
		$AnimatedSprite2D.flip_v = false
	
	if $RayCast2D.is_colliding():
		var target = $RayCast2D.get_collider()
		if target is TileMapLayer:
			patrol_dir = random_dir()
		if target.is_in_group("PLAYER"):
			$AnimatedSprite2D.play("EXPLODE")
			await $AnimatedSprite2D.animation_finished
			Global.emit_signal("start_battle")
<<<<<<< Updated upstream
<<<<<<< Updated upstream
=======
			queue_free()
>>>>>>> Stashed changes
=======
			queue_free()
>>>>>>> Stashed changes
	
	velocity = patrol_dir * speed * delta
	move_and_slide()
	

func _on_look_body_entered(body: Node2D) -> void:
	if body.is_in_group("PLAYER"):
		player = body
	

func _on_look_body_exited(body: Node2D) -> void:
	if body.is_in_group("PLAYER"):
		player = null
