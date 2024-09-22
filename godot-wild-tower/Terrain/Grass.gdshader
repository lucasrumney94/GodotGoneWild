shader_type spatial;

uniform float height_scale = 1.5;
uniform float alpha = .2;
uniform sampler2D noise;
uniform sampler2D normalmap;
uniform sampler2D albedo;

varying vec2 tex_position;

void vertex() {
  tex_position = (VERTEX.xz*30. + vec2(sin(TIME*1.1)/20., cos(TIME/21.)/20.)) / 3.0 + 0.5;
  float height = texture(noise, tex_position).x;
  if(height<0.4) height=0.;
  VERTEX.y += height * height_scale;
}

void fragment() {
  NORMAL_MAP = texture(normalmap, tex_position).xyz;
  ALBEDO = texture(albedo, tex_position).rgb + texture(noise,tex_position/3.).rgb/50.;
  ALPHA = 1.0;
}