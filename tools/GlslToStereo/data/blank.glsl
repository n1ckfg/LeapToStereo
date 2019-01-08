uniform vec3 iResolution;

uniform sampler2D tex0;

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec2 uv2 = vec2(uv.x, abs(1.0 - uv.y));

	vec4 col = texture2D(tex0, uv2);

	fragColor = col;
}

void main() {
	mainImage(gl_FragColor, gl_FragCoord.xy);
}