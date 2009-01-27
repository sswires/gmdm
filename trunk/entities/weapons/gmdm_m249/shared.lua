if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csbase";
SWEP.IsCSWeapon					= true; -- HVA Specific
SWEP.ViewModelFlip				= false;

SWEP.ViewModel					= "models/weapons/v_mach_m249para.mdl"
SWEP.WorldModel					= "models/weapons/w_mach_m249para.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_M249.Single" );
SWEP.Primary.Recoil				= 0.95;
SWEP.Primary.Damage				= 25;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.19;
SWEP.Primary.ClipSize			= 100;
SWEP.Primary.Delay				= 0.085;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 2.5;

SWEP.SprayAccuracy				= 0.93;
SWEP.SprayTime					= 0.2;

SWEP.HasIronsights				= true; -- HVA Specific
SWEP.IronSightsPos 				= Vector (-4.3798, -1.8776, 1.8157)
SWEP.IronSightsAng 				= Vector (0.9423, 0.2617, 0.2333)
SWEP.IronsightFOV				= 50; -- HVA Specific

SWEP.RunArmOffset = Vector (4.3993, -3.5007, 3.6905)
SWEP.RunArmAngle = Vector (-12.5777, 55.7671, 18.7486)


-- HVA Run speed stuff
SWEP.WalkSpeed					= 0.8;
SWEP.RunSpeed					= 0.9;
SWEP.IronsightWalkSpeed			= 0.5;
SWEP.IronsightRunSpeed			= 0.5;

SWEP.PenetrationMax = 128;
SWEP.PenetrationMaxWood = 256;

if( CLIENT ) then

	SWEP.PrintName			= "M249 SAW";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 1;
	
	SWEP.IconLetter			= "z";
	killicon.AddFont( "gmdm_m249", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
	
end
