uniform vec3 iResolution;
uniform float threshold;
uniform sampler2D tex0;

float map(float s, float a1, float a2, float b1, float b2) {
    return b1 + (s - a1) * (b2 - b1) / (a2 - a1);
}

vec3 yuvToGray(vec3 yuv) {
	float r = yuv.r * 0.299 + yuv.g * 0.587 + yuv.b * 0.114;
	r = map(r, threshold, 1.0, 0, 1.0);
	float g = r;
	float b = r;

    return vec3(r, g, b);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec2 uv2 = vec2(uv.x, abs(1.0 - uv.y));

	vec4 col = vec4(yuvToGray(texture2D(tex0, uv2).xyz), 1.0);

	fragColor = col;
}

void main() {
	mainImage(gl_FragColor, gl_FragCoord.xy);
}