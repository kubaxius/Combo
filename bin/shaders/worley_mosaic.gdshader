// source: https://godotshaders.com/snippet/voronoi/
shader_type canvas_item;

uniform sampler2D SCREEN : hint_screen_texture;

varying vec2 global_pos;
varying mat4 canvas_matrix;

vec2 random(vec2 uv) {
	return vec2(fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123));
}


vec4 voronoi(vec2 global_uv, mat4 cm, float columns, float rows, vec2 ps) {
	
	vec2 index_uv = floor(vec2(global_uv.x * columns, global_uv.y * rows));
	vec2 fract_uv = fract(vec2(global_uv.x * columns, global_uv.y * rows));
	
	float minimum_dist = 100.0;
	vec2 closest_point;

	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 neighbor_uv = mod(vec2(index_uv + neighbor), vec2(columns, rows));

			vec2 point = random(neighbor_uv);

			vec2 diff = neighbor + point - fract_uv;
			float dist = length(diff);
			
			if(dist < minimum_dist) {
				minimum_dist = dist;
				closest_point = (neighbor_uv)/vec2(columns, rows);
			}
		}
	}
	//if(minimum_dist < 0.01)
	//	return vec4(1.);
	return texture(SCREEN, fract((cm * vec4(closest_point/ps, 1., 1.)).xy*ps));
}


void vertex() {
	global_pos = (MODEL_MATRIX * vec4(VERTEX, 1., 1.)).xy;
	canvas_matrix = CANVAS_MATRIX;
}


void fragment() {
	vec2 global_uv = fract(global_pos * SCREEN_PIXEL_SIZE);
	COLOR = voronoi(global_uv, canvas_matrix, 192./2., 108./2., SCREEN_PIXEL_SIZE);
}
