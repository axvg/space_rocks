extends RigidBody2D

var screensize = Vector2.ZERO

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

func explode():
	print("boom")

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
