if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csbase";
SWEP.IsCSWeapon					= true;

SWEP.ViewModel					= "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel					= "models/weapons/w_pist_deagle.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_Deagle.Single" );
SWEP.Primary.Recoil				= 1.82;
SWEP.Primary.Damage				= 30;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.035;
SWEP.Primary.ClipSize			= 7;
SWEP.Primary.Delay				= 0.12;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= false;
SWEP.Primary.Ammo				= "pistol";
SWEP.IronsightAccuracy			= 1.1;

SWEP.SprayAccuracy				= 1.0;
SWEP.SprayTime					= 0.0;

SWEP.HasIronsights				= true; -- HVA Specific

SWEP.IronSightsPos = Vector (5.1378, -2.6955, 2.6575)
SWEP.IronSightsAng = Vector (0.3551, -0.1281, 0.4)

SWEP.IronsightsFOV				= 0; -- HVA Specific

-- HVA Run speed stuff
SWEP.WalkSpeed					= 1.0;
SWEP.RunSpeed					= 1.0;
SWEP.IronsightWalkSpeed			= 1.0;
SWEP.IronsightRunSpeed			= 1.0;

if( CLIENT ) then

	SWEP.PrintName			= "Desert Eagle";		
	SWEP.Slot				= 2;
	SWEP.SlotPos			= 1;
	
	SWEP.IconLetter			= "f";
	killicon.AddFont( "gmdm_deagle", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end
