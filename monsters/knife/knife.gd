extends "res://monsters/monster.gd"

const infos = {
	"card" : {
		"image" : preload("res://art/knife_card.png"),
		"title" : "Glurmo",
		"text" : "no special effect",
	},
	"health" : 100,
	"attack" : 10,
	"precision" : 10,
	"speed" : 1,
	"gold" : 5.0
}

var sprites = {
	Types.BOT : preload("res://art/monster_red.png"),
	Types.YOU : preload("res://art/monster_blue.png"),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	health = infos.health
	speed = infos.speed
	attack = infos.attack
	precision = infos.precision
	gold = infos.gold
	$Sprite2D.texture = sprites[player.belong]
	type = "knife"
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _physics_process(delta):
	#$Sprite2D.look_at(currentTargetPosition)
	#super._physics_process(delta)
