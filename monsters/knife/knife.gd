extends "res://monsters/monster.gd"

var sprites = {
	Types.Player.BOT : preload("res://art/monster_red.png"),
	Types.Player.YOU : preload("res://art/monster_blue.png"),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = sprites[player]
	type = "knife"
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
