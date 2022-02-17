extends KinematicBody2D

var vel = Vector2()
var speed = 5

export var bullet_speed = 1000
export var bomb_speed = 50
export var fire_rate = .2
export var fire_bomb_rate = .5

export var mid_speed = 1
export var fire_mid_rate = .01

var bombs = []
var mids = []

var bombs_limit = 5

var bullet = preload("res://bullet.tscn")
var can_fire = true
var can_fire_bomb = true
var can_fire_mid = true

func _process(delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("fire") and can_fire:
		var bullet_instance = bullet.instance()
		bullet_instance.position = $pointer.get_global_position()
		bullet_instance.rotation_degrees = rotation_degrees
		bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
		get_tree().get_root().add_child(bullet_instance)
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
	
	if Input.is_action_pressed("fire_bomb") and can_fire_bomb and can_fire:
		var bullet_instance = bullet.instance()
		bombs.append(bullet_instance)
		bullet_instance.position = $pointer.get_global_position()
		bullet_instance.rotation_degrees = rotation_degrees
		bullet_instance.apply_impulse(Vector2(), Vector2(bomb_speed, 0).rotated(rotation))
		get_tree().get_root().add_child(bullet_instance)
		can_fire = false
		yield(get_tree().create_timer(fire_bomb_rate), "timeout")
		can_fire = true
		if len(bombs) >= bombs_limit:
			can_fire_bomb = false
	
	if Input.is_action_pressed("mid_fire") and can_fire_mid and can_fire:
		var bullet_instance = bullet.instance()
		bullet_instance.position = $pointer.get_global_position()
		bullet_instance.rotation_degrees = rotation_degrees
		bullet_instance.apply_impulse(Vector2(), Vector2(mid_speed, 0).rotated(rotation))
		get_tree().get_root().add_child(bullet_instance)
		mids.append("fire_mid")
		print(len(mids))
		can_fire = false
		yield(get_tree().create_timer(fire_mid_rate), "timeout")
		can_fire = true
		if len(mids) >= 200:
			can_fire_mid = false
func _physics_process(delta):
	if Input.is_action_pressed("left"):
		vel.x -= speed
	if Input.is_action_pressed("right"):
		vel.x += speed
	if Input.is_action_pressed("top"):
		vel.y -= speed
	if Input.is_action_pressed("down"):
		vel.y += speed
	
	if vel.y >= 100:
		vel.y = 100
	if vel.y <= -100:
		vel.y = -100
	if vel.x >= 100:
		vel.x = 100
	if vel.x <= -100:
		vel.x = -100
	
	move_and_slide(vel * speed)
	
	print(vel)


func _on_RigidBody_body_entered(body):
	if body.is_in_group("player"):
		queue_free()
