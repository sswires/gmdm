if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csbase";
SWEP.IsCSWeapon					= true; -- HVA Specific

SWEP.ViewModelFlip				= false;

SWEP.ViewModel					= "models/weapons/v_rif_famas.mdl"
SWEP.WorldModel					= "models/weapons/w_rif_famas.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_Famas.Single" );
SWEP.Primary.Recoil				= 2.35;
SWEP.Primary.Damage				= 20;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.02;
SWEP.Primary.ClipSize			= 30;
SWEP.Primary.Delay				= 0.1;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= false;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 2.5;

SWEP.Primary.BurstShots			= 2;

SWEP.SprayAccuracy				= 0.65;
SWEP.SprayTime					= 0.7;

SWEP.HasIronsights				= false; -- HVA Specific

-- HVA Run speed stuff
SWEP.WalkSpeed					= 0.8;
SWEP.RunSpeed					= 0.6;
SWEP.IronsightWalkSpeed			= 0.6;
SWEP.IronsightRunSpeed			= 0.2;


SWEP.RunArmOffset = Vector (0.8129, 0, 3.6122)
SWEP.RunArmAngle = Vector (-22.188, 39.0871, 0)


if( CLIENT ) then

	SWEP.PrintName			= "FAMAS";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 1;
	
	SWEP.IconLetter			= "t";
	killicon.AddFont( "gmdm_famas", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end
