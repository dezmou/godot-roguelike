const Knife = preload("res://monsters/knife/knife.tscn")
const Flame = preload("res://monsters/flame/flame.tscn")

const waves := [
	{"wait" : 2.0, "monsters" : [{"type" : Knife, "nbr" : 10}, {"type" : Flame,"nbr" : 5}]},
]
