cbuffer variables : register(b0)
{
	float2 viewport_size;
	float4 mouse;
};

struct gbuffer
{
	float4 position : SV_POSITION;
	float4 normal : NORMAL;
	float4 brush : COLOR;
};

struct render_targets
{
	float4 normal : SV_TARGET0;
	float4 brush : SV_TARGET1;
};

render_targets main(gbuffer input)
{
	render_targets output;
	output.normal.xy = mouse.xy;
	output.normal.w = 1;
	float dist = distance(input.position.xy / viewport_size, mouse.xy);

	if (dist < 0.1)
	{
		output.brush = 1;
	}
	else
	{
		output.brush = 0;
	}
	return output;
}