extends Node2D

var lives = 5
var gameover:bool = false
@onready var livesbar: TextureProgressBar = $CanvasLayer/TextureProgressBar

#signal currentlives(totallives)

func _ready() -> void:
	livesbar.value = lives

#calculo de vida
func _on_character_body_2d_damageemit() -> void:
	if lives > 0 and gameover == false:
		lives -= 1
		livesbar.value = lives
		print(livesbar.value)
		#currentlives.emit(lives)
	else:
		losegame()

func losegame():
	pass
