cbuffer ConstantBuffer : register(b0)
{
    float4x4 matFinal;
	float3 cameraPos;
	float padding;
}

cbuffer worldBuffer	   : register(b1)
{
    float4x4 matWorld;
}

struct DirectionalLight
{
	float4 Ambient;
	float4 Diffuse;
	float4 Specular;
	float4 Direction;
	float  SpecPower;
	float3 pad;
};


cbuffer DirectionalLight : register(b2)
{
	struct DirectionalLight dirLight[2];
};

struct PointLight
{
	float4 Ambient;
	float4 Diffuse;
	float4 Specular;

	// Packed into 4D vector: (Position, Range)
	float3 Position;
	float Range;

	// Packed into 4D vector: (A0, A1, A2, Pad)
	float3 Att;
	float Pad; // Pad the last float so we can set an array of lights if we wanted.
};

cbuffer PointLight : register(b3)
{
	struct PointLight pLight[2];
};


Texture2D diffuseTexture[3];
Texture2D normalTexture[3];

struct VOut
{
    float4 posH : SV_POSITION;
    float3 posL : POSITION;
	float3 posW : WORLDPOS;
	float2 Tex	: TEXCOORD;
	float4 norm : NORMAL;
	float3 viewDirection :VIEWDIRECTION;
	int  Texnum : TEXNUM;
};

struct Vin
{
	float4 Pos		: POSITION;
	float4 Normal	: NORMAL;
	float2 Tex		: TEXCOORD;
	int TexNum	    : TEXNUM;
	float4 Tangent	: TANGENT;
	float4 BiNormal	: BINORMAL;
};

SamplerState samLinear
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Wrap;
	AddressV = Wrap;
};

//VOut VShader(float3 position : POSITION, float3 normal : NORMAL, float3 tangent : TANGENT, float2 texcoord : TEXCOORD )
VOut VShader( Vin input )
{
    VOut output;


    output.posH = mul( mul(matFinal, matWorld), input.Pos );

	output.norm = normalize(mul(matWorld, input.Normal));

    output.posL = input.Pos;
	output.Tex = input.Tex;
	output.Texnum = input.TexNum;

	
	output.posW = mul(input.Pos, matWorld);

	output.viewDirection = normalize(cameraPos.xyz - output.posW.xyz);

    return output;
}


float4 PShader(VOut input) : SV_TARGET
{
	float4 textureColor;
    float3 lightDir;
    float lightIntensity;
    float4 color;
    float3 reflection;
    float4 specular;
	float3 diffuse;
	float3 ambient;
	float3 halfway;

	float4 totalAmbient = float4(0.0f, 0.0f, 0.0f, 0.0f);
	float4 totalDiffuse = float4(0.0f, 0.0f, 0.0f, 0.0f);
	float4 totalSpec    = float4(0.0f, 0.0f, 0.0f, 0.0f);


	textureColor = diffuseTexture[0].Sample( samLinear, input.Tex );

	[unroll]
	for(int i = 0; i < 2; i++)
	{
		ambient = dirLight[i].Ambient.xyz;

		//Compute directional lighting
		diffuse = dirLight[i].Diffuse * saturate(dot(input.norm.xyz, -dirLight[i].Direction.xyz));
	
		halfway = normalize(-dirLight[i].Direction.xyz + input.viewDirection);

		specular.xyz = pow(saturate(dot(input.norm.xyz, halfway)), dirLight[i].SpecPower) * dirLight[i].Specular;

		totalAmbient.xyz +=  ambient.xyz;
		totalDiffuse.xyz +=  diffuse.xyz;
		totalSpec.xyz	 +=  specular.xyz;

	}
	
	//Compute point lighting
	float4 pAmbient = float4(0.0f, 0.0f, 0.0f, 0.0f);
	float4 pDiffuse = float4(0.0f, 0.0f, 0.0f, 0.0f);
	float4 pSpec    = float4(0.0f, 0.0f, 0.0f, 0.0f);

	[unroll]
	for(int i = 0; i < 2; i++)
	{

		// The vector from the surface to the light.
		float3 lightVec = pLight[i].Position - input.posW;

		float d = length(lightVec);

		if( d > pLight[i].Range)
		{
			continue;	
		}

		lightVec /= d; 

		pAmbient += pLight[i].Ambient;

		float diffuseFactor = dot(lightVec, input.norm);

		[flatten]
		if( diffuseFactor > 0.0f )
		{
			float3 v         = reflect(-lightVec, input.norm);

			pDiffuse += diffuseFactor * pLight[i].Diffuse;
		}

		float att = 1.0f / dot(pLight[i].Att, float3(1.0f, d, d*d));

		pDiffuse *= att*(d / pLight[i].Range );

	
		float softie = .75;

		if( d < softie*pLight[i].Range )
			pAmbient  *= 1/((d/pLight[i].Range+1)*(d/pLight[i].Range+1));
		if( d > softie*pLight[i].Range )
		{
			pAmbient *= 1/((softie*pLight[i].Range/pLight[i].Range+1)*(softie*pLight[i].Range/pLight[i].Range+1));
			pAmbient *= (pLight[i].Range-d)/(pLight[i].Range-softie*pLight[i].Range);
		}


		

	}	

	totalAmbient.xyz +=  pAmbient.xyz;
		
	totalDiffuse.xyz +=  pDiffuse.xyz;
		
	totalSpec.xyz	 +=  pSpec.xyz;

	color = textureColor*(totalAmbient + totalDiffuse) + totalSpec;

	color.a = 1.0;

    return color;
}


