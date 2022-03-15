////-------------//
///**RadiantGI**///
//-------------////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////                                               																									*//
//For Reshade 3.0+ PCGI Ver 2.8
//-----------------------------
//                                                                Radiant Global Illumination
//                                                                              +
//                                                                    Subsurface Scattering
// Due Diligence
// Michael Bunnell Disk Screen Space Ambient Occlusion or Disk to Disk SSAO 14.3
// https://developer.nvidia.com/gpugems/gpugems2/part-ii-shading-lighting-and-shadows/chapter-14-dynamic-ambient-occlusion-and
// - Arkano22
//   https://www.gamedev.net/topic/550699-ssao-no-halo-artifacts/
// - Martinsh
//   http://devlog-martinsh.blogspot.com/2011/10/nicer-ssao.html
// - Boulotaur2024
//   https://github.com/PeterTh/gedosato/blob/master/pack/assets/dx9/martinsh_ssao.fx
// Nayar and Oren Simple Scattering Approximations 16.2
//   https://developer.nvidia.com/gpugems/gpugems/part-iii-materials/chapter-16-real-time-approximations-subsurface-scattering
// GDC 2011 – Approximating Translucency for a Fast, Cheap and Convincing Subsurface Scattering Look
//   https://colinbarrebrisebois.com/2011/03/07/gdc-2011-approximating-translucency-for-a-fast-cheap-and-convincing-subsurface-scattering-look/
// Computer graphics & visualization Global Illumination Effects.
// - Christian A. Wiesner
//   https://slideplayer.com/slide/3533454/
//Improved Normal Reconstruction From Depth
// - Turanszkij
//   https://wickedengine.net/2019/09/22/improved-normal-reconstruction-from-depth/
// Upsample Code
// - PETER KL "I think"
//   https://frictionalgames.blogspot.com/2014/01/tech-feature-ssao-and-temporal-blur.html#Code
// TAA Based on my own port of Epics Temporal AA
//   https://de45xmedrsdbp.cloudfront.net/Resources/files/TemporalAA_small-59732822.pdf
// Joined Bilateral Upsampling Filtering
// - Bart Wronski
//   https://bartwronski.com/2019/09/22/local-linear-models-guided-filter/
// - Johannes Kopf | Michael F. Cohen | Dani Lischinski | Matt Uyttendaele
//   https://johanneskopf.de/publications/jbu/paper/FinalPaper_0185.pdf
// Reinhard by Tom Madams
//   http://imdoingitwrong.wordpress.com/2010/08/19/why-reinhard-desaturates-my-blacks-3/
// Generate Noise is Based on this implamentation
//   https://www.shadertoy.com/view/wtsSW4
// Poisson-Disc Sampling Evenly distributed points on a rotated 2D Disk
//   https://www.jasondavies.com/poisson-disc/
// Text rendering code by Hamneggs
//   https://www.shadertoy.com/view/4dtGD2
// A slightly faster buffer-less vertex shader trick by CeeJay.dk
//   https://www.reddit.com/r/gamedev/comments/2j17wk/a_slightly_faster_bufferless_vertex_shader_trick/
// Origina LUT algorithm by Ganossa edited by | MartyMcFly | Otis_Inf | prod80 | - Base LUT texture made by Prod80 Thank you.
//   https://github.com/prod80/prod80-ReShade-Repository/blob/master/Shaders/PD80_LUT_v2.fxh
// SRGB <--> CIELAB CONVERSIONS Ported by Prod80.
//   http://www.brucelindbloom.com/index.html
// Explicit Image Detection using YCbCr Space Color Model for basic Skin Detection
// - JORGE ALBERTO MARCIAL BASILI | GUALBERTO AGUILAR TORRES | GABRIEL SÁNCHEZ PÉREZ3 | L. KARINA TOSCANO MEDINA4 | HÉCTOR M. PÉREZ MEANA
//   http://www.wseas.us/e-library/conferences/2011/Mexico/CEMATH/CEMATH-20.pdf
//
// If I missed any please tell me.
//
// Special Thank You to CeeJay.dk & Dorinte. May the Pineapple Kringle lead you too happiness.
//
// LICENSE
// ============
// Overwatch & Code out side the work of people mention above is licenses under: Attribution-NoDerivatives 4.0 International
//
// You are free to:
// Share - copy and redistribute the material in any medium or format
// for any purpose, even commercially.
//
// The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
// Attribution - You must give appropriate credit, provide a link to the license, and indicate if changes were made.
// You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
//
// NoDerivatives - If you remix, transform, or build upon the material, you may not distribute the modified material.
//
// No additional restrictions - You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.
//
// https://creativecommons.org/licenses/by-nd/4.0
//
// Have fun,
// Written by Jose Negrete AKA BlueSkyDefender <UntouchableBlueSky@gmail.com>, October 2020
// https://github.com/BlueSkyDefender/Depth3D
//
// Notes to the other developers: https://github.com/BlueSkyDefender/AstrayFX
//
// I welcome almost any help that seems to improve the code. But, The changes need to be approved by myself. So feel free to submit changes here on github.
// Things to work on are listed here. Oh if you feel your code changes too much. Just add a preprocessor to section off your code. Thank you.
//
// Better TAA if you know how to do this better change it.Frame-to-frame coherence Is fast enough in my eyes now. but, I know other devs can do better.
// Much sparser sampling is need to hide low poly issues so we need better Smooth Normals code, Bent Normal maps ect.
// Better specular reflections.......... ect.
//
// Oh if you can make a 2nd Bounce almost as fast as One Bounce....... Do it with your magic you wizard.
//
// Write your name and changes/notes below.
// __________________________________________________________________________________________________________________________________________________________________________________
// -------------------------------------------------------------------Around Line 794----------------------------------------------------------------------------------------
// Lord of Lunacy - https://github.com/LordOfLunacy
// Reveil DeHaze Masking was inserted around GI Creation.
// __________________________________________________________________________________________________________________________________________________________________________________
// -------------------------------------------------------------------Around Line 0000---------------------------------------------------------------------------------------
// Dev Name - Repo
// Notes from Dev.
//
//                                                                    Radiant GI Notes
// Upcoming Updates.............................................no guarantee
// Need to add indirect color from the sky.
// Need Past Edge Brightness storage.
//
// Update 1.2
// This update did change a few things here and there like PCGI_Alpha and PCGI_Beta are now PCGI_One and PCGI_Two.
// Error Code edited so it does not show the warning anymore. But, it's still shows the shader name as yellow.¯\_('_')_/¯
// This version has a small perf loss. Also removed some extra code that was not mine. Forgot to replace it my bad.....
// TAA now gives The JBGU shader motion information to blur in motion so there is less noise in motion. :)
//
// Update 2.0
// So reworked the Joint Bilateral Gaussian Upscaling for sharper Debug and fewer artifacts in motion. Now I am using a plain
// old box blur it seems to run faster and look sharper at masking high frequency noise. Also reworked how to sample the GI.
// Radiant Global Illumination now uses a proper Poisson Disk Sampling. This kind of sampling should improve the accuracy of GI displayed.
// Shader motion information removed for now to get this out by the deadline around Xmas time. Some Defaults and max setting were changed.
// Subsurface Scattering AKA Subsurface Light Transport Added. This feature is heavy. But, should be doable to find/look for Flesh in an image.
// Once found it will try to add SSS with Diffusion Blur to give skin that soft look to it. This was a lot harder than expected...............
// It Just works well most of the time...... Just issues come up with some games with earthy tones. I will allow an option to apply SSS to everything later.
// I was also able to do thickness estimation this lets things like ears and other thin/dangly parts to allow Deep Tissue Scattering. So Deep.....
// So all in all this was capable of being done. The Thickness estimation may cause issues on White objects that trigger the Skin Detection so be warned.
// This shader not done. But, it is close.
//
// Update 2.1
// Small changes to help guide the user a bit more with SSLT.
//
// Update 2.2
// More Pooled Texture issues. Black screen is shown when Pooling some textures. Issue now is that this shader uses around 605.0 MiB at 4k......
// Need to talk to the main man about this. When time allows.
//
// Update 2.3
// Added a way to control the Subsurface Scattering Brightness.
//
// Update 2.4
// Added a way to control Diffusion profile for added Reflectivness. Notices a bad bug with TAA not working in some game I need to find out why.
//
// Update 2.5
// Changed the way I am doing my 2nd Denoiser. Also reworked the Saturation system and the HDR extraction.
// Targeted lighting works as intended now. Indirect and Direct world color sampling. 
// RadiantGI now has a pure GI mode that runs 2x times as slow but, gives 2x times more control.
// This mode disables SSLT. So keep that in mind.
//
// Update 2.6
// Added a way to force pooling off for 4.9.0+ and small perf boost. 
//
// Update 2.7
//
// Improved Normal smoothing on my 2nd Denoiser and looser setting on my TAA solution should get most of the noise in motion.
// Tested an Edge-Avoiding À-Trous Wavelet Transform Denoiser that was  "Fast." But, My own solution was faster and got rid of more noise.
// All I can say is that I learned a lot about 2nd level Denoisers. I think I will be ready to may my own AO shader now.
// For now enjoy this update.
//
// TLDR: Better Normal smoothing and noise removal in motion.
//
// Update 2.8
//
// I targeted Diffusion to work on the floors only. Because having it affect everything was not correct to me. I also Made the Debug View a bit cleaner.
// With The cleaner Debug you  will see more detail. But, It will not cause the final output to show normal edges even if you see them in the Debug View.
// I also made the De-Noiser go up to 20 now so........ Ya...... At any rate it better now!!!!! 
//
// Please Enjoy!
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#if exists "Overwatch.fxh"                                           //Overwatch Interceptor//
	#include "Overwatch.fxh"
	#define OS 0
#else// DA_Y = [Depth Adjust] DA_Z = [Offset] DA_W = [Depth Linearization] DB_X = [Depth Flip]
	static const float DA_Y = 7.5, DA_Z = 0.0, DA_W = 0.0, DB_X = 0;
	// DC_X = [Barrel Distortion K1] DC_Y = [Barrel Distortion K2] DC_Z = [Barrel Distortion K3] DC_W = [Barrel Distortion Zoom]
	static const float DC_X = 0, DC_Y = 0, DC_Z = 0, DC_W = 0;
	// DD_X = [Horizontal Size] DD_Y = [Vertical Size] DD_Z = [Horizontal Position] DD_W = [Vertical Position]
	static const float DD_X = 1, DD_Y = 1, DD_Z = 0.0, DD_W = 0.0;
	//Triggers
	static const int RE = 0, NC = 0, RH = 0, NP = 0, ID = 0, SP = 0, DC = 0, HM = 0, DF = 0, NF = 0, DS = 0, LBC = 0, LBM = 0, DA = 0, NW = 0, PE = 0, FV = 0, ED = 0;
	//Overwatch.fxh State
	#define OS 1
#endif

//Keep in mind you are not licenced to redistribute this shader with setting modified below. Please Read the Licence.
//This GI shader is free and shouldn't sit behind a paywall. If you paid for this shader ask for a refund right away.

//Generated Ray Resolution
#define Automatic_Resolution_Scaling 1 //[Off | On] This is used to enable or disable Automatic Resolution Scaling. Default is On.
#define RSRes 0.5              //[0.5 - 1.0]        Noise start too takes over around 0.666 at 1080p..... Higher the res lower the noise.

//Depth Buffer Adjustments
#define DB_Size_Position 0     //[Off | On]         This is used to reposition and the size of the depth buffer.
#define BD_Correction 0        //[Off | On]         Barrel Distortion Correction for non conforming BackBuffer.

//TAA Quality Level
#define TAA_Clamping 0.2      //[0.0 - 1.0]         Use this to adjust TAA clamping.

