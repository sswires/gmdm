SWEP.IsCSWeapon					= false;
SWEP.Base						= "gmdm_csbase";

if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	SWEP.HoldType = "smg"
end

SWEP.ViewModel					= "models/weapons/v_rif_galil.mdl"
SWEP.WorldModel					= "models/weapons/w_rif_galil.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_Galil.Single" );
SWEP.Primary.Recoil				= 1.35;
SWEP.Primary.Damage				= 15;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.05;
SWEP.Primary.ClipSize			= 30;
SWEP.Primary.Delay				= 0.05;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 4.4;

SWEP.SprayAccuracy				= 0.65;
SWEP.SprayTime					= 0.7;

SWEP.HasIronsights				= true; -- HVA Specific

SWEP.IronSightsPos = Vector (-5.154, -5.1506, 2.256)
SWEP.IronSightsAng = Vector (-0.0459, 0.082, 0.2265)


SWEP.IronsightsFOV				= 45; -- HVA Specific

SWEP.RunArmOffset = Vector (3.6879, 0.7372, 1.3623)
SWEP.RunArmAngle = Vector (-23.0292, 31.9094, -22.2724)



-- HVA Run speed stuff
SWEP.WalkSpeed					= 0.82;
SWEP.RunSpeed					= 0.75;
SWEP.IronsightWalkSpeed			= 0.6;
SWEP.IronsightRunSpeed			= 0.2;

if( CLIENT ) then

	SWEP.PrintName			= "Galil";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 1;
	SWEP.ViewModelFlip		= false;
	
	SWEP.IconLetter			= "v";
	killicon.AddFont( "gmdm_galil", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end
