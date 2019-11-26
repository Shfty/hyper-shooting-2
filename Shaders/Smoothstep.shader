shader_type canvas_item;

uniform float left_edge = 0.45;
uniform float right_edge = 0.55;
uniform float pixel_offset = 1.0;

void fragment() {
	float le = left_edge;
	float re = right_edge;
	
	if(left_edge == right_edge) {
		le -= TEXTURE_PIXEL_SIZE.x * pixel_offset;
		re += TEXTURE_PIXEL_SIZE.x * pixel_offset;
	}
	
	float color = smoothstep(le, re, texture(TEXTURE, UV).x);
	
	COLOR = vec4(vec3(color), 1.0);
}