//Other Settings
#define MaxDepth_Cutoff 0.999 //[0.1 - 1.0]         Used to cutout the sky with depth buffer masking. This lets the shader save on performance by limiting what is used in GI.
#define Controlled_Blend 0    //[Off | On]          Use this if you want control over blending GI in to the final
#define Dark_Mode 0           //[Off | On]          Instead of using a 50% gray it displays Black for the absence of information.
#define Text_Info_Key 122     //F11 Key             Text Information Key Default 122 is the F11 Key. You can use this site https://keycode.info to pick your own.
#define Disable_Debug_Info 0  //[Off | On]          Use this to disable help information that gives you hints for fixing many games with Overwatch.fxh.
#define Minimize_Web_Info 0   //[Off | On]          Use this to minimize the website logo on startup.
#define ForcePool 0           //[Off | On]          Force Pooled Textures in versions 4.9.0+ If you get a black screen turn this too off. Seems to be a ReShade Issue.

//RadiantGI Extended          //Still WIP!!!
#ifndef PureGI_Mode
	#define PureGI_Mode 0     //[Off | On]          Use this to set a Pure GI Mode for RadiantGI this disables SSS/SSLT effects and is heavy on performance.
#endif

//Keep in mind you are not licenced to redistribute this shader with setting modified below. Please Read the Licence.
//This GI shader is free and shouldn't sit behind a paywall. If you paid for this shader ask for a refund right away.

//Non User settings.
#if exists "IsolateSkintones.png"                                //Look Up Table Interceptor//
	#define  LUT_File_Name      "IsolateSkintones.png" //Base Texture also made by Prod80
	#define  Tile_SizeXY        64
	#define  Tile_Amount        64
	#define LutSD 1
#else // Texture name which contains the LUT(s) and the Tile Sizes, Amounts, etc. by Prod80
	#define LutSD 0
#endif
static const float  MixChroma = 2.0;         //LUT Chroma 0-1
static const float  MixLuma = 1.0;           //LUT Luma 0-1
static const float  Intensity = 1.5;         //LUT Intensity 0-1
static const float3 ib = float3(0.0,0.0,0.0);//LUT Black IN Level
static const float3 iw = float3(1.0,1.0,1.0);//LUT White IN Level
static const float3 ob = float3(0.0,0.0,0.0);//LUT Black OUT Level
static const float3 ow = float3(1.0,1.0,1.0);//LUT White OUT Level
static const float ig = 1.0;                 //LUT Gamma Adjustment 0.05 - 10.0
//Use for real HDR. //Do not Use.
#define HDR_Toggle 0 //For HDR //Do not Use.
//Pooled Texture Issue for 4.8.0
#if __RESHADE__ >= 40910 && ForcePool
	#define PoolTex < pooled = true; >
#else
	#define PoolTex
#endif
//ReVeil Intragration
#if exists "ReVeil.fx"
	#define Look_For_Buffers_ReVeil 1
#if __RESHADE__ <= 40700 //Needed to do this Because how the warning system in reshade changed from under me. :( Wish the Shader name didn't change to yellow.:(
	#warning "ReVeil.fx Detected! Yoink! Took your Transmission Buffer"
#endif
#else
	#define Look_For_Buffers_ReVeil 0
#endif
//Help / Guide Information stub uniform a idea from LucasM
uniform int RadiantGI <
	ui_text = "RadiantGI is an indirect lighting algorithm based on the disk-to-disk radiance transfer by Michael Bunnell.\n"
			  		"As you can tell its name is a play on words and it radiates the kind of feeling I want from it one Ray Bounce at a time.\n"
			  			  "This GI shader is free and shouldn't sit behind a paywall. If you paid for this shader ask for a refund right away.\n"
			  			  		"As for my self I do want to provide the community with free shaders and any donations will help keep that motivation alive.\n"
			  			  			  "For more information and help please feel free to visit http://www.Depth3D.info or https://blueskydefender.github.io/AstrayFX\n "
			  			  			 	 "Help with this shader fuctions specifically visit the WIki @ https://github.com/BlueSkyDefender/AstrayFX/wiki/RadiantGI\n"
			  "Please enjoy this shader and Thank You for using RadiantGI.";
	ui_category = "RadiantGI";
	ui_category_closed = true;
	ui_label = " ";
	ui_type = "radio";
>;

uniform float samples <
	ui_type = "slider";
	ui_min = 2; ui_max = 11; ui_step = 1;
	ui_label = "Samples";
	ui_tooltip = "GI Sample Quantity is used to increase samples amount as a side effect this reduces noise.";
	ui_category = "PCGI";
> = 6;
#if PureGI_Mode
uniform float2 GI_Ray_Length <
#else
uniform float GI_Ray_Length <
#endif
	ui_type = "drag";
	ui_min = 1.0; ui_max = 250; ui_step = 1;
	ui_label = "General Ray Length";
	ui_tooltip = "General GI Ray Length adjustment is used to increase the Ray Casting Distance.\n"
			     "This scales automatically with multi level detail.";
	ui_category = "PCGI";
> = 75;

uniform float Target_Lighting <
	ui_type = "slider";
	ui_min = 0.0; ui_max = 1.0;
	ui_label = "Target Lighting";
	ui_tooltip = "Lets you Target the brightest part of the image and use that only for GI.\n"
			     "Defaults is [0.05] and Zero is off.";
	ui_category = "PCGI";
> = 0.05;

uniform float2 NCD <
	ui_type = "slider";
	ui_min = 0.0; ui_max = 1.0;
	ui_label = "Near Details";
	ui_tooltip = "Lets you adjust detail of objects near the cam and or like weapon hand GI.\n"
			     "The 2nd Option is for Weapon Hands in game that fall out of range.\n"
			     "Defaults are [Near Details X 0.125] [Weapon Hand Y 0.0]";
	ui_category = "PCGI";
> = float2(0.125,0.0);

uniform float Reflectivness <
	ui_type = "slider";
	ui_min = 0.0; ui_max = 1.0;
	ui_label = "Diffusion Amount";
	ui_tooltip = "This basicly adds control for how defused the lighting should be AKA Reflectivness.\n"
			     "Default is [1.0] and One is Max Diffusion.";
	ui_category = "PCGI";
> = 1.0;

uniform float Trim <
	ui_type = "slider";
	ui_min = 0.0; ui_max = 2.5;
	ui_label = "Trimming";
	ui_tooltip = "Trim GI by limiting how far the GI is able to effect the surrounding objects.\n"
			     "Default is [0.250] and Zero is Off.";
	ui_category = "PCGI";
> = 0.25;
#if PureGI_Mode
static const bool Scattering = false;
static const float Wrap = 0.5;
static const float User_SSS_Luma = 0.5;
static const float Deep_Scattering = 0.1;
static const float4 Internals = float4(0.333,0.0,0.0,0.5);
static const float Diffusion_Power = 0.5;
static const float2 SSS_Seek = 0.5;
#else
	uniform bool Scattering<
		ui_label = "Subsurface Light Transport";
		ui_tooltip = "Enable The Subsurface Light Transport Function to create a Subsurface Scattering effect.\n"
				     "Default is Off.";
		ui_category = "SSLT";
	> = false;
	
	uniform float Wrap <
		ui_type = "slider";
		ui_min = 0.0; ui_max = 1.0;
		ui_label = "Upper Scattering";
		ui_tooltip = "Control the Light Wrap Form Factor to adjust the Subsurface Scattering effect.\n"
				     "Default is [0.5].";
		ui_category = "SSLT";
	> = 0.5;
	
	uniform float User_SSS_Luma <
		ui_type = "slider";
		ui_min = 0.0; ui_max = 1.0;
		ui_label = "Subsurface Brightness";
		ui_tooltip = "This is used to fine tune the automatic brightness of the upper layer scattering.\n"
				     "Can be set from Zero to One.\n"
				     "Default is [0.5].";
		ui_category = "SSLT";
	> = 0.5;
	
	uniform float Deep_Scattering <
		ui_type = "slider";
		ui_min = 0.0; ui_max = 1.0;
		ui_label = "Deep Scattering";
		ui_tooltip = "Control Thickness Estimation Form Factor to create a Deep Tissue Scattering effect.\n"
				     "Default is [0.1].";
		ui_category = "SSLT";
	> = 0.1;
	
	uniform float4 Internals < // We are all pink and fleshy on the inside?
		ui_type = "slider";
		ui_min = 0.0; ui_max = 1.0;
		ui_label = "Internal Color & Luma Map";
		ui_tooltip = "Since I can't tell what the internal color of the Deep Tissue you need to set this your self for RGB.\n"
				     "The last one controls the Luma Map that lets bright lights approximate deep tissue color.\n"
				     "Defaults are [R 0.333] [B 0.0] [G 0.0] [L 0.5].";
		ui_category = "SSLT";
	> = float4(0.333,0.0,0.0,0.5);
	
	uniform float Diffusion_Power <
		ui_type = "slider";
		ui_min = 0.0; ui_max = 1.0;
		ui_label = "Subsurface Blur";
		ui_tooltip = "Diffusion Blur is used too softens the lighting and makes the person a little more realistic by mimicking this effect skin has on light.\n"
				     "Simulate light diffusion favor red blurring over other colors.\n"
				     "Default is [0.5].";
		ui_category = "SSLT";
	> = 0.5;
	
	#if LutSD //Man............................................
	uniform float2 SSS_Seek <
	#else
	uniform float SSS_Seek <
	#endif
		ui_type = "slider";
		ui_min = 0.0; ui_max = 1.0;
	#if LutSD
		ui_label = "Skin Detect Distance & Seeking";
	#else
		ui_label = "Skin Detect Distance";
	#endif
		ui_tooltip = "Lets you control how far we need to search and seek with the human skin tone detection algorithm for SSLT.\n"
	#if LutSD
				     "Defaults are [0.25] and [0.5].";
	#else
					 "The 2nd option only shows if you use the special LUT for custom and or more accurate skin tone detection.\n"
					 "You can get this LUT @ https://github.com/BlueSkyDefender/AstrayFX/wiki/Subsurface-Light-Transport\n"
				     "Default is [0.25].";
	#endif
		ui_category = "SSLT";
	#if LutSD
	> = float2(0.25,0.5);
	#else
	> = 0.25;
	#endif
#endif

#if Controlled_Blend
uniform float Blend <
	ui_type = "slider";
	ui_min = 0.0; ui_max = 1.0;
	ui_label = "Blend";
    ui_tooltip = "Use this to change the look of GI when applied to the final image.";
    ui_category = "Image";
> = 0.5;
#else
uniform int BM <
	ui_type = "combo";
    ui_label = "Blend Mode";
    ui_tooltip = "Use this to change the look of GI when applied to the final image.";
    ui_items = "Mix\0Overlay\0Softlight\0Add\0";
    ui_category = "Image";
    > = 0;
#endif
#if PureGI_Mode
uniform float2 GI_Power <
#else
uniform float GI_Power <
#endif
	ui_type = "slider";
	ui_min = 0.0; ui_max = 5.0;
	ui_label = "Power";
	ui_tooltip = "Main overall GI application power control.\n"
			     "Default is [Power 1.0].";
	ui_category = "Image";
> = 1.0;
#if PureGI_Mode
uniform float2 Saturation <
#else
uniform float Saturation <
#endif
	ui_type = "slider";
	ui_min = 0.0; ui_max = 2.0;
	ui_label = "Saturation";
	ui_tooltip = "Irradiance Map Saturation.";
	ui_category = "Image";
> = 1.0;
//Lord of Lunacy says white power would be bad.
uniform float GI_LumaPower <

	ui_type = "slider";
	ui_min = 0.0; ui_max = 1.0;
	ui_label = "Luma Power";
	ui_tooltip = "Control the white strength in the image.\n"
			     "Default is [0.5].";
	ui_category = "Image";
> = 0.5;

uniform float GI_Fade < //Blame the pineapple for this option.
	ui_type = "slider";
	ui_min = 0.0; ui_max = 1.0; //Still need to make this better......
	ui_label = "Depth Fade";
	ui_tooltip = "GI Application Power that is based on Depth scaling for controlled fade In-N-Out.\n" //That's What A Hamburger's All About
			     "Can be set from 0 to 1 and is Set to Zero for No Culling.\n"
			     "Default is 0.0.";
	ui_category = "Image";
> = 0.0;

uniform float HDR_BP <
	ui_type = "slider";
	ui_min = 0.0; ui_max = 1.0;
	ui_label = "HDR Extraction Power";
	ui_tooltip = "Use This to adjust the HDR Power, You can override this value and set it to like 1.5 or something.\n"
				 "Dedault is 0.5 and Zero is Off.";//Because new HDR extraction works well now.
	ui_category = "Image";
