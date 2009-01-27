if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csbase";
SWEP.IsCSWeapon					= true;

SWEP.ViewModel					= "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel					= "models/weapons/w_smg_mac10.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_mac10.Single" );
SWEP.Primary.Recoil				= 2.85;
SWEP.Primary.Damage				= 9.5;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.185;
SWEP.Primary.ClipSize			= 32;
SWEP.Primary.Delay				= 0.058;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 2.3;

SWEP.SprayAccuracy				= 0.9;
SWEP.SprayTime					= 0.3;

SWEP.HasIronsights				= true; -- HVA Specific

SWEP.VMPlaybackRate				= 20.0

SWEP.IronSightsPos = Vector (6.9362, -0.151, 2.812)
SWEP.IronSightsAng = Vector (1.0483, 5.2515, 6.6932)

SWEP.IronsightsFOV				= 60; -- HVA Specific

-- HVA Run speed stuff
SWEP.WalkSpeed					= 1.0;
SWEP.RunSpeed					= 1.0;
SWEP.IronsightWalkSpeed			= 1.0;
SWEP.IronsightRunSpeed			= 1.0;

if( CLIENT ) then

	SWEP.PrintName			= "MAC-10";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 5;
	
	SWEP.IconLetter			= "l";
	killicon.AddFont( "gmdm_mac10", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end
