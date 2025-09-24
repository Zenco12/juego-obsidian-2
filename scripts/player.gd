class_name player
extends CharacterBody2D

@export var velocidad = 200
@export var velocidadSalto = 250
@export var gravedadSubida = 500
@export var gravedadCaida = 1200

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Movimiento horizontal
	var direccion = Input.get_axis("izquierda", "derecha")
	velocity.x = velocidad * direccion

	# Animación
	if direccion != 0:
		sprite.play("Correr")
		sprite.flip_h = direccion < 0
	else:
		sprite.play("Estatico")

	# Saltar
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = -velocidadSalto

	# Aplicar gravedad variable
	if velocity.y < 0:  # subiendo
		velocity.y += gravedadSubida * delta
	else:               # cayendo
		velocity.y += gravedadCaida * delta

	# Bajar de plataforma One Way
	if Input.is_action_pressed("abajo") and is_on_floor():
		# Para bajar de una plataforma One Way, le damos una velocidad hacia abajo
		velocity.y = 300  # ajusta este valor según necesites

	# Mover al personaje
	move_and_slide()
