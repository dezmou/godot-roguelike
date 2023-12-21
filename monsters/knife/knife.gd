extends "res://monsters/monster.gd"

const infos = {
	"card" : {
		"image" : preload("res://art/knife_card.png"),
		"title" : "Glurmo",
		"text" : "no special effect",
	},
	"name" : "knife",
	"health" : 100,
	"attack" : 10,
	"precision" : 10,
	"speed" : 1,
	"gold" : 5.0,
}

var text = """
[center][font_size={35}]Glurmo[/font_size]
[img=450x450]res://art/knife_card.png[/img]
[/center]

[font_size={30}][color=#7e6e33]Price : $%s[/color][/font_size]
[font_size={30}][color=green]Health : %s[/color][/font_size]

[font_size={22}]Close combat unit
Attack [color=red]%s[/color] with precision [color=blue]%s[/color][/font_size]

When two monsters meet, the one who strikes is chosen at random, the more precision it has, the more likely it is to hit
""" % [
	str(infos.gold), 
	str(infos.health),
	str(infos.attack), 
	str(infos.precision), 
]

var sprites = {
	Types.BOT : preload("res://art/monster_red.png"),
	Types.YOU : preload("res://art/monster_blue.png"),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	health = infos.health
	start_health = infos.health
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
