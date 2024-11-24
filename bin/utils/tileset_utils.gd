class_name TilesetUtils extends Node2D


static func pixel_to_tileset_pos(pixel_pos: Vector2, tile_set: TileSet) -> Vector2i:
	return Vector2i(pixel_pos/Vector2(tile_set.tile_size))
