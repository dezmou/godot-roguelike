extends "res://monsters/monster.gd"

var sprites = {
	Types.BOT : preload("res://art/monster_red.png"),
	Types.YOU : preload("res://art/monster_blue.png"),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = sprites[player]
	type = "knife"
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _physics_process(delta):
	#$Sprite2D.look_at(currentTargetPosition)
	#super._physics_process(delta)
