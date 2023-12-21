extends Node

const Knife = preload("res://monsters/knife/knife.tscn")
const Flame = preload("res://monsters/flame/flame.tscn")
const Bomb = preload("res://monsters/bomb/bomb.tscn")

const Types = preload("res://Main.gd")
@onready var Main = get_node("/root/Main")

var levelIndex := 0

const texts = {
	0 : 	"""
Welcome to this dope Roguelite.

For starter, why don't you try to battle this red Glurmo. 

That's right, red are ennemy and you are blue. 
		
Buy some monsters to fight the red glurmo !
	""",
	1 : """
[b]Nice ![/b]

You won $30


Now fight all those monsters !
	""",
	
	2 : """

You won $100

Now let's play

tips : You can't have more than 40 of your monsters on the board.

I you buy more, they wait in the queue ( top right corner of the screen)

	""",
	
3 :"""
Not bad 

+ $150

Ennemy can also spawn during battle
""",

4 :"""
Not bad 

+ $150

Oh no, the big Glurmo entered the scene
take care of it
""",

5 :"""
Noice

You won $150

""",

6 :"""
You finished the tutorial


"""
}

var skippedByMain = false

func onModalClosed():
	Main.get_node("InfoModal").visible = false;
	launchLevel()

func showModal():
	Main.get_node("InfoModal").visible = true;
	Main.get_node("InfoModal/Text").text = "[center]" + texts[levelIndex] + "[/center]"

func _ready():
	showModal();

func start():
	showModal()

func win():
	Main.emptyBoard()
	levelIndex += 1
	showModal();

func launchLevel():
	var bot = Main.players[Types.BOT]
	var you = Main.players[Types.YOU]
	if levelIndex == 0:
		Main.spawnMonster(bot, Knife)
		while true:
			await get_tree().create_timer(1.0).timeout
			if (skippedByMain): return
			if (bot.monsters.keys().size() == 0):
				await get_tree().create_timer(1.5).timeout
				you.gold += 30.0
				return win()
				
	if levelIndex == 1:
		for i in range(3):
			Main.spawnMonster(bot, Knife)
		while true:
			await get_tree().create_timer(1.0).timeout
			if (skippedByMain): return
			if (bot.monsters.keys().size() == 0):
				await get_tree().create_timer(1.5).timeout
				return win()


	if levelIndex == 2:
		for i in range(15):
			Main.spawnMonster(bot, Knife)
		for i in range(7):
			Main.spawnMonster(bot, Flame)

		while true:
			await get_tree().create_timer(1.0).timeout
			if (skippedByMain): return
			if (bot.monsters.keys().size() == 0):
				you.gold += 150.0
				await get_tree().create_timer(1.5).timeout
				return win()

	
	if levelIndex == 3:
		bot.maxMonster = 5
		bot.spawnQueue["flame"] = 10
		bot.spawnQueue["knife"] = 10
		while true:
			await get_tree().create_timer(1.0).timeout
			if (skippedByMain): return
			if (bot.monsters.keys().size() == 0):
				await get_tree().create_timer(1.5).timeout
				you.gold += 150.0
				return win()

	if levelIndex == 4:
		bot.maxMonster = 40
		var monster = Knife.instantiate()
		monster.disableSpriteAnimation = true
		monster.get_node("Sprite2D").scale = Vector2(2.0, 2.0)
		var shape = monster.get_node("CollisionShape2D").shape.duplicate()
		shape.radius *= 3
		monster.get_node("CollisionShape2D").shape = shape
		Main.applySpawnMonster(bot, monster)
		monster.attack = 100.0
		monster.start_health = 300.0
		monster.health = 300.0
		#monster.speed = 0.1
		monster.mass *= 5
		monster.precision = 1000.0
		bot.spawnQueue["knife"] = 2
		bot.spawnQueue["flame"] = 2


		while true:
			await get_tree().create_timer(1.0).timeout
			if (skippedByMain): return
			if (bot.monsters.keys().size() == 0):
				await get_tree().create_timer(1.5).timeout
				you.gold += 150.0
				return win()

	if levelIndex == 5:
		bot.maxMonster = 40
		bot.spawnQueue["flame"] = 50
		while true:
			await get_tree().create_timer(1.0).timeout
			if (skippedByMain): return
			if (bot.monsters.keys().size() == 0):
				break

		bot.spawnQueue["bomb"] = 2
		while true:
			await get_tree().create_timer(1.0).timeout
			if (skippedByMain): return
			if (bot.monsters.keys().size() == 0):
				break

		bot.spawnQueue["knife"] = 15
		bot.spawnQueue["flame"] = 15
		while true:
			await get_tree().create_timer(1.0).timeout
			if (skippedByMain): return
			if (bot.monsters.keys().size() == 0):
				await get_tree().create_timer(1.5).timeout
				you.gold += 69420.0
				return win()

	
########################################################## END TUTORIAL

	if levelIndex == 6:
		skippedByMain = false
		Main.get_node("Control/SkipTutorial").visible = false
		you.gold = 300
		bot.maxMonster = 40
		bot.spawnQueue["knife"] = 10
		bot.spawnQueue["bomb"] = 1
		while true:
			await get_tree().create_timer(1.0).timeout
			if (skippedByMain): return
			if (bot.monsters.keys().size() == 0):
				break

		while true:
			bot.spawnQueue["knife"] = 200
			bot.spawnQueue["flame"] = 200
			await get_tree().create_timer(1.0).timeout
			if (skippedByMain): return
			if (bot.monsters.keys().size() == 0):
				break


