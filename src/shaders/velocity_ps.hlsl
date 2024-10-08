cbuffer variables : register(b0)
{
	float2 viewport_size;
	float4 mouse;
	float brush_size;
};

struct screen
{
	float4 position : SV_POSITION;
	float2 uv : TEXCOORD;
};

Texture2D brush : register(t0);
SamplerState state : register(s0);

struct render_targets
{
	float4 velocity : SV_TARGET0;
};

static const float2 d = 1 / viewport_size;
static const float2 du = float2(d.x, 0);
static const float2 dv = float2(0, d.y);

float gauss(float sigma, int x, int y)
{
	return exp(-(x * x + y * y) / (2 * sigma * sigma));
};

float4 gaussian_blur(Texture2D<float4> tex, float2 uv, float sigma = 5.0)
{
	float4 color = 0;
	float normalisation = 0;

	for (int i = -5; i <= 5; i++)
	{
		for (int j = -5; j <= 5; j++)
		{
			float weight = gauss(sigma, i, j);
			color += tex.Sample(state, uv + float2(i, j) * d) * weight;
			normalisation += weight;
		}
	}
	return color / normalisation;
};

render_targets main(screen input)
{
	render_targets output;
	input.uv.y = 1 - input.uv.y;

	output.velocity = mouse.z > 0 ? gaussian_blur(brush, input.uv, brush_size) : output.velocity;
	return output;
}