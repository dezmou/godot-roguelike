extends RigidBody2D

const Main = preload("res://Main.gd")

var health = 10
var type = "base"
var player : Main.Player

func init(player : Main.Player):
	self.player = player
	$playerColor.color = Color(0.7,0.2,0.1,0.5) if player == Main.Player.BOT else  Color(0.2,0.7,0.1,0.5)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
