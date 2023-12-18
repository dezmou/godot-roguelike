extends "res://monsters/monster.gd"

const infos = {
	"card" : {
		"image" : preload("res://art/flame_card.png"),
		"title" : "Alphonse",
		"text" : "Range attack",
	},
	"health" : 100,
	"attack" : 10,
	"precision" : 10,
}

var sprites = {
	Types.BOT : preload("res://art/flame_red.png"),
	Types.YOU : preload("res://art/flame_blue.png"),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	health = infos.health
	attack = infos.attack
	precision = infos.precision
	$Sprite2D.texture = sprites[player.belong]
	type = "flame"
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _physics_process(delta):
	#$Sprite2D.look_at(currentTargetPosition)
	#super._physics_process(delta)
