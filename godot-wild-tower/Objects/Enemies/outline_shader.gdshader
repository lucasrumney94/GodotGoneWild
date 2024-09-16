//lifted from https://godotshaders.com/shader/the-simplest-outline-shader-via-material/

shader_type spatial;
render_mode blend_add, cull_front, unshaded, depth_prepass_alpha;

uniform vec4 color : source_color = vec4(1,0,0,1);
uniform float size : hint_range(1.0, 1.5, 0.01) = 1.05;

void vertex() {
	VERTEX *= size;
}

void fragment() {
	ALBEDO = color.rgb;
	if(size <= 1.0)
		ALPHA = 0.0;
	else ALPHA = color.a;
}
