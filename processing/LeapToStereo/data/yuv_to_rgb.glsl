uniform vec3 iResolution;
uniform sampler2D tex0;

// https://github.com/libretro/glsl-shaders/blob/master/nnedi3/shaders/rgb-to-yuv.glsl
vec3 yuvToRgb(vec3 yuv) {
	float r = yuv.r * 0.299 + yuv.g * 0.587 + yuv.b * 0.114;
	float g = yuv.r * -0.169 + yuv.g * -0.331 + yuv.b * 0.5 + 0.5;
	float b = yuv.r * 0.5 + yuv.g * -0.419 + yuv.b * -0.081 + 0.5;

    return vec3(r, g, b);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec2 uv2 = vec2(uv.x, abs(1.0 - uv.y));

	vec4 col = vec4(yuvToRgb(texture2D(tex0, uv2).xyz), 1.0);

	fragColor = col;
}

void main() {
	mainImage(gl_FragColor, gl_FragCoord.xy);
}