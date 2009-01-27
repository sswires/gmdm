SWEP.IsCSWeapon					= true;
SWEP.Base						= "gmdm_csbase";

if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	SWEP.HoldType = "smg"
end

SWEP.ViewModel					= "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel					= "models/weapons/w_rif_ak47.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_AK47.Single" );
SWEP.Primary.Recoil				= 1.65;
SWEP.Primary.Damage				= 20;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.012;
SWEP.Primary.ClipSize			= 30;
SWEP.Primary.Delay				= 0.09;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 3.4;

SWEP.SprayAccuracy				= 0.65;
SWEP.SprayTime					= 0.7;

SWEP.HasIronsights				= true; -- HVA Specific
SWEP.IronSightsPos 				= Vector (6.1037, -2.9167, 2.2421);
SWEP.IronSightsAng 				= Vector (2.5866, 0.0362, -1.1592);
SWEP.IronsightsFOV				= 45; -- HVA Specific

SWEP.RunArmOffset = Vector (-1.6219, -1.356, -2.5605)
SWEP.RunArmAngle = Vector (-10.1816, -51.6568, 35.715)



-- HVA Run speed stuff
SWEP.WalkSpeed					= 0.82;
SWEP.RunSpeed					= 0.75;
SWEP.IronsightWalkSpeed			= 0.6;
SWEP.IronsightRunSpeed			= 0.2;

if( CLIENT ) then

	SWEP.PrintName			= "AK-47";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 1;
	
	SWEP.IconLetter			= "b";
	killicon.AddFont( "gmdm_ak47", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 )  );
	
end
