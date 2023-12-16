extends Camera2D

const T_Main = preload("res://Main.gd")
@onready var Main = get_node("/root/Main") as T_Main

var targetZoom := Vector2(1.0, 1.0)
var targetCenter := Vector2(300.0, 500.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = 0.1
	timer.one_shot = false
	timer.timeout.connect(calculate_bounds)
	timer.start()


func _process(delta):
	zoom += (targetZoom - zoom) * 0.02
	position += (targetCenter - position) * 0.01

func calculate_bounds():
	var posMax := Vector2(0,0)
	var posMin := Vector2(9999999,9999999)
	for node in Main.getAllMonsters():
		if node.position.x > posMax.x:
			posMax.x = node.position.x
		if node.position.y > posMax.y:
			posMax.y = node.position.y
		if node.position.x < posMin.x:
			posMin.x = node.position.x
		if node.position.y < posMin.y:
			posMin.y = node.position.y
	targetCenter = (Vector2(posMin.x, posMin.y) + Vector2(posMax.x, posMax.y)) / 2
	var scale_x := 600 / (posMax.x - posMin.x)
	var scale_y := 1000 / (posMax.y - posMin.y)
	var factor = min(min(scale_x, scale_y) * 0.7, 1.2)
	targetZoom = Vector2(factor, factor)
