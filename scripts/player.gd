class_name player
extends CharacterBody2D

@export var gravedad = 550
@export var velocidad = 200
@export var velocidadSalto = 400

func _physics_process(delta):
		#gravedad
	if not is_on_floor():
		velocity.y += gravedad * delta
	
	#horizontal
	var direccion = Input.get_axis("izquierda","derecha")
	velocity.x = velocidad * direccion
	
	#agacharse
	if Input.is_action_just_pressed("abajo"):
		print("agacharse")
	
	#arriba
	if Input.is_action_just_pressed("arriba"):
		print("arriba")
	
	#saltar
	var saltoPresionado = Input.is_action_just_pressed("saltar")
	if saltoPresionado and is_on_floor():
		velocity.y -= velocidadSalto
	move_and_slide()
