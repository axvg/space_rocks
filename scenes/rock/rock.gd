extends RigidBody2D

var screensize = Vector2.ZERO

signal exploded

var size
var radius
var scale_factor = .2

func start(_position, _velocity, _size):
	position = _position
	size = _size
	mass = 1.5  * size
	$Sprite2D.scale = Vector2.ONE * scale_factor * size
	radius = int($Sprite2D.texture.get_size().x / 2 * $Sprite2D.scale.x)
	var shape = CircleShape2D.new()
	shape.radius = radius
	$CollisionShape2D.shape = shape
	linear_velocity = _velocity
	angular_velocity = randf_range(-PI, PI)
	$Explosion.scale = Vector2.ONE * .75 * size

func explode():
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.hide()
	$Explosion/AnimationPlayer.play("new_animation") # change this!
	$Explosion.show()
	exploded.emit(size, radius, position, linear_velocity)
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	await $Explosion/AnimationPlayer.animation_finished
	queue_free()


# to wrap around the screen
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var xform = state.transform
	xform.origin.x = wrapf(
		xform.origin.x,
		0 - radius,
		screensize.x + radius
	)
	xform.origin.y = wrapf(
		xform.origin.y,
		0 - radius,
		screensize.y + radius
	)
	state.transform	= xform
