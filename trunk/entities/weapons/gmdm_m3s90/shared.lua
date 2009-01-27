if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csshotgunbase";

SWEP.ViewModel					= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel					= "models/weapons/w_shot_m3super90.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_M3.Single" );
SWEP.Primary.Recoil				= 1.3;
SWEP.Primary.Damage				= 25;
SWEP.Primary.NumShots			= 5;
SWEP.Primary.Cone				= 0.085;
SWEP.Primary.ClipSize			= 7;
SWEP.Primary.Delay				= 1.0;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= false;
SWEP.Primary.Ammo				= "buckshot";
SWEP.IronsightAccuracy			= 1.0;

SWEP.ReloadDelay				= 0.45;
SWEP.ReloadThenPump				= true;

-- HVA Run speed stuff
SWEP.WalkSpeed					= 1.0;
SWEP.RunSpeed					= 1.0;
SWEP.IronsightWalkSpeed			= 0.8;
SWEP.IronsightRunSpeed			= 0.6;

if( CLIENT ) then

	SWEP.PrintName			= "Benelli M3 Super 90";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 1;
	
	SWEP.IconLetter			= "k";
	killicon.AddFont( "gmdm_m3s90", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end



SWEP.IronSightsPos = Vector (5.7266, -2.9373, 3.3522)
SWEP.IronSightsAng = Vector (0.1395, -0.0055, -0.4603)


SWEP.IronsightFOV				= 65; -- HVA Specific

