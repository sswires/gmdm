if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csbase";
SWEP.IsCSWeapon					= false; -- HVA Specific
SWEP.ViewModelFlip				= false;
SWEP.ViewModelFOV				= 60;

SWEP.ViewModel					= "models/weapons/v_thompson.mdl"
SWEP.WorldModel					= "models/weapons/w_thompson.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_Thompson.Shoot" );
SWEP.Primary.Recoil				= 0.65;
SWEP.Primary.Damage				= 30;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.08;
SWEP.Primary.ClipSize			= 20;
SWEP.Primary.Delay				= 0.10;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 2.8;

SWEP.SprayAccuracy				= 0.6;
SWEP.SprayTime					= 0.5;

SWEP.RunArmOffset = Vector (10.4268, 0.6154, -0.5153)
SWEP.RunArmAngle = Vector (-4.1586, 48.5377, -1.9256)

SWEP.HasIronsights				= true; -- HVA Specific


SWEP.IronSightsPos = Vector (-4.5216, 0.1203, 2.0072)
SWEP.IronSightsAng = Vector (0.1597, 0.0441, -0.2408)


SWEP.IronsightFOV				= 54; -- HVA Specific

-- HVA Run speed stuff
SWEP.WalkSpeed					= 1.0;
SWEP.RunSpeed					= 1.0;
SWEP.IronsightWalkSpeed			= 0.7;
SWEP.IronsightRunSpeed			= 0.7;

if( CLIENT ) then

	SWEP.PrintName			= "Thompson";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 2;
	
	SWEP.IconLetter			= "3";
	killicon.AddFont( "weapon_mp44", "HVADODKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end
