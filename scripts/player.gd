class_name player
extends CharacterBody2D

@export var velocidad = 200
@export var velocidadSalto = 250
@export var gravedadSubida = 500
@export var gravedadCaida = 1200
@export var velocidadAgachado = 100

signal damageemit()

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# --- Estados ---
var atacando: bool = false
var cooldown: bool = false
var agachado: bool = false
var moviendo: bool = false

# --- Teclas presionadas ---
var j_esta_presionada: bool = false
var c_esta_presionada: bool = false

func _ready() -> void:
	sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	# --- Detectar teclas ---
	var j_just_pressed := Input.is_physical_key_pressed(KEY_J) and not j_esta_presionada
	j_esta_presionada = Input.is_physical_key_pressed(KEY_J)
	c_esta_presionada = Input.is_physical_key_pressed(KEY_C)
	agachado = c_esta_presionada

	# --- Movimiento ---
	var izquierda := Input.is_physical_key_pressed(KEY_A)
	var derecha := Input.is_physical_key_pressed(KEY_D)
	moviendo = izquierda or derecha

	if agachado:
		# Movimiento reducido si está agachado
		if derecha:
			velocity.x = velocidadAgachado
			sprite.flip_h = false
		elif izquierda:
			velocity.x = -velocidadAgachado
			sprite.flip_h = true
		else:
			velocity.x = 0
	else:
		# Movimiento normal
		var direccion = Input.get_axis("izquierda", "derecha")
		velocity.x = velocidad * direccion
		if direccion != 0:
			sprite.flip_h = direccion < 0

	# --- Ataque ---
	if j_just_pressed and not atacando and not cooldown:
		if agachado and not moviendo:
			atacando = true
			cooldown = true
			_play_if_different("AgacharsePegar")
			_start_cooldown()
		elif not agachado:
			atacando = true
			cooldown = true
			_play_if_different("Attack")
			_start_cooldown()

	# --- Saltar ---
	if not agachado and Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = -velocidadSalto

	# --- Gravedad ---
	if velocity.y < 0:
		velocity.y += gravedadSubida * delta
	else:
		velocity.y += gravedadCaida * delta

	# --- Bajar plataforma one-way ---
	if Input.is_action_pressed("abajo") and is_on_floor():
		velocity.y = 300

	move_and_slide()

	# --- Animaciones ---
	if not atacando:
		_actualizar_animacion()

func _actualizar_animacion() -> void:
	if agachado:
		if moviendo:
			_play_if_different("AgacharseMoverse")
		else:
			_play_if_different("MantenerAgacharse")
	else:
		if velocity.x != 0:
			_play_if_different("Correr")
		else:
			_play_if_different("Estatico")

func _on_animation_finished() -> void:
	if sprite.animation == "Attack" or sprite.animation == "AgacharsePegar":
		atacando = false
		_actualizar_animacion()

func _start_cooldown() -> void:
	await get_tree().create_timer(0.2).timeout
	cooldown = false

# --- Funciones extra para llamar manualmente ---
func agacharse_unavez() -> void:
	_play_if_different("AgacharseUnaVez")

func mantener_agacharse(activo: bool) -> void:
	if activo and not atacando:
		_play_if_different("MantenerAgacharse")

func agacharse_pegar() -> void:
	_play_if_different("AgacharsePegar")

# --- Auxiliar ---
func _play_if_different(anim: String) -> void:
	if sprite.animation != anim:
		sprite.play(anim)

func damage():
	damageemit.emit()
