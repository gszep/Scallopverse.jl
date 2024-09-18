cbuffer variables : register(b0)
{
	int width;
	int height;
	float delta;
	float2 viewport_size;
	float evaporation;
};

static const float2 d = 1 / float2(width, height);

RWTexture2D<float4> brush : register(u0);
Texture2D render_target : register(t0);
SamplerState state : register(s0);


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

[numthreads(8, 8, 1)] void main(uint3 id : SV_DispatchThreadID)
{
	if (id.x >= width || id.y >= height)
	{
		return;
	}

	brush[id.xy] = min(1, brush[id.xy] + gaussian_blur(render_target, id.xy * d));
	brush[id.xy] = max(0, brush[id.xy] - evaporation * delta);
	
}