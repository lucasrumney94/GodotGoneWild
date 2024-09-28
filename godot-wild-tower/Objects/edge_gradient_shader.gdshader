//found at https://www.reddit.com/r/godot/comments/oxr6ji/how_hard_would_it_be_to_implement_an_edgegradient/

shader_type spatial;

uniform vec4 color : source_color = vec4(1,0,0,1);

varying vec3 position;

void vertex()
{
   position = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment()
{
    vec3 normal = normalize(cross(dFdx(position), dFdy(position)));
	//vec3 normal = normalize(cross(dFdy(position), dFdx(position)));
    ALBEDO = color.rgb * clamp(mix(-5.0, 1.0, dot(normal, NORMAL)), 0.0, 1.0);
	//ALBEDO = vec3(dot(normal, NORMAL));
}
