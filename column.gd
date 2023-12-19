extends Control

var infos;

func init(monster : PackedScene):
	var inst = monster.instantiate()
	infos = inst.infos
	inst.queue_free()
	$Add1.text = "Add 1\n$" + str(infos.gold)
	$Add5.text = "Add 5\n$" + str(int((float(infos.gold) * 5.0) * 0.85))
	$Add1.text = "Add 1\n$" + str(infos.gold)
	pass
	
