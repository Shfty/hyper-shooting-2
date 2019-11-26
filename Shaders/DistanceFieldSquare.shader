shader_type canvas_item;

uniform vec2 center = vec2(0.5);

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	vec2 delta = center - UV;
	float dist = max(abs(delta.x), abs(delta.y));
	
	COLOR = vec4(vec3(dist), 1.0);
}
