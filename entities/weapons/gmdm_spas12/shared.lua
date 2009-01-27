if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csshotgunbase";

SWEP.ViewModelFlip				= false;
SWEP.ViewModel					= "models/weapons/v_shotgun.mdl"
SWEP.WorldModel					= "models/weapons/w_shotgun.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_Shotgun.Single" );
SWEP.Primary.Recoil				= 1.6;
SWEP.Primary.Damage				= 29;
SWEP.Primary.NumShots			= 5;
SWEP.Primary.Cone				= 0.189;
SWEP.Primary.ClipSize			= 7;
SWEP.Primary.Delay				= 0.7;
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


SWEP.RunArmOffset = Vector (10.0682, -2.9016, 1.1332)
SWEP.RunArmAngle = Vector (-23.7883, 35.1369, -21.4271)


if( CLIENT ) then

	SWEP.PrintName			= "SPAS-12";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 1;
	
	SWEP.IconLetter			= "k";
	killicon.AddFont( "gmdm_m3s90", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end

SWEP.IronSightsPos = Vector (-8.9772, -7.246, 4.1928)
SWEP.IronSightsAng = Vector (-0.1231, 0.1177, 0)

SWEP.IronsightFOV				= 65; -- HVA Specific

