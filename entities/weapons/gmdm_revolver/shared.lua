if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csbase";
SWEP.IsCSWeapon					= true;
SWEP.ViewModelFlip				= false;

SWEP.ViewModel					= "models/weapons/v_357.mdl"
SWEP.WorldModel					= "models/weapons/w_357.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_357.Single" );
SWEP.Primary.Recoil				= 3.92;
SWEP.Primary.Damage				= 50;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.015;
SWEP.Primary.ClipSize			= 6;
SWEP.Primary.Delay				= 0.18;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= false;
SWEP.Primary.Ammo				= "pistol";
SWEP.IronsightAccuracy			= 1.1;

SWEP.SprayAccuracy				= 1.0;
SWEP.SprayTime					= 0.0;

SWEP.HasIronsights				= true; -- HVA Specific


SWEP.IronSightsPos = Vector (-5.7042, -8.1369, 2.6289)
SWEP.IronSightsAng = Vector (0.0996, -0.2276, 1.6423)


SWEP.RunArmOffset = Vector (5.136, -1.946, 7.4864)
SWEP.RunArmAngle = Vector (-24.4546, 45.5465, 0)


SWEP.IronsightsFOV				= 0; -- HVA Specific

-- HVA Run speed stuff
SWEP.WalkSpeed					= 1.0;
SWEP.RunSpeed					= 1.0;
SWEP.IronsightWalkSpeed			= 1.0;
SWEP.IronsightRunSpeed			= 1.0;

if( CLIENT ) then

	SWEP.PrintName			= "Revolver";		
	SWEP.Slot				= 2;
	SWEP.SlotPos			= 1;
	
	SWEP.IconLetter			= ".";
	killicon.AddFont( "gmdm_revolver", "HL2MPTypeDeath", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end
