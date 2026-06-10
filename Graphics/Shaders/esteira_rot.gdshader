shader_type spatial;
render_mode unshaded;

uniform float Speed;
uniform sampler2D MainTex: filter_nearest, source_color;

void fragment() {
// Input:2
	float n_out2p0 = TIME;
// FloatParameter:3
	float n_out3p0 = Speed;
	vec3 n_out4p0 = vec3(n_out3p0, 0, 0);
// VectorOp:5
	vec3 n_out5p0 = vec3(n_out2p0) * n_out4p0;
	vec2 n_out7p0 = vec2(n_out5p0.xy) + UV;
// Output:0
	ALBEDO = texture(MainTex, n_out7p0).xyz;
}
