extends "res://monsters/monster.gd"

const infos = {
	"card" : {
		"image" : preload("res://art/bomb_card.png"),
		"title" : "Bomb",
		"text" : "explode when die",
	},
	"name" : "bomb",
	"health" : 80.0,
	"attack" : 80.0,
	"precision" : ".",
	"speed" : 2.0,
	"gold" : 40.0,
}

var text = """
[center][font_size={35}]The Bomb[/font_size]
[img=450x450]res://art/bomb_card.png[/img]
[/center]

[font_size={30}][color=#7e6e33]Price : $%s[/color][/font_size]
[font_size={30}][color=green]Health : %s[/color][/font_size]

[font_size={22}]Does not attack but explode when die
Explosion damage up to [color=red]%s[/color]
Deal friendly damage[/font_size]

""" % [
	str(infos.gold), 
	str(infos.health),
	str(infos.attack), 
]

var sprites = {
	Types.BOT : preload("res://art/bomb_red.png"),
	Types.YOU : preload("res://art/bomb_blue.png"),
}

func end_die():
	$Explode.visible = true
	await get_tree().create_timer(0.07).timeout
	queue_free()

func applyShock(monster : RigidBody2D):
	var shock =  400.0 - position.distance_to(monster.position)
	var damage:float = shock/400 * infos.attack
	if (shock > 0):
		monster.hit(damage, position, shock / 200)

func onWillDie():
	for monster in Main.players[Types.YOU].monsters.values() as Array[RigidBody2D]:
		if (monster.type != "Bomb"):
			applyShock(monster)
	for monster in Main.players[Types.BOT].monsters.values() as Array[RigidBody2D]:
		if (monster.type != "Bomb"):
			applyShock(monster)


# Called when the node enters the scene tree for the first time.
func _ready():
	health = infos.health
	start_health = infos.health
	speed = infos.speed
	attack = 0
	precision = 0
	gold = infos.gold
	$Sprite2D.texture = sprites[player.belong]
	type = "Bomb"
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _physics_process(delta):
	#$Sprite2D.look_at(currentTargetPosition)
	#super._physics_process(delta)
