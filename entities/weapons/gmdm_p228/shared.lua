if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csbase";
SWEP.IsCSWeapon					= true;

SWEP.ViewModel					= "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel					= "models/weapons/w_pist_p228.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_P228.Single" );
SWEP.Primary.Recoil				= 0.7;
SWEP.Primary.Damage				= 9;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.025;
SWEP.Primary.ClipSize			= 12;
SWEP.Primary.Delay				= 0.13;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= false;
SWEP.Primary.Ammo				= "pistol";
SWEP.IronsightAccuracy			= 1.5;

SWEP.SprayAccuracy				= 1.0;
SWEP.SprayTime					= 0.0;

SWEP.HasIronsights				= true; -- HVA Specific

SWEP.IronSightsPos = Vector (4.7607, -2.2693, 2.9149)
SWEP.IronSightsAng = Vector (-0.7388, 0.0586, 0)



SWEP.IronsightsFOV				= 0; -- HVA Specific

-- HVA Run speed stuff
SWEP.WalkSpeed					= 1.0;
SWEP.RunSpeed					= 1.0;
SWEP.IronsightWalkSpeed			= 1.0;
SWEP.IronsightRunSpeed			= 1.0;

if( CLIENT ) then

	SWEP.PrintName			= "P228 Compact";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 5;
	
	SWEP.IconLetter			= "y";
	killicon.AddFont( "gmdm_p228", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end
