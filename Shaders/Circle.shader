shader_type canvas_item;

uniform sampler2D rtt;

uniform float radius = 0.5;
uniform float gradient = 0.0;
uniform float pixel_offset = 2.0;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	vec2 center = vec2(0.5);
	vec2 delta = center - UV;
	float dist = length(delta);
	
	float grad = gradient;
	if(grad == 0.0) {
		grad = SCREEN_PIXEL_SIZE.x * pixel_offset;
	}
	
	float rad = radius - SCREEN_PIXEL_SIZE.x;
	
	float color = smoothstep(rad - grad, rad, dist);
	
	COLOR = vec4(vec3(color), 1.0);
}
