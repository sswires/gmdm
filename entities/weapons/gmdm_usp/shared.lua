if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csbase";
SWEP.IsCSWeapon					= true;

SWEP.ViewModel					= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel					= "models/weapons/w_pist_usp.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_USP.Single" );
SWEP.Primary.Recoil				= 0.75;
SWEP.Primary.Damage				= 7;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.01;
SWEP.Primary.ClipSize			= 12;
SWEP.Primary.Delay				= 0.15;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= false;
SWEP.Primary.Ammo				= "pistol";
SWEP.IronsightAccuracy			= 1.5;

SWEP.SupportsSilencer			= true;
SWEP.SilencedSound				= Sound( "Weapon_USP.Silenced" );

SWEP.SprayAccuracy				= 1.0;
SWEP.SprayTime					= 0.0;

SWEP.HasIronsights				= true; -- HVA Specific

SWEP.IronSightsPos = Vector (4.473, -2.2303, 2.7239)
SWEP.IronSightsAng = Vector (-0.2771, 0.0702, 0)

SWEP.IronsightsFOV				= 0; -- HVA Specific

-- HVA Run speed stuff
SWEP.WalkSpeed					= 1.0;
SWEP.RunSpeed					= 1.0;
SWEP.IronsightWalkSpeed			= 1.0;
SWEP.IronsightRunSpeed			= 1.0;

if( CLIENT ) then

	SWEP.PrintName			= "Heckler & Koch USP";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 5;
	
	SWEP.IconLetter			= "a";
	killicon.AddFont( "gmdm_usp", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end
