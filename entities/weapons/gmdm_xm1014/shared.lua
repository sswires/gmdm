if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csshotgunbase";

SWEP.ViewModel					= "models/weapons/v_shot_xm1014.mdl"
SWEP.WorldModel					= "models/weapons/w_shot_xm1014.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_XM1014.Single" );
SWEP.Primary.Recoil				= 2.3;
SWEP.Primary.Damage				= 35;
SWEP.Primary.NumShots			= 8;
SWEP.Primary.Cone				= 0.095;
SWEP.Primary.ClipSize			= 4;
SWEP.Primary.Delay				= 0.05;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= false;
SWEP.Primary.Ammo				= "buckshot";
SWEP.IronsightAccuracy			= 1.0;

SWEP.ReloadDelay				= 0.3;
SWEP.ReloadThenPump				= true;

-- HVA Run speed stuff
SWEP.WalkSpeed					= 1.0;
SWEP.RunSpeed					= 1.0;
SWEP.IronsightWalkSpeed			= 0.8;
SWEP.IronsightRunSpeed			= 0.6;

if( CLIENT ) then

	SWEP.PrintName			= "Benelli M4 Super 90\n(XM1014)";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 1;
	
	SWEP.IconLetter			= "B";
	killicon.AddFont( "gmdm_xm1014", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end

SWEP.IronSightsPos = Vector (5.1476, -4.3763, 2.1642)
SWEP.IronSightsAng = Vector (-0.1387, 0.6955, 0)

SWEP.IronsightFOV				= 65; -- HVA Specific
