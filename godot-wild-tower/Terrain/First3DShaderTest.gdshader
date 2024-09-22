shader_type spatial;

uniform float height_scale = 0.9;
uniform sampler2D noise;
uniform sampler2D normalmap;
uniform sampler2D albedo;

varying vec2 tex_position;

void vertex() {
  tex_position = (VERTEX.xz + vec2(sin(TIME/10.0), cos(TIME/21.)/200.)) / 2.0 + 0.5;
  float height = texture(noise, tex_position).x;
  VERTEX.y += height * height_scale;
}

void fragment() {
  NORMAL_MAP = texture(normalmap, tex_position).xyz;
  ALBEDO = vec3(.8,0.,.8);
ALPHA = .1;
}