> = 0.5;

uniform bool Clamp_Out <
	ui_label = "Clamp Output";
	ui_tooltip = "This clamps the output of RadiantGI to prevent over Blooming.";
	ui_category = "Image";
> = false;

uniform int Depth_Map <
	ui_type = "combo";
	ui_items = "DM0 Normal\0DM1 Reversed\0";
	ui_label = "Depth Map Selection";
	ui_tooltip = "Linearization for the zBuffer also known as Depth Map.\n"
			     "DM0 is Z-Normal and DM1 is Z-Reversed.\n";
	ui_category = "Depth Map";
> = DA_W;

uniform float Depth_Map_Adjust <
	ui_type = "drag";
	ui_min = 1.0; ui_max = 250.0;
	ui_label = "Depth Map Adjustment";
	ui_tooltip = "This allows for you to adjust the DM precision.\n"
				 "Adjust this to keep it as low as possible.\n"
				 "Default is 7.5";
	ui_category = "Depth Map";
> = DA_Y;
uniform float Offset <
	ui_type = "drag";
	ui_min = -1.0; ui_max = 1.0;
	ui_label = "Depth Map Offset";
	ui_tooltip = "Depth Map Offset is for non conforming ZBuffer.\n"
				 "It is rare that you would need to use this option.\n"
				 "Use this to make adjustments to DM 0 or DM 1.\n"
				 "Default and starts at Zero and it is Off.";
	ui_category = "Depth Map";
> = DA_Z;
uniform bool Depth_Map_Flip <
	ui_label = "Depth Map Flip";
	ui_tooltip = "Flip the depth map if it is upside down.";
	ui_category = "Depth Map";
> = DB_X;
uniform int Debug <
	ui_type = "combo";
	ui_items = "RadiantGI\0Irradiance Map\0Depth & Normals\0";
	ui_label = "Debug View";
	ui_tooltip = "View Debug Buffers.";
	ui_category = "Extra Options";
> = 0;

uniform int SamplesXY <
	ui_type = "slider";
	ui_min = 0; ui_max = 20;
	ui_label = "Smoohting Amount";//Ya CeeJay.dk you got your way..
	ui_tooltip = "This raises or lowers Samples used for the Final DeNoisers which in turn affects Performance.\n"
				 "This also has the side effect of smoothing out the image so you get that Normal Like Smoothing.\n"
				 "Default is 8 and you can override this a bit.";
	ui_category = "Extra Options";
> = 8;

#if Look_For_Buffers_ReVeil
	uniform bool UseReVeil<
		ui_label = "Use Transmission from ReVeil";
		ui_tooltip = "Requires ReVeil to be enabled (Lord of Lunacy waz here)";
		ui_category = "Extra Options";
	> = true;
#endif
#if DB_Size_Position || SP == 2
uniform float2 Horizontal_and_Vertical <
	ui_type = "drag";
	ui_min = 0.0; ui_max = 2;
	ui_label = "Horizontal & Vertical Size";
	ui_tooltip = "Adjust Horizontal and Vertical Resize. Default is 1.0.";
	ui_category = "Depth Corrections";
> = float2(DD_X,DD_Y);
uniform float2 Image_Position_Adjust<
	ui_type = "drag";
	ui_min = -1.0; ui_max = 1.0;
	ui_label = "Horizontal & Vertical Position";
	ui_tooltip = "Adjust the Image Position if it's off by a bit. Default is Zero.";
	ui_category = "Depth Corrections";
> = float2(DD_Z,DD_W);
#else
static const float2 Horizontal_and_Vertical = float2(DD_X,DD_Y);
static const float2 Image_Position_Adjust = float2(DD_Z,DD_W);
#endif
#if BD_Correction
uniform int BD_Options <
	ui_type = "combo";
	ui_items = "On\0Off\0";
	ui_label = "Distortion Options";
	ui_tooltip = "Use this to Turn BD Off or On.\n"
				 "Default is ON.";
	ui_category = "Depth Corrections";
> = 0;

uniform float3 Colors_K1_K2_K3 <
	#if Compatibility
	ui_type = "drag";
	#else
	ui_type = "slider";
	#endif
	ui_min = -2.0; ui_max = 2.0;
	ui_tooltip = "Adjust the Distortion K1, K2, & K3.\n"
				 "Default is 0.0";
	ui_label = "BD K1 K2 K3";
	ui_category = "Depth Corrections";
> = float3(DC_X,DC_Y,DC_Z);
uniform float Zoom <
	ui_type = "drag";
	ui_min = -0.5; ui_max = 0.5;
	ui_label = "BD Zoom";
	ui_category = "Depth Corrections";
> = DC_W;
#else
	#if DC
	uniform bool BD_Options <
		ui_label = "Toggle Barrel Distortion";
		ui_tooltip = "Use this if you modded the game to remove Barrel Distortion.";
	ui_category = "Depth Corrections";
	> = !true;
	#else
		static const int BD_Options = 1;
	#endif
static const float3 Colors_K1_K2_K3 = float3(DC_X,DC_Y,DC_Z);
static const float Zoom = DC_W;
#endif
#if BD_Correction || DB_Size_Position
	uniform bool Depth_Guide <
		ui_label = "Alinement Guide";
		ui_tooltip = "Use this for a guide for alinement.";
	ui_category = "Depth Corrections";
	> = !true;
#else
		static const int Depth_Guide = 0;
#endif
//This GI shader is free and shouldn't sit behind a paywall. If you paid for this shader ask for a refund right away.
#if Automatic_Resolution_Scaling //Automatic Adjustment based on Resolutionsup to 4k considered. LOL good luck with 8k in 2020
	#undef RSRes
	#if (BUFFER_HEIGHT <= 720)
		#define RSRes 1.0
	#elif (BUFFER_HEIGHT <= 1080)
		#define RSRes 0.7
	#elif (BUFFER_HEIGHT <= 1440)
		#define RSRes 0.6
	#elif (BUFFER_HEIGHT <= 2160)
		#define RSRes 0.5
	#else
		#define RSRes 0.4 //??? 8k Mystery meat
	#endif
#endif
//This GI shader is free and shouldn't sit behind a paywall. If you paid for this shader ask for a refund right away.
uniform bool Text_Info < source = "key"; keycode = Text_Info_Key; toggle = true; mode = "toggle";>;
#define pix float2(BUFFER_RCP_WIDTH, BUFFER_RCP_HEIGHT)
uniform float frametime < source = "frametime"; >;     // Time in milliseconds it took for the last frame to complete.
uniform int framecount < source = "framecount"; >;     // Total amount of frames since the game started.
uniform float timer < source = "timer"; >;             // A timer that starts when the Game starts.
#define Alternate framecount % 2 == 0                  // Alternate per frame
#define PI 3.14159265358979323846264                   // PI
#if LutSD //Extracted Look Up Table
texture TexName < source =  LUT_File_Name; > { Width =  Tile_SizeXY *  Tile_Amount; Height =  Tile_SizeXY ; };
sampler Sampler { Texture =  TexName; };
#endif
float2 GIRL()
{
	#if PureGI_Mode
		return  float2(GI_Ray_Length.x,GI_Ray_Length.y);
	#else
		return  float2(GI_Ray_Length,250);
	#endif
}
static const float EvenSteven[21] = { 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20 , 22, 24, 26, 28, 30, 32, 34, 36, 38, 40}; // It's not odd...
/////////////////////////////////////////////////////D3D Starts Here/////////////////////////////////////////////////////////////////
static const float2 XYoffset[8] = { float2( 0,+pix.y ), float2( 0,-pix.y), float2(+pix.x, 0), float2(-pix.x, 0), float2(-pix.x,-pix.y), float2(+pix.x,-pix.y), float2(-pix.x,+pix.y), float2(+pix.x,+pix.y) };
static const float DBoffsets[7] = { -5.5, -3.5, -1.5, 0.0, 1.5, 3.5, 5.5 };
//Diffusion Blur weights to blur red channel more than green and blue SSS
static const float3 DBweight[7] = { float3( 0.006, 0.00, 0.00),
									float3( 0.061, 0.00, 0.00),
									float3( 0.242, 0.25, 0.25),
									float3( 0.383, 0.50, 0.50),
									float3( 0.242, 0.25, 0.25),
									float3( 0.061, 0.00, 0.00),
									float3( 0.006, 0.00, 0.00) };
//Poisson Disk Precompute
static const float2 PoissonTaps[12] = { float2(-0.326,-0.406), //This Distribution seems faster.....
										float2(-0.840,-0.074), //Tried many from https://github.com/bartwronski/PoissonSamplingGenerator
										float2(-0.696, 0.457), //But they seems slower then this one I found online..... WTF
										float2(-0.203, 0.621),
										float2( 0.962,-0.195),
										float2( 0.473,-0.480),
										float2( 0.519, 0.767),
										float2( 0.185,-0.893),
										float2( 0.507, 0.064),
										float2( 0.896, 0.412),
										float2(-0.322,-0.933),
										float2(-0.792,-0.598) };

float fmod(float a, float b)
{
	float c = frac(abs(a / b)) * abs(b);
	return a < 0 ? -c : c;
}

void MCNoise(inout float Noise, float FC ,float2 TC,float seed)
{   //This is the noise I used for rendering
	float motion = FC, a = 12.9898, b = 78.233, c = 43758.5453, dt = dot( TC.xy * 2.0 , float2(a,b)), sn = fmod(dt,PI);
	Noise = frac(frac(tan(distance(sn*(seed+dt),  float2(a,b)  )) * c) + 0.61803398875f * motion);
}

float gaussian(float x, float sigma)
{
    return (1.0 / sqrt( PI * pow(sigma,2))) * exp(-(pow(x,2) / (2.0 * pow(sigma,2))));
}

#if BD_Correction || DC
float2 D(float2 p, float k1, float k2, float k3) //Lens + Radial lens undistort filtering Left & Right
{   // Normalize the u,v coordinates in the range [-1;+1]
	p = (2. * p - 1.);
	// Calculate Zoom
	p *= 1 + Zoom;
	// Calculate l2 norm
	float r2 = p.x*p.x + p.y*p.y;
	float r4 = r2 * r2;
	float r6 = r4 * r2;
	// Forward transform
	float x2 = p.x * (1. + k1 * r2 + k2 * r4 + k3 * r6);
	float y2 = p.y * (1. + k1 * r2 + k2 * r4 + k3 * r6);
	// De-normalize to the original range
	p.x = (x2 + 1.) * 1. * 0.5;
	p.y = (y2 + 1.) * 1. * 0.5;

return p;
}
#endif
float3 RGBtoYCbCr(float3 rgb)
{   float C[1];//The Chronicles of Riddick: Assault on Dark Athena FIX I don't know why it works.......
	float Y  =  .299 * rgb.x + .587 * rgb.y + .114 * rgb.z; // Luminance
	float Cb = -.169 * rgb.x - .331 * rgb.y + .500 * rgb.z; // Chrominance Blue
	float Cr =  .500 * rgb.x - .419 * rgb.y - .081 * rgb.z; // Chrominance Red
	return float3(Y,Cb + 128./255.,Cr + 128./255.);
}

float3 YCbCrtoRGB(float3 ycc)
{
	float3 c = ycc - float3(0., 128./255., 128./255.);

	float R = c.x + 1.400 * c.z;
	float G = c.x - 0.343 * c.y - 0.711 * c.z;
	float B = c.x + 1.765 * c.y;
	return float3(R,G,B);
}

//----------------------------------Inverse ToneMappers--------------------------------------------
float Luma(float3 C)
{
	float3 Luma;

	if (HDR_Toggle == 0)
	{
		Luma = float3(0.2126, 0.7152, 0.0722); // (HD video) https://en.wikipedia.org/wiki/Luma_(video)
	}
	else
	{
		Luma = float3(0.2627, 0.6780, 0.0593); // (HDR video) https://en.wikipedia.org/wiki/Rec._2100
	}

	return dot(C,Luma);
}

