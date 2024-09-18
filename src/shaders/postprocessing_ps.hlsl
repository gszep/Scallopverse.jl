struct screen
{
	float4 position : SV_POSITION;
	float2 uv : TEXCOORD;
};

Texture2D brush : register(t0);
SamplerState state : register(s0);

struct render_targets
{
	float4 viewport : SV_TARGET0;
};

render_targets main(screen input)
{
	render_targets output;
	input.uv.y = 1 - input.uv.y;

	output.viewport = brush.Sample(state, input.uv);
	return output;
}