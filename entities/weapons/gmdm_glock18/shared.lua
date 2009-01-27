if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csbase";
SWEP.IsCSWeapon					= true;

SWEP.ViewModel					= "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel					= "models/weapons/w_pist_glock18.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_Glock.Single" );
SWEP.Primary.Recoil				= 0.9;
SWEP.Primary.Damage				= 10;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.03;
SWEP.Primary.ClipSize			= 15;
SWEP.Primary.Delay				= 0.18;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "pistol";
SWEP.IronsightAccuracy			= 1.5;

SWEP.SprayAccuracy				= 1.0;
SWEP.SprayTime					= 0.0;

SWEP.HasIronsights				= true; -- HVA Specific

SWEP.IronSightsPos = Vector (4.3618, -1.7181, 2.8266)
SWEP.IronSightsAng = Vector (0.4921, 0.0041, 0)


SWEP.IronsightsFOV				= 0; -- HVA Specific

-- HVA Run speed stuff
SWEP.WalkSpeed					= 1.0;
SWEP.RunSpeed					= 1.0;
SWEP.IronsightWalkSpeed			= 1.0;
SWEP.IronsightRunSpeed			= 1.0;

if( CLIENT ) then

	SWEP.PrintName			= "Glock-20C";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 5;
	
	SWEP.IconLetter			= "c";
	killicon.AddFont( "gmdm_glock18", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end
