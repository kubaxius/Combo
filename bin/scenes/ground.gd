class_name Ground extends TileMapLayer

@export var tilegen_margin: Vector2i


func _ready() -> void:
	set_material_texture()


func _process(_delta: float) -> void:
	if get_viewport().get_camera_2d():
		generate()


func get_visible_rect_t() -> Rect2i:
	var camera: Camera2D = get_viewport().get_camera_2d()
	var camera_pos := camera.global_position
	var screen_size := get_viewport().get_visible_rect().size/camera.zoom
	
	var visible_rect_pos = camera_pos - screen_size/2
	var visible_rect_pos_t = TilesetUtils.pixel_to_tileset_pos(visible_rect_pos, tile_set) - tilegen_margin
	var visible_rect_size = screen_size
	var visible_rect_size_t = TilesetUtils.pixel_to_tileset_pos(visible_rect_size, tile_set) + tilegen_margin*2
	var visible_rect_t = Rect2i(visible_rect_pos_t, visible_rect_size_t)
	return visible_rect_t

func generate() -> void:
	var visible_rect_t = get_visible_rect_t()
	
	#iterate visible rectangle
	for x in range(visible_rect_t.position.x, visible_rect_t.end.x):
		# ground should be below y=0
		for y in range(max(visible_rect_t.position.y, 0), visible_rect_t.end.y):
			var pos_t = Vector2i(x, y)
			# if not already set
			if get_cell_source_id(pos_t) == -1:
				if y == 0:
					set_cell(pos_t, 0, Vector2i(1, 0))
				else:
					set_cell(pos_t, 0, Vector2i(1, 2))


# HACK: Viewport path set in editor likes to reset to the main node in Godot v4.4.dev5.official [9e6098432]
func set_material_texture():
	if material:
		var mat:ShaderMaterial = material
		var trail_gen:TrailMaskGen = $"../TrailGen"
		mat.set_shader_parameter("MaskTexture", trail_gen.get_texture())
