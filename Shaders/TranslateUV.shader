shader_type canvas_item;

uniform vec2 offset = vec2(0.0);
uniform bool wrap = true;

void fragment() {
	vec2 uv = UV - offset;
	
	if(wrap) {
		uv = mod(uv, 1.0);
	}
	
	COLOR = texture(TEXTURE, uv);
}
