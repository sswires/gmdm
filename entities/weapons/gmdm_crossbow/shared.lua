
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end


SWEP.CustomSecondaryAmmo = true

if ( CLIENT ) then

	SWEP.CustomAmmoIcon = surface.GetTextureID( "hud/gmdm_icons/fireball" )

end

SWEP.Base				= "gmdm_base"
SWEP.PrintName			= "Crossbow"			
SWEP.Slot				= 3
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_crossbow.mdl"
SWEP.WorldModel			= "models/weapons/w_crossbow.mdl"
SWEP.Weight				= 4

local Launch_Sound = Sound("weapons/crossbow/bolt_fly4.wav")
local Fire_Sound = Sound("weapons/crossbow/fire1.wav")

function SWEP:Initialize()

	self:GMDMInit()
	self:SetWeaponHoldType( "shotgun" )
	
end

/*---------------------------------------------------------
   Name: FirstTimePickup
---------------------------------------------------------*/
function SWEP:FirstTimePickup( Owner )
	Owner:AddCustomAmmo( "Bolts", 10 )	
end


/*---------------------------------------------------------
   Name: HasUsableAmmo
---------------------------------------------------------*/
function SWEP:HasUsableAmmo()
	return self.Owner:GetCustomAmmo( "Bolts" ) > 0
end

SWEP.RunArmAngle  = Angle( 80, 0, 0 )
SWEP.RunArmOffset = Vector( 25, 7, 0 )

/*---------------------------------------------------------
   PRIMARY
   Semi Auto
---------------------------------------------------------*/

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

function SWEP:PrimaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.1 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 1.2 )

	if ( !self:CanShootWeapon() ) then return end	
	if ( self.Owner:GetCustomAmmo( "Bolts" ) < 1 ) then return end
	
	self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
	
	self.Weapon:EmitSound( Launch_Sound, 100, math.random(90,110) )
	self.Weapon:EmitSound( Fire_Sound, 100, math.random(90,110) )
	self.Owner:Recoil( -5, 0 )
	self:NoteGMDMShot()
	
	if ( SERVER ) then
	
		self.Owner:TakeCustomAmmo( "Bolts", 1 )	
	
		local bolt = ents.Create( "flechette_bolt" )
			bolt:SetPos( self.Owner:GetShootPos() )
			bolt:SetOwner( self.Owner )
			bolt:SetAngles(self.Owner:GetAimVector():Angle())
		bolt:Spawn()
		
		self:CheckRedundancy()
		
	end

end


/*---------------------------------------------------------
   SECONDARY
   Automatic (Uses Primary Ammo)
---------------------------------------------------------*/

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:SecondaryAttack()
end


function SWEP:CustomAmmoCount()

	if ( !ValidEntity( self.Owner ) ) then return 0 end
	return self.Owner:GetCustomAmmo( "Bolts" )
	
end

