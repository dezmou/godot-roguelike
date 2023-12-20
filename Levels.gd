extends Node

const Knife = preload("res://monsters/knife/knife.tscn")
const Flame = preload("res://monsters/flame/flame.tscn")
const Bomb = preload("res://monsters/bomb/bomb.tscn")

const Types = preload("res://Main.gd")
@onready var Main = get_node("/root/Main")

var levelIndex := 0

func onModalClosed():
	Main.get_node("InfoModal").visible = false;
	launchLevel()

func showModal():
	Main.get_node("InfoModal").visible = true;

func _ready():
	pass

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
			if (bot.monsters.keys().size() == 0):
				return win()
				
