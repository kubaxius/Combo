shader_type canvas_item;
//render_mode blend_mul;

const vec3 BLACK = vec3(0.);
const vec3 WHITE = vec3(1.);

// Neighboring pixels range to check in shrink function.
const ivec2 X_CHECK_RANGE = ivec2(-1, 1);
const ivec2 Y_CHECK_RANGE = ivec2(1, 1);

uniform float SPEED : hint_range(1, 10, 0.1) = 2.;
uniform sampler2D SCREEN : hint_screen_texture, repeat_enable;

// Obsolete.
vec3 discrete_shrink(vec2 screen_uv, vec2 screen_pixel_size) {
	// if the pixel that we check is already black, just return black
	if(texture(SCREEN, screen_uv).rgb == BLACK)
		return BLACK;

	// check the neighbors declared in CHECK_RANGE ranges
	for(int x = X_CHECK_RANGE.x; x < X_CHECK_RANGE.y+1; x++){
		for(int y = Y_CHECK_RANGE.x; y < Y_CHECK_RANGE.y+1; y++){
			if(x == 0 && y == 0)
				continue; // skip the pixel that we are checking
			vec2 neighbor_pos = screen_uv + vec2(screen_pixel_size.x*float(x), screen_pixel_size.y*float(y));
			float neighbor_brightness = texture(SCREEN, neighbor_pos).r;

			// if any of the neighbors is black, return black
			if(neighbor_brightness < 0.001){
				return BLACK;
			}
		}
	}
	return WHITE;
}

// This function assumes that the current node sprites are colored red,
// their trail is white, and background is black.
vec3 smooth_shrink(vec2 screen_uv, vec2 screen_pixel_size, float speed) {
	// if the pixel that we check is either red or black, return it
	if(texture(SCREEN, screen_uv).g < 0.01)
		return texture(SCREEN, screen_uv).rgb;
	
	// Since we work only on white pixels, we can just use red value
	float brightness = texture(SCREEN, screen_uv).r;
	
	// check the neighbors declared in CHECK_RANGE ranges
	for(int x = X_CHECK_RANGE.x; x < X_CHECK_RANGE.y+1; x++){
		for(int y = Y_CHECK_RANGE.x; y < Y_CHECK_RANGE.y+1; y++){
			if(x == 0 && y == 0)
				continue; // skip the pixel that we are checking
			vec2 neighbor_pos = screen_uv + vec2(screen_pixel_size.x*float(x), screen_pixel_size.y*float(y));
			// here we use red, since we don't want to shrink away from red pixels
			float neighbor_brightness = texture(SCREEN, neighbor_pos).r;
			
			// if any of the neighbors is black, return black
			if(neighbor_brightness < 0.01){
				brightness -= 0.1 * speed;
				brightness = max(brightness, 0.);
			}
		}
	}
	return WHITE*brightness;
}

void fragment() {
	COLOR.rgb = smooth_shrink(SCREEN_UV, SCREEN_PIXEL_SIZE, SPEED);
}