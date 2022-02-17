extends RigidBody2D


func _on_KinematicBody2D_body_entered(body):
	if !body.is_in_group("player") and !body.is_in_group("bullet") and !body.is_in_group("bullet_recharge"):
		queue_free()
