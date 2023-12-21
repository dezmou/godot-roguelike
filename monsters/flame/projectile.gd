extends RigidBody2D

const Types = preload("res://Main.gd")
@onready var Main = get_node("/root/Main")


#func hit(attack : float, fromPosition : Vector2, force : float):
func _onMeet(body):
	if ("isMonster" in body):
		body.hit(3, position, 0.0)
		queue_free()


func init(player, _position :Vector2, target : Vector2):
	if player.belong == Types.BOT:
		set_collision_mask_value(2,true)
	else:
		set_collision_mask_value(1,true)
	position = _position
	var force = position.direction_to(target) * 900
	apply_central_impulse(force)
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_onMeet)

	await get_tree().create_timer(0.28).timeout
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
