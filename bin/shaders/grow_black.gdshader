shader_type canvas_item;
render_mode blend_mul;

const vec3 BLACK = vec3(0.);
const vec3 WHITE = vec3(1.);

uniform int SPEED : hint_range(1, 1000) = 200;
uniform sampler2D SCREEN : hint_screen_texture, repeat_enable;


vec3 shrink(vec2 screen_uv, vec2 screen_pixel_size) {
	// if the pixel that we check is already black, just return black
	if(texture(SCREEN, screen_uv).rgb == BLACK)
		return BLACK;
	
	float brightness = texture(SCREEN, screen_uv).r;
	// check all the neighboring pixels
	for(int x = -1; x < 2; x++){
		for(int y = 1; y < 2; y++){
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


void fragment() {
	vec3 color = texture(SCREEN, SCREEN_UV).rgb;
	int frame = int(TIME * 60.);
	int frame_spread = max(int((1./SCREEN_PIXEL_SIZE.x)/float(SPEED)), 1);
	
	if(frame%frame_spread == 0){
		color = shrink(SCREEN_UV, SCREEN_PIXEL_SIZE);
	}
	
	COLOR.rgb = color;
	
	
}