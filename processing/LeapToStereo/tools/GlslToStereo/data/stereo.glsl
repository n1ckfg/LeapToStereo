// https://synesthesiam.com/assets/mihansen_b689.pdf

// A Depth Map Shader
// -*- c -*- 
//#extension GL_ARB_texture_rectangle : enable uniform sampler2DRect texture;
uniform float micro_size;
uniform vec2 texture_size;
uniform float shift_x;
uniform float shift_y;
uniform float patch_size;
uniform int patch_width;

void main() {
	vec2 num_micro_images = texture_size / micro_size;

	vec2 p = floor(gl_TexCoord[0].st / micro_size);
	vec2 shift = vec2(shift_x, shift_y);
	vec2 offset = gl_TexCoord[0].st / micro_size - p;
	
	int num_patches = 3;
	int num_images = 1;

	float best_slope = 0.0;
	float best_match = 10000000000.0;

	for (float patch_size = micro_size / 2.0; patch_size >= 0.0; patch_size -= 0.5) {
		vec2 left_base = p * micro_size + shift - offset * patch_size;

		float score = 0.0;
		for (int i = 0; i < num_patches; i++) {
			for (int j = 0; j < num_patches; j++) {
				vec2 pixel_shift = vec2(i, j);
				vec4 left = texture2DRect(texture, left_base + pixel_shift);
				for (int m = -num_images; m <= num_images; m++) {
					for (int n = -num_images; n <= num_images; n++) {
						if (m == 0 && n == 0) continue;
						vec2 right_base = left_base + vec2(m, n) * (micro_size + patch_size);
						vec4 right = texture2DRect(texture, right_base + pixel_shift);
						score += distance(left, right);
					}
				}
			}
		}
		if (score < best_match) {
			best_slope = patch_size;
			best_match = score;
		}
	}
	
	float color = best_slope / (micro_size / 2.0);
	gl_FragColor = vec4(color, color, color, 1.0);
}
  