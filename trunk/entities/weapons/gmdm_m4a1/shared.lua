if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csbase";
SWEP.IsCSWeapon					= true; -- HVA Specific

SWEP.ViewModel					= "models/weapons/v_rif_m4a1.mdl"
SWEP.WorldModel					= "models/weapons/w_rif_m4a1.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_M4A1.Single" );
SWEP.Primary.Recoil				= 2.85;
SWEP.Primary.Damage				= 25;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.06;
SWEP.Primary.ClipSize			= 30;
SWEP.Primary.Delay				= 0.1;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= false;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 2.5;

SWEP.SupportsSilencer			= true;

SWEP.Primary.BurstShots			= 2;

SWEP.SprayAccuracy				= 0.65;
SWEP.SprayTime					= 0.7;

SWEP.VMPlaybackRate				= 10.0

SWEP.HasIronsights				= true; -- HVA Specific

SWEP.IronSightsPos = Vector (6.024, 0.4309, 0.8493)
SWEP.IronSightsAng = Vector (3.028, 1.3759, 3.5968)


SWEP.RunArmOffset = Vector (-1.8812, -4.5143, -5.7857)
SWEP.RunArmAngle = Vector (-22.4273, -62.3265, 58.8512)


SWEP.IronsightFOV				= 45; -- HVA Specific

-- HVA Run speed stuff
SWEP.WalkSpeed					= 0.8;
SWEP.RunSpeed					= 0.6;
SWEP.IronsightWalkSpeed			= 0.6;
SWEP.IronsightRunSpeed			= 0.2;

if( CLIENT ) then

	SWEP.PrintName			= "M4A1";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 1;
	
	SWEP.IconLetter			= "w";
	killicon.AddFont( "gmdm_m4a1", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end