float max3(float x, float y, float z)
{
    return max(x, max(y, z));
}

float3 inv_Tonemapper(float4 color)
{   //Timothy Lottes fast_reversible
	return color.rgb * rcp((1.0 + max(color.w,0.001)) - max3(color.r, color.g, color.b));
}

float3 Saturator_A(float3 C)
{	
	return lerp(Luma(C.rgb), C.rgb, Saturation.x );
}
float3 Saturator_B(float3 C)
{	
	#if PureGI_Mode
	return lerp(Luma(C.rgb), C.rgb, Saturation.y );
	#else
	return 0;
	#endif
}

float3 InternalFleshColor(float3 SSS, float Density, float3 Internal, float LumProfile)
{   float3 D = Density * LumProfile;
	return SSS + lerp(D * Internal,0,saturate(SSS));
}
//// Skin Functions /////////////////////////////////////////////////// -- Ported by BSD from  02_Isolate_SkinTones.fx
#if LutSD
float3 levels( float3 color, float3 blackin, float3 whitein, float gamma, float3 outblack, float3 outwhite )
{
    float3 ret       = saturate( color.xyz - blackin.xyz ) / max( whitein.xyz - blackin.xyz, 0.000001f );
    ret.xyz          = pow( ret.xyz, gamma );
    ret.xyz          = ret.xyz * saturate( outwhite.xyz - outblack.xyz ) + outblack.xyz;
    return ret;
}

// SRGB <--> CIELAB CONVERSIONS Ported by Prod80.

// Reference white D65
#define reference_white     float3( 0.95047, 1.0, 1.08883 )

// Source
// http://www.brucelindbloom.com/index.html?Eqn_RGB_to_XYZ.html

#define K_val               float( 24389.0 / 27.0 )
#define E_val               float( 216.0 / 24389.0 )

float3 xyz_to_lab( float3 c )
{
    // .xyz output contains .lab
    float3 w       = c / reference_white;
    float3 v;
    v.x            = ( w.x >  E_val ) ? pow( abs(w.x), 1.0 / 3.0 ) : ( K_val * w.x + 16.0 ) / 116.0;
    v.y            = ( w.y >  E_val ) ? pow( abs(w.y), 1.0 / 3.0 ) : ( K_val * w.y + 16.0 ) / 116.0;
    v.z            = ( w.z >  E_val ) ? pow( abs(w.z), 1.0 / 3.0 ) : ( K_val * w.z + 16.0 ) / 116.0;
    return float3( 116.0 * v.y - 16.0,
                   500.0 * ( v.x - v.y ),
                   200.0 * ( v.y - v.z ));
}

float3 lab_to_xyz( float3 c )
{
    float3 v;
    v.y            = ( c.x + 16.0 ) / 116.0;
    v.x            = c.y / 500.0 + v.y;
    v.z            = v.y - c.z / 200.0;
    return float3(( v.x * v.x * v.x > E_val ) ? v.x * v.x * v.x : ( 116.0 * v.x - 16.0 ) / K_val,
                  ( c.x > K_val * E_val ) ? v.y * v.y * v.y : c.x / K_val,
                  ( v.z * v.z * v.z > E_val ) ? v.z * v.z * v.z : ( 116.0 * v.z - 16.0 ) / K_val ) *
                  reference_white;
}

float3 srgb_to_xyz( float3 c )
{
    // Source: http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
    // sRGB to XYZ (D65) - Standard sRGB reference white ( 0.95047, 1.0, 1.08883 )
    const float3x3 mat = float3x3(
    0.4124564, 0.3575761, 0.1804375,
    0.2126729, 0.7151522, 0.0721750,
    0.0193339, 0.1191920, 0.9503041
    );
    return mul( mat, c );
}

float3 xyz_to_srgb( float3 c )
{
    // Source: http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
    // XYZ to sRGB (D65) - Standard sRGB reference white ( 0.95047, 1.0, 1.08883 )
    const float3x3 mat = float3x3(
    3.2404542,-1.5371385,-0.4985314,
   -0.9692660, 1.8760108, 0.0415560,
    0.0556434,-0.2040259, 1.0572252
    );
    return mul( mat, c );
}
// Maximum value in LAB, B channel is pure blue with 107.8602... divide by 108 to get 0..1 range values
// Maximum value in LAB, L channel is pure white with 100
float3 srgb_to_lab( float3 c )
{
    float3 lab =  srgb_to_xyz( c );
    lab        =  xyz_to_lab( lab );
    return lab / float3( 100.0, 108.0, 108.0 );
}

float3 lab_to_srgb( float3 c )
{
    float3 rgb =  lab_to_xyz( c * float3( 100.0, 108.0, 108.0 ));
    rgb        =  xyz_to_srgb( max( min( rgb, reference_white ), 0.0 ));
    return saturate( rgb );
}
#endif
float  SkinDetection(float4 color)
{   //Can Also mask out the sky or things that are too far.......
	float3 YCbCr = RGBtoYCbCr(color.rgb) * 255.0;
	//So after exhaustive image histogram analysis, the optimal range threshold is....
	#if LutSD
	//Prod80 Port of Skin Isolation for RadiantGI
    float2 texelsize = rcp( Tile_SizeXY );
    texelsize.x     /=  Tile_Amount;

    float3 lutcoord  = float3(( color.xy * Tile_SizeXY - color.xy + 0.5f ) * texelsize.xy, color.z * Tile_SizeXY - color.z );
    float lerpfact   = frac( lutcoord.z );
    lutcoord.x      += ( lutcoord.z - lerpfact ) * texelsize.y;

    float3 lutcolor  = lerp( tex2D(  Sampler, lutcoord.xy ).xyz, tex2D(  Sampler, float2( lutcoord.x + texelsize.y, lutcoord.y )).xyz, lerpfact );
    lutcolor.xyz     = levels( lutcolor.xyz,    saturate( ib.xyz  ),
                                                saturate( iw.xyz  ),
                                                ig,
                                                saturate( ob.xyz  ),
                                                saturate( ow.xyz  ));
    float3 lablut    = srgb_to_lab( lutcolor.xyz );
    float3 labcol    = srgb_to_lab( color.xyz );
    float newluma    = lerp( labcol.x, lablut.x,  MixLuma );
    float2 newAB     = lerp( labcol.yz, lablut.yz,  MixChroma );
    lutcolor.xyz     = lab_to_srgb( float3( newluma, newAB ));
    color.xyz        = lerp( color.xyz, saturate( lutcolor.xyz  ),  Intensity );
	float Fin        = dot(color.xyz,color.xyz);
	if(Fin > SSS_Seek.y)
		return 1.0;
	else
		return 0.0;
	#else
    if (YCbCr.y > 80 && YCbCr.y < 118 && YCbCr.z > 133 && YCbCr.z < 173)
		return 0.0;
	else
		return 1.0;
	#endif
}
/////////////////////////////////////////////////////Texture Samplers////////////////////////////////////////////////////////////////
texture DepthBufferTex : DEPTH;

sampler ZBuffer
	{
		Texture = DepthBufferTex;
	};

texture BackBufferTex : COLOR;

sampler BackBufferPCGI
	{
		Texture = BackBufferTex;
	};

texture2D PCGIpastTex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA16f; MipLevels = 5;};
sampler2D PCGIpastFrame { Texture = PCGIpastTex;
	MagFilter = POINT;
	MinFilter = POINT;
	MipFilter = POINT;
};

texture2D PCGIaccuTex { Width = BUFFER_WIDTH / 2; Height = BUFFER_HEIGHT ; Format = RGBA16f; };
sampler2D PCGIaccuFrames { Texture = PCGIaccuTex; };
//Seen issues with pooling this texture.. Workaround for 4.8.0- 
texture2D PCGIcurrColorTex PoolTex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA16f; MipLevels = 11;};
sampler2D PCGIcurrColor { Texture = PCGIcurrColorTex; };

texture2D PCGIcurrNormalsDepthTex < pooled = true; > { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA16f; MipLevels = 11;};
sampler2D PCGIcurrNormalsDepth { Texture = PCGIcurrNormalsDepthTex; };

texture2D RadiantGITex  { Width = BUFFER_WIDTH * RSRes ; Height = BUFFER_HEIGHT * RSRes ; Format = RGBA16f; };//For AO this need to be RGBA16f or RGBA8
sampler2D PCGI_Info { Texture = RadiantGITex;
	MagFilter = POINT;
	MinFilter = POINT;
	MipFilter = POINT;
};

texture2D PCGIupsampleTex < pooled = true; > { Width = BUFFER_WIDTH ; Height = BUFFER_HEIGHT ; Format = RGBA16f; MipLevels = 3;};//For AO this need to be RGBA16f or RGBA8
sampler2D PCGIupsample_Info { Texture = PCGIupsampleTex; };

texture2D PCGIbackbufferTex < pooled = true; > { Width = BUFFER_WIDTH ; Height = BUFFER_HEIGHT ; Format = RGBA16f;  };
sampler2D PCGIbackbuffer_Info { Texture = PCGIbackbufferTex; };
//Seen issues with pooling this texture.. Workaround for 4.8.0- 
texture2D PCGIHorizontalTex PoolTex { Width = BUFFER_WIDTH ; Height = BUFFER_HEIGHT ; Format = RGBA16f; };
sampler2D PCGI_BGUHorizontal_Sample { Texture = PCGIHorizontalTex;};
//Seen issues with pooling this texture.. Workaround for 4.8.0- 
texture2D PCGIVerticalTex PoolTex { Width = BUFFER_WIDTH ; Height = BUFFER_HEIGHT ; Format = RGBA16f; };
sampler2D PCGI_BGUVertical_Sample { Texture = PCGIVerticalTex;
};

