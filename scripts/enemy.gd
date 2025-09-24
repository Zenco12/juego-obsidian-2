extends CharacterBody2D

var speed = 100
var gravity = 2000
var detecplayer = null
var perseguir = false
@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	detecplayer = get_tree().get_first_node_in_group("player")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == detecplayer:
		perseguir = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == detecplayer:
		perseguir = false

func _physics_process(delta: float) -> void:
	# Aplicar gravedad siempre
	velocity.y += gravity * delta
	
	if perseguir and detecplayer != null:
		# Solo modificamos X, dejamos Y igual
		var dir = position.direction_to(detecplayer.position)
		velocity.x = dir.x * speed
	else:
		# Cuando no persigue, queda quieto en X
		velocity.x = 0

	# Animaciones según movimiento
	if velocity.x != 0:
		sprite.play("Correr-Enemy")
		sprite.flip_h = velocity.x < 0
	else:
		sprite.play("Estatico-Enemy")

	# Mover usando move_and_slide
	move_and_slide()
