if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csbase";
SWEP.IsCSWeapon					= true;

SWEP.ViewModel					= "models/weapons/v_smg_ump45.mdl"
SWEP.WorldModel					= "models/weapons/w_smg_ump45.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_UMP45.Single" );
SWEP.Primary.Recoil				= 1.35;
SWEP.Primary.Damage				= 6.3;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.033;
SWEP.Primary.ClipSize			= 30;
SWEP.Primary.Delay				= 0.092;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 1.8;

SWEP.SprayAccuracy				= 0.9;
SWEP.SprayTime					= 0.3;

SWEP.HasIronsights				= true; -- HVA Specific

SWEP.IronSightsPos = Vector (7.3048, -3.8881, 3.1879)
SWEP.IronSightsAng = Vector (-1.2547, 0.2029, 1.6303)


SWEP.IronsightsFOV				= 60; -- HVA Specific

-- HVA Run speed stuff
SWEP.WalkSpeed					= 1.0;
SWEP.RunSpeed					= 1.0;
SWEP.IronsightWalkSpeed			= 1.0;
SWEP.IronsightRunSpeed			= 1.0;

if( CLIENT ) then

	SWEP.PrintName			= "UMP-45";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 5;
	
	SWEP.IconLetter			= "q";
	killicon.AddFont( "gmdm_ump45", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end