#if Look_For_Buffers_ReVeil
texture Transmission { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = R16f; };
sampler2D ReVeilTransmission {Texture = Transmission;};
#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
float Depth_Info(float2 texcoord)
{
	#if BD_Correction || DC
	if(BD_Options == 0)
	{
		float3 K123 = Colors_K1_K2_K3 * 0.1;
		texcoord = D(texcoord.xy,K123.x,K123.y,K123.z);
	}
	#endif
	#if DB_Size_Position || SP || LBC || LB_Correction
		texcoord.xy += float2(-Image_Position_Adjust.x,Image_Position_Adjust.y)*0.5;
	#if LBC || LB_Correction
		float2 H_V = Horizontal_and_Vertical * float2(1,LBDetection() ? 1.315 : 1 );
	#else
		float2 H_V = Horizontal_and_Vertical;
	#endif
		float2 midHV = (H_V-1) * float2(BUFFER_WIDTH * 0.5,BUFFER_HEIGHT * 0.5) * pix;
		texcoord = float2((texcoord.x*H_V.x)-midHV.x,(texcoord.y*H_V.y)-midHV.y);
	#endif

	if (Depth_Map_Flip)
		texcoord.y =  1 - texcoord.y;

	//Conversions to linear space.....
	float zBuffer = tex2Dlod(ZBuffer, float4(texcoord,0,0)).x, zBufferWH = zBuffer, Far = 1.0, Near = 0.125/Depth_Map_Adjust, NearWH = 0.125/(Depth_Map ? NCD.y : 10*NCD.y), OtherSettings = Depth_Map ? NCD.y : 100 * NCD.y ; //Near & Far Adjustment
	//Man Why can't depth buffers Just Be Normal
	float2 C = float2( Far / Near, 1.0 - Far / Near ), Z = Offset < 0 ? min( 1.0, zBuffer * ( 1.0 + abs(Offset) ) ) : float2( zBuffer, 1.0 - zBuffer ), Offsets = float2(1 + OtherSettings,1 - OtherSettings), zB = float2( zBufferWH, 1-zBufferWH );

	if(Offset > 0 || Offset < 0)
	Z = Offset < 0 ? float2( Z.x, 1.0 - Z.y ) : min( 1.0, float2( Z.x * (1.0 + Offset) , Z.y / (1.0 - Offset) ) );

	if (NCD.y > 0)
	zB = min( 1, float2( zB.x * Offsets.x , zB.y / Offsets.y  ));

	if (Depth_Map == 0)
	{   //DM0 Normal
		zBuffer = rcp(Z.x * C.y + C.x);
		zBufferWH = Far * NearWH / (Far + zB.x * (NearWH - Far));
	}
	else if (Depth_Map == 1)
	{   //DM1 Reverse
		zBuffer = rcp(Z.y * C.y + C.x);
		zBufferWH = Far * NearWH / (Far + zB.y * (NearWH - Far));
	}

	return  saturate( lerp(NCD.y > 0 ? zBufferWH : zBuffer,zBuffer,0.925) );
}
//Improved Normal reconstruction from Depth
float3 DepthNormals(float2 texcoord)
{
	float2 Pix_Offset = pix.xy;
	//A 2x2 Taps is done here. You can also do 4x4 tap
	float2 uv0 = texcoord; // center
	float2 uv1 = texcoord + float2( Pix_Offset.x, 0); // right
	float2 uv2 = texcoord + float2(-Pix_Offset.x, 0); // left
	float2 uv3 = texcoord + float2( 0, Pix_Offset.y); // down
	float2 uv4 = texcoord + float2( 0,-Pix_Offset.y); // up

	float depth = Depth_Info( uv0 );

	float depthR = Depth_Info( uv1 );
	float depthL = Depth_Info( uv2 );
	float depthD = Depth_Info( uv3 );
	float depthU = Depth_Info( uv4 );

	float3 P0, P1, P2;

	int best_Z_horizontal = abs(depthR - depth) < abs(depthL - depth) ? 1 : 2;
	int best_Z_vertical = abs(depthD - depth) < abs(depthU - depth) ? 3 : 4;

	if (best_Z_horizontal == 1 && best_Z_vertical == 4)
	{   //triangle 0 = P0: center, P1: right, P2: up
		P1 = float3(uv1 - 0.5, 1) * depthR;
		P2 = float3(uv4 - 0.5, 1) * depthU;
	}
	if (best_Z_horizontal == 1 && best_Z_vertical == 3)
	{   //triangle 1 = P0: center, P1: down, P2: right
		P1 = float3(uv3 - 0.5, 1) * depthD;
		P2 = float3(uv1 - 0.5, 1) * depthR;
	}
	if (best_Z_horizontal == 2 && best_Z_vertical == 4)
	{   //triangle 2 = P0: center, P1: up, P2: left
		P1 = float3(uv4 - 0.5, 1) * depthU;
		P2 = float3(uv2 - 0.5, 1) * depthL;
	}
	if (best_Z_horizontal == 2 && best_Z_vertical == 3)
	{   //triangle 3 = P0: center, P1: left, P2: down
		P1 = float3(uv2 - 0.5, 1) * depthL;
		P2 = float3(uv3 - 0.5, 1) * depthD;
	}

	P0 = float3(uv0 - 0.5, 1) * depth;

	return normalize(cross(P2 - P0, P1 - P0));
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
float DepthMap(float2 texcoords, int Mips)
{
	return tex2Dlod(PCGIcurrNormalsDepth,float4(texcoords,0,Mips)).w;
}

float3 NormalsMap(float2 texcoords, int Mips)
{//normalize(
	float3 BN = tex2Dlod(PCGIcurrNormalsDepth,float4(texcoords,0,Mips)).xyz;// * 2.0 - 1.0);
		   //BN.xy = (BN.xy - 0 ) / (0.625 - 0);//Not Needed oh well stored code.
	return BN;
}

float4 BBColor(float2 texcoords, int Mips)
{   float LL_Comp = 0.5; //Wanted to automate this but it's really not need.
	float4 BBC = tex2Dlod(PCGIcurrColor,float4(texcoords,0,Mips)).rgba;//PrepColor(texcoords, 0, Mips);
	#if PureGI_Mode
		BBC.rgb = (BBC.rgb - 0.5) * (LL_Comp + 1.0) + 0.5;
		return BBC + (LL_Comp * 0.5625);
	#else
		return BBC;
	#endif
}

float4 DirectLighting(float2 texcoords , int Mips)
{
	float4 BC = BBColor(texcoords, Mips);
	if(HDR_BP > 0)
		BC.rgb = inv_Tonemapper(float4(BC.rgb,1-HDR_BP));
		
	float  GS = Luma(BC.rgb);
		   BC.rgb /= GS;
		   BC.rgb *= saturate(GS - lerp(0.0,0.5,saturate(Target_Lighting)));
	return float4(Saturator_A(BC.rgb),BC.a);
}

float4 IndirectLighting(float2 texcoords , int Mips)
{
	float4 BC = BBColor(texcoords, Mips);
	if(HDR_BP > 0)
		BC.rgb = inv_Tonemapper(float4(BC.rgb,1-HDR_BP));

	float  GS = Luma(BC.rgb);
		   BC.rgb /= 1-GS;
		   BC.rgb *= 1-saturate(GS + lerp(0.0,0.5,saturate(Target_Lighting)));
	return float4(Saturator_B(BC.rgb * lerp(1.0,2.0,saturate(Target_Lighting))),BC.a);
}

float3 GetPosition(float2 texcoord)
{
	float3 DM = -DepthMap(texcoord, 0 ).xxx;
	return float3(texcoord.xy*2-1,1.0)*DM;
}

float2 Rotate2D_A( float2 r, float l , float2 TC)
{   float Reflective_Diffusion = lerp(saturate(Reflectivness),1.0,smoothstep(0,0.25,1-dot(float3(0,1,0) ,NormalsMap(TC,0))));
	float2 Directions;
	sincos(l,Directions[0],Directions[1]);//same as float2(cos(l),sin(l))
	return float2( dot( r * Reflective_Diffusion, float2(Directions[1], -Directions[0]) ), dot( r, Directions.xy ) );
}

float2 Rotate2D_B( float2 r, float l )
{   float2 Directions;
	sincos(l,Directions[0],Directions[1]);//same as float2(cos(l),sin(l))
	return float2( dot( r, float2(Directions[1], -Directions[0]) ), dot( r, Directions.xy ) );
}


float SSSMasking(float2 TC)
{
	float SSSD = lerp(0,1, saturate(1-DepthMap(TC, 0 ) * lerp(1,10,SSS_Seek.x)) );
	return SSSD * smoothstep(0,0.25,1-dot(float3(0,1,0) ,NormalsMap(TC,0)) * dot(float3(0,1,0) ,NormalsMap(TC,0)) );// || dot(float3(0,1,0) ,NormalsMap(TC,0))
}

//Form Factor Approximations
float4 RadianceFF(inout float3 II,in float2 texcoord,in float3 ddiff,in float3 normals, in float2 AB)
{   //So normal and the vector between "Element to Element - Radiance Transfer."
	float4 v = float4(normalize(ddiff), length(ddiff));
	//Emitter & Recever
	float2 giE_R = saturate(float2(dot(-v.xyz,NormalsMap(texcoord+AB,3)), dot( v.xyz, normals )));
	float3 Global_Illumination = saturate(100.0 * giE_R.x * giE_R.y /((1000*Trim)*(v.w*v.w)+1.0) ), Irradiance_Information = II.rgb;
	return float4(Global_Illumination * Irradiance_Information,1);
}
/* //This Code is Disabled Not going to use in RadiantGI
float AmbientOcclusionFF(in float2 texcoord,in float3 ddiff,in float3 normals, in float2 AB)
{   //So normal and the vector between "Element to Element - Occlusion."
	float4 v = float4(normalize(ddiff), length(ddiff));
	//Emitter & Recever - Clamped Values are used for self Shadowing.
	float2 aoE_R = 1.0*float2(1-clamp(dot(-v.xyz,NormalsMap(texcoord+AB,0)),-1,0), saturate(dot( v.xyz, normals )));
	return saturate(aoE_R.x * aoE_R.y * (1.0 - (AO_Trim*8) / sqrt(AO_Trim/(v.w*v.w) + PI )));
}
//This Code is Disabled Not going to use in RadiantGI
float4 GlossyFF(inout float3 II,in float2 texcoord,in float3 ddiff,in float3 normals, in float AB)
{   //So normal and the vector between "Element to Element - Specular Effect."
	float4 v = float4(normalize(ddiff), length(ddiff)), Irradiance_Information = float4(II.rgb,1);
	//Emitter & Recever
	float2 E_R = saturate(float2(dot(-v.xyz,NormalsMap(texcoord+AB,3)), dot( v.xyz, reflect(GetPosition(texcoord),normals) )));
		   //E_R = pow(E_R,Roughness);
	float3 Global_Illumination = saturate(100.0 * E_R.x * E_R.y / ( PI * v.w * v.w + 1.0) );
	return float4(Global_Illumination.xyz,1) * Irradiance_Information;
}
*/
float4 SubsurfaceScatteringFF(inout float3 II,in float2 texcoord,in float3 ddiff,in float3 normals, in float2 AB)
{   //So normal and the vector between "Element to Element - Wrap Lighting."
	float4 v = float4(normalize(ddiff), length(ddiff));
	//Emitter & Recever
	float LW = Wrap;
	float2 ssE_R = saturate(float2(max(0, dot(-v.xyz,NormalsMap(texcoord+AB,0))), max(0, dot( v.xyz, normals ) + LW) / (1 + LW)));
	float3 Scatter = saturate(100.0 * ssE_R.x * ssE_R.y / ( PI * v.w * v.w + 1.0) ), Irradiance_Information = II.rgb;
	return float4(Scatter * Irradiance_Information,1);
}

float ThiccnessFF(in float2 texcoord,in float3 ddiff,in float3 normals, in float2 AB)
{   //So normal and the vector between "Element to Element - Thiccness Approximation."
	float4 v = float4(normalize(ddiff), length(ddiff));
	//Emitter & Recever
	float2 fE_R = float2(1.0 - dot(-NormalsMap(texcoord+AB, 1),v.xyz),  dot( normals, -v.xyz ) ); //flipped face is needed for generate local thiccness map.
	float Thicc = fE_R.x * fE_R.y * (1.0 - 1.0 / sqrt(rcp(v.w*v.w) + PI));
	return Thicc;
}

float2 GPattern(float2 TC)
{	float2 Grid = floor( TC * float2(BUFFER_WIDTH, BUFFER_HEIGHT ) * RSRes);
	return float2(fmod(Grid.x+Grid.y,2.0),fmod(Grid.x,2.0));
}

float4 PCGI(float4 position : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	//Global Illumination Ray Length & Depth // * 0.125
	float depth = DepthMap( texcoord, 0 ), D = depth;// * 0.9992;
	float4 Noise;
	MCNoise( Noise.x, framecount, texcoord, 1 );
	MCNoise( Noise.y, framecount, texcoord, 2 );
	MCNoise( Noise.z, framecount, texcoord, 3 );
	MCNoise( Noise.w, framecount, texcoord, 4 );	//Smoothing for AO not needed since this shader not going to use AO code above.//for GetPos * 0.990
	float4 random = Noise.xyzw * 2.0 - 1.0,GI, PWH;//!Smooth ? 0 : 9 // sn = lerp(NormalsMap(texcoord,0),lerp(NormalsMap(texcoord,0),NormalsMap(texcoord,9),lerp(1.0,0.5,D)),0.9)
	float3 n = NormalsMap( texcoord, 0), p = GetPosition( texcoord), ddiff, ddiff_tc, ddiff_gi ,ddiff_gd, ddiff_ss, II_gi, II_gd, II_ss;
	//Basic Bayer like pattern. Used for 3 levels of Rays. Color names are a hold over for pattern.
	float4 rl_gi_sss = float4( GIRL().x, GIRL().y, 75,lerp(1,125, Deep_Scattering ));
	float Grid = GPattern( texcoord).x, GB = Grid ? 1 : 0, GR = Grid ? 0.75 : 0.25;
	float Bayer = GPattern( texcoord).y ? GR : GB, AGrid = Scattering ? Grid || SkinDetection(tex2Dlod(PCGIcurrColor,float4(texcoord,0,2))) : 1; //|| SkinDetection(tex2D(BackBufferPCGI,texcoord))
	//Did this just because Ceejay said bayer not usefull for anything.
	if(Bayer == 0)
		rl_gi_sss.xy = rl_gi_sss.xy;
	else if(Bayer == 1)
		rl_gi_sss.xy *= 0.750;
	else if(Bayer == 0.75)
		rl_gi_sss.xy *= 0.375;
	else
		rl_gi_sss.xy *= 0.125;
	//Basic depth rescaling from Near to Far
	float D0 = smoothstep(-NCD.x,1, depth ), D1 = smoothstep(-1,1, depth ), N_F = lerp(GI_Fade * 2,0, 1-D );//smoothstep(0,saturate(GI_Fade),D);
	//SSS, GI, Gloss, and AO Form Factor code look above
	[fastopt] // Dose this even do anything better vs unroll? Compile times seem the same too me. Maybe this will work better if I use the souls I collect of the users that use this shader?
	for (int i = 0; i <= samples; i++)
	{ //VRS and Max Depth Exclusion...... every ms counts.........
		if( smoothstep(0,1,D) > MaxDepth_Cutoff )
			break;
		//Evenly distributed points on Poisson Disk.... But, with High Frequency noise.
		float2 GIWH = (pix * rl_gi_sss[0]) * random[0] * Rotate2D_A( PoissonTaps[i], random[3] , texcoord) / D0,
			   GDWH = (pix * rl_gi_sss[1]) * random[1] * Rotate2D_B( PoissonTaps[i], random[2] ) / D0,
			   SSWH = (pix * rl_gi_sss[2]) * random[2] * Rotate2D_B( PoissonTaps[i], random[1] ) / D1,
			   TCWH = (pix * rl_gi_sss[3]) * random[3] * Rotate2D_B( PoissonTaps[i], random[0] ) / D1;

		//Recever to Emitter vector
		ddiff_tc = GetPosition( texcoord + TCWH) - p;
		//Thiccness Form Factor
		if(!AGrid)
			GI.w += lerp(0,ThiccnessFF(texcoord, ddiff_tc, n, TCWH), SSSMasking( texcoord ));

		#if PureGI_Mode
		if(!Grid)
		{
			//Recever to Emitter vector
			ddiff_gi = GetPosition( texcoord + GDWH) - p;
			//Irradiance Information
			II_gi = Saturator_B(IndirectLighting( texcoord + GDWH, 3).rgb);
			//Radiance Form Factor
			GI.rgb += lerp(RadianceFF( II_gi, texcoord, ddiff_gi, n, GDWH).rgb, 0, N_F);
		}
		#endif

		if(AGrid)
		{
			if(Grid)
			{
				//Recever to Emitter vector
				ddiff_gi = GetPosition( texcoord + GIWH) - p;
				//Irradiance Information
				II_gi = Saturator_A(DirectLighting( texcoord + GIWH, 3).rgb);
				//Radiance Form Factor
				GI.rgb += lerp(RadianceFF( II_gi, texcoord, ddiff_gi, n, GIWH).rgb, 0, N_F);
			}
		}
		else
		{   //Recever to Emitter vector
			ddiff_ss = GetPosition( texcoord + SSWH) - p;
			//Irradiance Information
			II_ss = BBColor( texcoord + SSWH, 3).rgb;
			//SubsurfaceScattering Form Factor;
			GI.rgb += lerp( 0,lerp( SubsurfaceScatteringFF( II_ss, texcoord, ddiff_ss, n, SSWH).rgb, 0, N_F), SSSMasking( texcoord));
		}
	}
	
	GI *= rcp(samples);

	float4 output = float4(  RGBtoYCbCr(min( Clamp_Out ? 1 : 2 ,GI.rgb * lerp(2,8,Scattering ? AGrid : 1) )), GI.w * 2);

	#if Look_For_Buffers_ReVeil //Lord of Lunacy DeHaze insertion was here.
	if(UseReVeil)
		output.r *= tex2D( ReVeilTransmission, texcoord).r;
	#endif
	return output;
}

float4 GI_Adjusted(float2 TC, int Mip)
{
	float4 Convert = tex2Dlod( PCGI_Info, float4( TC, 0, Mip));
	#if !PureGI_Mode
	float DT = BBColor(TC, 3.5 ).w * 5, SSL = clamp(dot(BBColor(TC, 2.0).rgb,0.333) * lerp(1.0,4.0,User_SSS_Luma),1,2);
	Convert.x *= GPattern( TC ).x ? GI_LumaPower.x : 1;
	Convert.xyz = YCbCrtoRGB( Convert.xyz);
	float3 SSS = InternalFleshColor(Convert.xyz * SSL, Convert.w , lerp(0,25,saturate(Internals.xyz)), DT );
	Convert.xyz =  GPattern( TC ).x ?  Saturator_A(Convert.xyz *  min( GI_Power.x, 5.0)) : SSS ;
	#else
	Convert.x *= GPattern( TC ).x ? GI_LumaPower.x : 0.5;
	Convert.xyz = YCbCrtoRGB( Convert.xyz);
	Convert.xyz =  GPattern( TC ).x ?  Saturator_A(Convert.xyz *  min( GI_Power.x, 5.0)) :  Saturator_B(Convert.xyz *  min( GI_Power.y, 5.0)) ;
	#endif
	return float4( Convert.xyz , 0);
}

void Upsample(float4 vpos : SV_Position, float2 texcoords : TEXCOORD, out float4 UpGI : SV_Target0, out float4 ColorOut : SV_Target1)
{
	float2 Offsets = 2.0, vClosest = texcoords, vBilinearWeight = 1.0 - frac(texcoords);
	float4 fTotalGI, fTotalWeight;
	[unroll]
	for(float x = 0.0; x < 2.0; ++x)
	{
		for(float y = 0.0; y < 2.0; ++y)
		{
			 // Sample depth (stored in meters) and AO for the half resolution
			 float fSampleDepth = DepthMap( vClosest + float2(x,y) * pix,0);
			 float4 fSampleGI = GI_Adjusted(vClosest + float2(x,y) * pix / RSRes,0);
			 // Calculate bilinear weight
			 float fBilinearWeight = (x-vBilinearWeight.x) * (y-vBilinearWeight.y);
			 // Calculate upsample weight based on how close the depth is to the main depth
			 float fUpsampleWeight = max(0.00001, 0.1 - abs(fSampleDepth - DepthMap(texcoords,0) ) ) * 30.0;
			 // Apply weight and add to total sum
			 fTotalGI += (fBilinearWeight + fUpsampleWeight) * fSampleGI;
			 fTotalWeight += (fBilinearWeight + fUpsampleWeight);
		}
	}
	// Divide by total sum to get final GI
	UpGI = fTotalGI / fTotalWeight;
	ColorOut = float4( tex2D( BackBufferPCGI, texcoords).rgb, 0);
}

float3 GI(float2 TC, float Mips)
{
	#line 1337 "For the latest version go https://blueskydefender.github.io/AstrayFX/ or http://www.Depth3D.info����"
	#warning ""
	return tex2Dlod( PCGIupsample_Info, float4( TC, 0, Mips)).xyz * 0.5;
}

float4 GI_TAA(float4 vpos : SV_Position, float2 texcoords : TEXCOORD) : SV_Target
{   //Depth Similarity
	float M_Similarity = 0.5, D_Similarity = saturate(pow(abs(tex2D(PCGIpastFrame,texcoords).w/DepthMap(texcoords, 0)), 10) + M_Similarity);
	//Velocity Scaler
	float S_Velocity = 12.5 * lerp( 1, 80,TAA_Clamping), V_Buffer = saturate(distance(DepthMap(texcoords, 0),tex2D(PCGIpastFrame,texcoords).w) * S_Velocity);
	//Accumulation buffer Start
    float4 PastColor = tex2Dlod( PCGIaccuFrames, float4( texcoords, 0, 0) );
	float3 GISamples, CurrAOGI = GI( texcoords, 0).rgb;

	float3 antialiased = PastColor.xyz;
	float mixRate = min( PastColor.w, 0.5), MB = 0.0;//0.001;

	antialiased = lerp( antialiased * antialiased, CurrAOGI.rgb * CurrAOGI.rgb, mixRate);
	antialiased = sqrt( antialiased);

	float3 minColor = CurrAOGI - MB;
	float3 maxColor = CurrAOGI + MB;
	[unroll]
	for(int i = 0; i < 8; ++i)
	{
		float2 Offset = XYoffset[i] * (RSRes + 4);
		GISamples = GI( texcoords + Offset , 0 ).rgb;
		minColor = min( minColor, GISamples) - MB;
		maxColor = max( maxColor, GISamples) + MB;
	}
	//float3 preclamping = antialiased;
	//Min Max neighbourhood clamping.
	antialiased = clamp( antialiased, minColor, maxColor);
	mixRate = rcp( 1.0 / mixRate + 1.0);
	//float diff = length(antialiased - preclamping) * 4;
	//Added Velocity Clamping.......
	float clampAmount = V_Buffer;

	mixRate += clampAmount;
	mixRate = clamp( mixRate, 0.0, 0.5);
	//Sample from Accumulation buffer, with mix rate clamping.
	float3 AA = lerp( 0, antialiased, D_Similarity);
	return float4( AA, mixRate);
}
//Custom Gaussian Blur Denoiser
float4 Denoise(sampler Tex, float2 texcoords, int SXY, int Dir , float R )
{
	float4 StoredNormals_Depth = tex2Dlod( PCGIcurrNormalsDepth,float4( texcoords, 0, 0));
	float4 center = tex2D(Tex,texcoords), color = 0.0;//Like why do SmoothNormals when 2nd Level Denoiser is like Got you B#*@!........
	float total = 0.0, NormalBlurFactor = Debug == 1 ? 0.1f : 1.0f, DepthBlurFactor = 1.0f,  DM = smoothstep(0,1,StoredNormals_Depth.w) > MaxDepth_Cutoff;
	if(!DM)		 // I lie because I love you.
	{
		if(SXY > 0) // Who would win Raw Boi or Gaussian Boi
		{
		    for (int i = -SXY * 0.5; i <= SXY * 0.5; ++i)
			{
	        	float2 D = Dir ? float2( i, 0) : float2( 0, i);
				float2 TC = texcoords + D * R * pix;
				float4 ModifiedNormals_Depth = tex2Dlod( PCGIcurrNormalsDepth, float4( TC, 0, 0));
				float ModN = length(StoredNormals_Depth.xyz - ModifiedNormals_Depth.xyz),ModD = abs( StoredNormals_Depth.w - ModifiedNormals_Depth.w);
		        float dist2 = max(ModN, 0.0);
		        float n_w = min(exp(-(dist2)/NormalBlurFactor), 1.0);
				if ( ModD < DepthBlurFactor)
				{
	       	 	float weight = gaussian(i, sqrt(SXY)) * n_w;
	        		color += tex2Dlod(Tex, float4(TC ,0,0)) * weight;
	        		total += weight;
	        	}
	    	}
    	}
	}
	return SamplesXY > 0 ? color / (DM ? 1 : total) : center;
}
//Horizontal Denoising Upscaling
float4 BGU_Hoz(float4 position : SV_Position, float2 texcoords : TEXCOORD) : SV_Target
{   //float AO = Denoise(PCGIupsample_Info,texcoords,SamplesXY, 1, 4).w;
	return float4( Denoise( BackBufferPCGI, texcoords, EvenSteven[clamp(SamplesXY,0,20)], 0, 4).rgb, 0);
}
//Vertical Denoising Upscaling
float4 BGU_Ver(float4 position : SV_Position, float2 texcoords : TEXCOORD) : SV_Target
{
	return Denoise( PCGI_BGUHorizontal_Sample, texcoords, EvenSteven[clamp(SamplesXY,0,20)], 1, 4);
}

float3 overlay(float3 c, float3 b) 		{ return c<0.5f ? 2.0f*c*b:(1.0f-2.0f*(1.0f-c)*(1.0f-b));}
float3 softlight(float3 c, float3 b) 	{ return b<0.5f ? (2.0f*c*b+c*c*(1.0f-2.0f*b)):(sqrt(c)*(2.0f*b-1.0f)+2.0f*c*(1.0f-b));}
float3 add(float3 c, float3 b) 	{ return c + (b * 0.5);}

float3 Composite(float3 Color, float3 Cloud)
{
	float3 Output, FiftyGray = Cloud + 0.5;//Saturator_A(Cloud + 0.5);
	//Cloud = Saturator_A(Cloud);// Set bool for this
	#if Controlled_Blend
		Output = add( lerp( overlay( Color,  FiftyGray), softlight( Color,  FiftyGray),Blend),Cloud * 0.1875);
	#else
	if(BM == 0)
		Output = add( lerp( overlay( Color,  FiftyGray), softlight( Color,  FiftyGray), 0.5 ),Cloud * 0.1875);
	else if(BM == 1)
		Output = overlay( Color, FiftyGray);
	else if(BM == 2)
		Output = softlight( Color, FiftyGray);
	else
		Output = add( Color, Cloud);
	#endif
	return Output;
}
/*
float MB(float2 texcoords)
{   float Mip = 2;
	return saturate(distance(tex2Dlod(PCGIpastFrame,float4(texcoords,0,Mip)).r,dot(tex2Dlod(PCGI_BGUVertical_Sample ,float4(texcoords,0,Mip)).rgb,0.333)) * 10);
}
*/
float3 Mix(float2 texcoords)
{
	return Composite(tex2Dlod(PCGIbackbuffer_Info,float4(texcoords,0,0)).rgb , PureGI_Mode ? tex2Dlod(PCGI_BGUVertical_Sample,float4(texcoords,0,0)).rgb : Saturator_A(tex2Dlod(PCGI_BGUVertical_Sample,float4(texcoords,0,0)).rgb)) ;
}
//Diffusion Blur - Man....... Talk about strange....
float3 DiffusionBlur(float2 texcoords)
{
float4 StoredNormals_Depth = tex2Dlod(PCGIcurrNormalsDepth,float4(texcoords,0,0));
	float3 Layer,total;
	float ML = SSSMasking(texcoords).x, SD = 1-SkinDetection(tex2Dlod(PCGIbackbuffer_Info,float4(texcoords,0,2)) );

if(SD && Scattering && ML && Diffusion_Power > 0 )
	{
		[loop]
		for(int i = 0; i < 7; ++i)
		{
			if(i > 7 || smoothstep( 0, 1, DepthMap( texcoords, 0)) > MaxDepth_Cutoff)
				break;
			float2 offsetxy = texcoords + float2( DBoffsets[i], 0) * pix * lerp( 0.0, 2.0,saturate(Diffusion_Power));
			float3 CMix =  Mix( offsetxy).rgb;

		float4 ModifiedNormals_Depth = tex2Dlod( PCGIcurrNormalsDepth,float4( offsetxy,0,0));
			if ( dot(ModifiedNormals_Depth.xyz, StoredNormals_Depth.xyz) > 0.5f &&
				 abs(StoredNormals_Depth.w - ModifiedNormals_Depth.w) < 0.001f )
			{

			float3 weight = DBweight[i];
				Layer += CMix * weight;
				total += weight;
			}
		}
		return Layer / total;
	}
	else
		return Mix(texcoords).rgb;
}

float3 MixOut(float2 texcoords)
{
	float3 Layer = DiffusionBlur( texcoords );
	float Depth = DepthMap( texcoords,0), FakeAO = Debug == 1 || Depth_Guide ? ( Depth + DepthMap(texcoords + float2(pix.x * 2,0),1) + DepthMap(texcoords + float2(-pix.x * 2,0),2) + DepthMap(texcoords + float2(0,pix.y * 2),Depth_Guide ? 3 : 8)  + DepthMap(texcoords + float2(0,-pix.y * 2),Depth_Guide ? 4 : 10) ) * 0.2 : 0;
	float3 Output = tex2D( PCGI_BGUVertical_Sample, texcoords).rgb;

	if(Debug == 0)
		return Depth_Guide ? Layer * float3((Depth/FakeAO> 0.998),1,(Depth/FakeAO > 0.998))  : Layer;
	else if(Debug == 1)
		return lerp(Output + 0.50 * lerp(1-(Depth-FakeAO) ,1,smoothstep(0,1,Depth) == 1),Output,Dark_Mode); //This fake AO is a lie..........
	else
		return texcoords.x + texcoords.y < 1 ? DepthMap(texcoords, 0 ) : NormalsMap(texcoords,0) * 0.5 + 0.5;
}
////////////////////////////////////////////////////////////////Overwatch////////////////////////////////////////////////////////////////////////////
static const float  CH_A    = float(0x69f99), CH_B    = float(0x79797), CH_C    = float(0xe111e),
					CH_D    = float(0x79997), CH_E    = float(0xf171f), CH_F    = float(0xf1711),
					CH_G    = float(0xe1d96), CH_H    = float(0x99f99), CH_I    = float(0xf444f),
					CH_J    = float(0x88996), CH_K    = float(0x95159), CH_L    = float(0x1111f),
					CH_M    = float(0x9fd99), CH_N    = float(0x9bd99), CH_O    = float(0x69996),
					CH_P    = float(0x79971), CH_Q    = float(0x69b5a), CH_R    = float(0x79759),
					CH_S    = float(0xe1687), CH_T    = float(0xf4444), CH_U    = float(0x99996),
					CH_V    = float(0x999a4), CH_W    = float(0x999f9), CH_X    = float(0x99699),
					CH_Y    = float(0x99e8e), CH_Z    = float(0xf843f), CH_0    = float(0x6bd96),
					CH_1    = float(0x46444), CH_2    = float(0x6942f), CH_3    = float(0x69496),
					CH_4    = float(0x99f88), CH_5    = float(0xf1687), CH_6    = float(0x61796),
					CH_7    = float(0xf8421), CH_8    = float(0x69696), CH_9    = float(0x69e84),
					CH_APST = float(0x66400), CH_PI   = float(0x0faa9), CH_UNDS = float(0x0000f),
					CH_HYPH = float(0x00600), CH_TILD = float(0x0a500), CH_PLUS = float(0x02720),
					CH_EQUL = float(0x0f0f0), CH_SLSH = float(0x08421), CH_EXCL = float(0x33303),
					CH_QUES = float(0x69404), CH_COMM = float(0x00032), CH_FSTP = float(0x00002),
					CH_QUOT = float(0x55000), CH_BLNK = float(0x00000), CH_COLN = float(0x00202),
					CH_LPAR = float(0x42224), CH_RPAR = float(0x24442);
#define MAP_SIZE float2(4,5)
//returns the status of a bit in a bitmap. This is done value-wise, so the exact representation of the float doesn't really matter.
float getBit( float map, float index )
{   // Ooh -index takes out that divide :)
    return fmod( floor( map * exp2(-index) ), 2.0 );
}

float drawChar( float Char, float2 pos, float2 size, float2 TC )
{   // Subtract our position from the current TC so that we can know if we're inside the bounding box or not.
    TC -= pos;
    // Divide the screen space by the size, so our bounding box is 1x1.
    TC /= size;
    // Create a place to store the result & Branchless bounding box check.
    float res = step(0.0,min( TC.x, TC.y)) - step(1.0,max( TC.x, TC.y));
    // Go ahead and multiply the TC by the bitmap size so we can work in bitmap space coordinates.
    TC *= MAP_SIZE;
    // Get the appropriate bit and return it.
    res*=getBit( Char, 4.0 * floor( TC.y) + floor( TC.x) );
    return saturate( res);
}

float3 Out(float4 position : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	float2 TC = float2(texcoord.x,1-texcoord.y);
	float Gradient = (1-texcoord.y*50.0+48.85)*texcoord.y-0.500, Text_Timer = 12500, BT = smoothstep(0,1,sin(timer*(3.75/1000))), Size = 1.1, Depth3D, Read_Help, Supported, SetFoV, FoV, Post, Effect, NoPro, NotCom, Mod, Needs, Net, Over, Set, AA, Emu, Not, No, Help, Fix, Need, State, SetAA, SetWP, Work;
	float3 Color = MixOut(texcoord).rgb;

	if(RH || NC || NP || NF || PE || DS || OS || DA || NW || FV)
		Text_Timer = 25000;

	[branch] if(timer <= Text_Timer || Text_Info)
	{ // Set a general character size...
		float2 charSize = float2(.00875, .0125) * Size;
		// Starting position.
		float2 charPos = float2( 0.009, 0.9725);
		//Needs Copy Depth and/or Depth Selection
		Needs += drawChar( CH_N, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_E, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_E, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_D, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_S, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_BLNK, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_C, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_O, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_P, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_Y, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_BLNK, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_D, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_E, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_P, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_T, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_H, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_BLNK, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_A, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_N, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_D, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_SLSH, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_O, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_R, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_BLNK, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_D, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_E, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_P, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_T, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_H, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_BLNK, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_S, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_E, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_L, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_E, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_C, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_T, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_I, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_O, charPos, charSize, TC); charPos.x += .01 * Size;
		Needs += drawChar( CH_N, charPos, charSize, TC);
		//Network Play May Need Modded DLL
		charPos = float2( 0.009, 0.955);
		Work += drawChar( CH_N, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_E, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_T, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_W, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_O, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_R, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_K, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_BLNK, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_P, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_L, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_A, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_Y, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_BLNK, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_M, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_A, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_Y, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_BLNK, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_N, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_E, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_E, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_D, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_BLNK, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_M, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_O, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_D, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_D, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_E, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_D, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_BLNK, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_D, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_L, charPos, charSize, TC); charPos.x += .01 * Size;
		Work += drawChar( CH_L, charPos, charSize, TC);
		//Disable CA/MB/Dof/Grain
		charPos = float2( 0.009, 0.9375);
		Effect += drawChar( CH_D, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_I, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_S, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_A, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_B, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_L, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_E, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_BLNK, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_C, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_A, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_SLSH, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_M, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_B, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_SLSH, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_D, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_O, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_F, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_SLSH, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_G, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_R, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_A, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_I, charPos, charSize, TC); charPos.x += .01 * Size;
		Effect += drawChar( CH_N, charPos, charSize, TC);
		//Disable TAA/MSAA/AA
		charPos = float2( 0.009, 0.920);
		SetAA += drawChar( CH_D, charPos, charSize, TC); charPos.x += .01 * Size;
		SetAA += drawChar( CH_I, charPos, charSize, TC); charPos.x += .01 * Size;
		SetAA += drawChar( CH_S, charPos, charSize, TC); charPos.x += .01 * Size;
		SetAA += drawChar( CH_A, charPos, charSize, TC); charPos.x += .01 * Size;
		SetAA += drawChar( CH_B, charPos, charSize, TC); charPos.x += .01 * Size;
		SetAA += drawChar( CH_L, charPos, charSize, TC); charPos.x += .01 * Size;
		SetAA += drawChar( CH_E, charPos, charSize, TC); charPos.x += .01 * Size;
		SetAA += drawChar( CH_BLNK, charPos, charSize, TC); charPos.x += .01 * Size;
		SetAA += drawChar( CH_T, charPos, charSize, TC); charPos.x += .01 * Size;
		SetAA += drawChar( CH_A, charPos, charSize, TC); charPos.x += .01 * Size;
		SetAA += drawChar( CH_A, charPos, charSize, TC); charPos.x += .01 * Size;
		SetAA += drawChar( CH_SLSH, charPos, charSize, TC); charPos.x += .01 * Size;
		SetAA += drawChar( CH_M, charPos, charSize, TC); charPos.x += .01 * Size;
		SetAA += drawChar( CH_S, charPos, charSize, TC); charPos.x += .01 * Size;
		SetAA += drawChar( CH_A, charPos, charSize, TC); charPos.x += .01 * Size;
		SetAA += drawChar( CH_A, charPos, charSize, TC); charPos.x += .01 * Size;
		SetAA += drawChar( CH_SLSH, charPos, charSize, TC); charPos.x += .01 * Size;
		SetAA += drawChar( CH_A, charPos, charSize, TC); charPos.x += .01 * Size;
		SetAA += drawChar( CH_A, charPos, charSize, TC);
		//Set FoV
		charPos = float2( 0.009, 0.9025);
		SetFoV += drawChar( CH_S, charPos, charSize, TC); charPos.x += .01 * Size;
		SetFoV += drawChar( CH_E, charPos, charSize, TC); charPos.x += .01 * Size;
		SetFoV += drawChar( CH_T, charPos, charSize, TC); charPos.x += .01 * Size;
		SetFoV += drawChar( CH_BLNK, charPos, charSize, TC); charPos.x += .01 * Size;
		SetFoV += drawChar( CH_F, charPos, charSize, TC); charPos.x += .01 * Size;
		SetFoV += drawChar( CH_O, charPos, charSize, TC); charPos.x += .01 * Size;
		SetFoV += drawChar( CH_V, charPos, charSize, TC);
		//Read Help
		charPos = float2( 0.894, 0.9725);
		Read_Help += drawChar( CH_R, charPos, charSize, TC); charPos.x += .01 * Size;
		Read_Help += drawChar( CH_E, charPos, charSize, TC); charPos.x += .01 * Size;
		Read_Help += drawChar( CH_A, charPos, charSize, TC); charPos.x += .01 * Size;
		Read_Help += drawChar( CH_D, charPos, charSize, TC); charPos.x += .01 * Size;
		Read_Help += drawChar( CH_BLNK, charPos, charSize, TC); charPos.x += .01 * Size;
		Read_Help += drawChar( CH_H, charPos, charSize, TC); charPos.x += .01 * Size;
		Read_Help += drawChar( CH_E, charPos, charSize, TC); charPos.x += .01 * Size;
		Read_Help += drawChar( CH_L, charPos, charSize, TC); charPos.x += .01 * Size;
		Read_Help += drawChar( CH_P, charPos, charSize, TC);
		//New Start
		charPos = float2( 0.009, 0.018);
		// No Profile
		NoPro += drawChar( CH_N, charPos, charSize, TC); charPos.x += .01 * Size;
		NoPro += drawChar( CH_O, charPos, charSize, TC); charPos.x += .01 * Size;
		NoPro += drawChar( CH_BLNK, charPos, charSize, TC); charPos.x += .01 * Size;
		NoPro += drawChar( CH_P, charPos, charSize, TC); charPos.x += .01 * Size;
		NoPro += drawChar( CH_R, charPos, charSize, TC); charPos.x += .01 * Size;
		NoPro += drawChar( CH_O, charPos, charSize, TC); charPos.x += .01 * Size;
		NoPro += drawChar( CH_F, charPos, charSize, TC); charPos.x += .01 * Size;
		NoPro += drawChar( CH_I, charPos, charSize, TC); charPos.x += .01 * Size;
		NoPro += drawChar( CH_L, charPos, charSize, TC); charPos.x += .01 * Size;
		NoPro += drawChar( CH_E, charPos, charSize, TC); charPos.x = 0.009;
		//Not Compatible
		NotCom += drawChar( CH_N, charPos, charSize, TC); charPos.x += .01 * Size;
		NotCom += drawChar( CH_O, charPos, charSize, TC); charPos.x += .01 * Size;
		NotCom += drawChar( CH_T, charPos, charSize, TC); charPos.x += .01 * Size;
		NotCom += drawChar( CH_BLNK, charPos, charSize, TC); charPos.x += .01 * Size;
		NotCom += drawChar( CH_C, charPos, charSize, TC); charPos.x += .01 * Size;
		NotCom += drawChar( CH_O, charPos, charSize, TC); charPos.x += .01 * Size;
		NotCom += drawChar( CH_P, charPos, charSize, TC); charPos.x += .01 * Size;
		NotCom += drawChar( CH_A, charPos, charSize, TC); charPos.x += .01 * Size;
		NotCom += drawChar( CH_T, charPos, charSize, TC); charPos.x += .01 * Size;
		NotCom += drawChar( CH_I, charPos, charSize, TC); charPos.x += .01 * Size;
		NotCom += drawChar( CH_B, charPos, charSize, TC); charPos.x += .01 * Size;
		NotCom += drawChar( CH_L, charPos, charSize, TC); charPos.x += .01 * Size;
		NotCom += drawChar( CH_E, charPos, charSize, TC); charPos.x = 0.009;
		//Needs Fix/Mod
		Mod += drawChar( CH_N, charPos, charSize, TC); charPos.x += .01 * Size;
		Mod += drawChar( CH_E, charPos, charSize, TC); charPos.x += .01 * Size;
		Mod += drawChar( CH_E, charPos, charSize, TC); charPos.x += .01 * Size;
		Mod += drawChar( CH_D, charPos, charSize, TC); charPos.x += .01 * Size;
		Mod += drawChar( CH_S, charPos, charSize, TC); charPos.x += .01 * Size;
		Mod += drawChar( CH_BLNK, charPos, charSize, TC); charPos.x += .01 * Size;
		Mod += drawChar( CH_F, charPos, charSize, TC); charPos.x += .01 * Size;
		Mod += drawChar( CH_I, charPos, charSize, TC); charPos.x += .01 * Size;
		Mod += drawChar( CH_X, charPos, charSize, TC); charPos.x += .01 * Size;
		Mod += drawChar( CH_SLSH, charPos, charSize, TC); charPos.x += .01 * Size;
		Mod += drawChar( CH_M, charPos, charSize, TC); charPos.x += .01 * Size;
		Mod += drawChar( CH_O, charPos, charSize, TC); charPos.x += .01 * Size;
		Mod += drawChar( CH_D, charPos, charSize, TC); charPos.x = 0.009;
		//Overwatch.fxh Missing
		State += drawChar( CH_O, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_V, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_E, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_R, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_W, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_A, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_T, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_C, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_H, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_FSTP, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_F, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_X, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_H, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_BLNK, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_M, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_I, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_S, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_S, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_I, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_N, charPos, charSize, TC); charPos.x += .01 * Size;
		State += drawChar( CH_G, charPos, charSize, TC);
		//New Size
		float D3D_Size_A = 1.375,D3D_Size_B = 0.75;
		float2 charSize_A = float2(.00875, .0125) * D3D_Size_A, charSize_B = float2(.00875, .0125) * D3D_Size_B;
		//New Start Pos
		charPos = float2( 0.862, 0.018);
		//Depth3D.Info Logo/Website
		Depth3D += drawChar( CH_D, charPos, charSize_A, TC); charPos.x += .01 * D3D_Size_A;
		Depth3D += drawChar( CH_E, charPos, charSize_A, TC); charPos.x += .01 * D3D_Size_A;
		Depth3D += drawChar( CH_P, charPos, charSize_A, TC); charPos.x += .01 * D3D_Size_A;
		Depth3D += drawChar( CH_T, charPos, charSize_A, TC); charPos.x += .01 * D3D_Size_A;
		Depth3D += drawChar( CH_H, charPos, charSize_A, TC); charPos.x += .01 * D3D_Size_A;
		Depth3D += drawChar( CH_3, charPos, charSize_A, TC); charPos.x += .01 * D3D_Size_A;
		Depth3D += drawChar( CH_D, charPos, charSize_A, TC); charPos.x += 0.008 * D3D_Size_A;
		Depth3D += drawChar( CH_FSTP, charPos, charSize_A, TC); charPos.x += 0.01 * D3D_Size_A;
		charPos = float2( 0.963, 0.018);
		Depth3D += drawChar( CH_I, charPos, charSize_B, TC); charPos.x += .01 * D3D_Size_B;
		Depth3D += drawChar( CH_N, charPos, charSize_B, TC); charPos.x += .01 * D3D_Size_B;
		Depth3D += drawChar( CH_F, charPos, charSize_B, TC); charPos.x += .01 * D3D_Size_B;
		Depth3D += drawChar( CH_O, charPos, charSize_B, TC);
		//Text Information
		if(DS)
			Need = Needs;
		if(RH)
			Help = Read_Help;
		if(NW)
			Net = Work;
		if(PE)
			Post = Effect;
		if(DA)
			AA = SetAA;
		if(FV)
			FoV = SetFoV;
		//Blinking Text Warnings
		if(NP)
			No = NoPro * BT;
		if(NC)
			Not = NotCom * BT;
		if(NF)
			Fix = Mod * BT;
		if(OS)
			Over = State * BT;
		//Website
		return Depth3D+(Disable_Debug_Info ? 0 : Help+Post+No+Not+Net+Fix+Need+Over+AA+Set+FoV+Emu) ? Minimize_Web_Info ? lerp(Gradient + Depth3D,Color,saturate(Depth3D*0.98)) : Gradient : Color;
	}
	else
		return Color;
}

float4 BackBufferCG(float2 texcoords)
{   float4 C = tex2D(BackBufferPCGI,texcoords);
	float GS = dot(C.rgb,0.333);
	return float4(C.rgb,GS);
}

void CurrentFrame(float4 vpos : SV_Position, float2 texcoords : TEXCOORD, out float4 Color : SV_Target0, out float4 NormalsDepth : SV_Target1)
{
	float4 BBCG = BackBufferCG(texcoords);		
	float DI = Depth_Info(texcoords);
	Color = float4(BBCG.rgb,max(0.0, BBCG.w - lerp(0,1,saturate(Internals.w))));//,0, smoothstep(0,1,DI) > MaxDepth_Cutoff ) ;
	NormalsDepth = float4(DepthNormals(texcoords),DI);
}

void AccumulatedFramesGI(float4 vpos : SV_Position, float2 texcoords : TEXCOORD, out float4 acc : SV_Target)
{
	acc = tex2D(BackBufferPCGI,texcoords).rgba;
}

void PreviousFrames(float4 vpos : SV_Position, float2 texcoords : TEXCOORD, out float4 prev : SV_Target)
{	//float PD = dot(tex2D(PCGI_BGUVertical_Sample ,texcoords).rgb,0.333);
	prev = float4(0,0,0,DepthMap(texcoords, 0));
}

//////////////////////////////////////////////////////////Reshade.fxh/////////////////////////////////////////////////////////////
// Vertex shader generating a triangle covering the entire screen
void PostProcessVS(in uint id : SV_VertexID, out float4 position : SV_Position, out float2 texcoord : TEXCOORD)
{
	texcoord.x = (id == 2) ? 2.0 : 0.0;
	texcoord.y = (id == 1) ? 2.0 : 0.0;
	position = float4(texcoord * float2(2.0, -2.0) + float2(-1.0, 1.0), 0.0, 1.0);
}
//*Rendering passes*//
technique PCGI_One
< toggle = 0x23;
ui_tooltip = "Alpha: Disk-to-Disk Global Illumination Primary Generator.¹"; >
{
		pass PastFrames
	{
		VertexShader = PostProcessVS;
		PixelShader = PreviousFrames;
		RenderTarget = PCGIpastTex;
	}
		pass CopyFrame
	{
		VertexShader = PostProcessVS;
		PixelShader = CurrentFrame;
		RenderTarget0 = PCGIcurrColorTex;
		RenderTarget1 = PCGIcurrNormalsDepthTex;
	}
		pass SSGI
	{
		VertexShader = PostProcessVS;
		PixelShader = PCGI;
		RenderTarget = RadiantGITex;
	}
		pass Upsample
	{
		VertexShader = PostProcessVS;
		PixelShader = Upsample;
		RenderTarget0 = PCGIupsampleTex;
		RenderTarget1 = PCGIbackbufferTex;
	}
		pass TAA
	{
		VertexShader = PostProcessVS;
		PixelShader = GI_TAA;
	}
		pass AccumilateFrames
	{
		VertexShader = PostProcessVS;
		PixelShader = AccumulatedFramesGI;
		RenderTarget = PCGIaccuTex;
	}
}

technique PCGI_Two
< toggle = 0x23;
ui_tooltip = "Beta: Disk-to-Disk Global Illumination Secondary Output.²"; >
{
		pass Bilateral_Gaussian_Upscaling_H
	{
		VertexShader = PostProcessVS;
		PixelShader = BGU_Hoz;
		RenderTarget = PCGIHorizontalTex;
	}
		pass Bilateral_Gaussian_Upscaling_V
	{
		VertexShader = PostProcessVS;
		PixelShader = BGU_Ver;
		RenderTarget = PCGIVerticalTex;
	}
		pass Done
	{
		VertexShader = PostProcessVS;
		PixelShader = Out;
	}
}
