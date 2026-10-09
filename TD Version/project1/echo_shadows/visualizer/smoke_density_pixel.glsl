// smoke_density: one exhaled puff of smoke, mouth at the bottom centre of the image.
// Buffer 0: density (visible smoke). Buffer 1: light attenuation (1 - density * shadow strength) for the gobos.
uniform vec4 uP;   // x time (s), y puff period (s), z density gain, w sideways drift
uniform vec4 uS;   // x shadow strength

layout(location = 0) out vec4 fragDensity;
layout(location = 1) out vec4 fragAtten;

float fbm(vec3 p) {
	float a = 0.5;
	float s = 0.0;
	for (int i = 0; i < 5; i++) {
		s += a * TDSimplexNoise(p);
		p = p * 2.03 + vec3(1.7, 9.2, 3.1);
		a *= 0.5;
	}
	return s;
}

// one exhale: rises and widens from the mouth (q = 0), curls sideways, thins out with age
float puff(vec2 q, float age, float t) {
	float top = 0.06 + age * 0.13;
	float y = q.y;
	float width = 0.04 + max(y, 0.0) * 0.65 + age * 0.035;
	float curl = 0.07 * sin(y * 6.0 - t * 0.8) * smoothstep(0.0, 0.4, y) + uP.w * y;
	float across = (q.x - curl) / width;
	float body = exp(-across * across * 1.8)
	           * smoothstep(-0.03, 0.02, y)
	           * (1.0 - smoothstep(top * 0.55, top, y));
	return body * exp(-age * 0.42);
}

void main() {
	vec2 q = vec2(vUV.s - 0.5, vUV.t - 0.05);
	float t = uP.x;
	float period = max(uP.y, 0.5);
	float age = mod(t, period);
	float shape = puff(q, age, t) + 0.8 * puff(q, age + period, t);

	vec3 np = vec3(q.x * 4.5, q.y * 3.5 - t * 0.32, t * 0.11);
	float wisps = smoothstep(-0.2, 0.55, fbm(np));
	float d = clamp(shape * wisps * uP.z, 0.0, 1.0);

	// fade to 0 at the borders so the gobo edges stay clear
	vec2 e = smoothstep(0.0, 0.06, vUV.st) * smoothstep(0.0, 0.06, 1.0 - vUV.st);
	d *= e.x * e.y;

	fragDensity = TDOutputSwizzle(vec4(d));
	fragAtten = TDOutputSwizzle(vec4(vec3(1.0 - d * uS.x), 1.0));
}
