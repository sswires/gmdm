
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end


SWEP.CustomSecondaryAmmo = true

if ( CLIENT ) then

	SWEP.CustomAmmoIcon = surface.GetTextureID( "hud/gmdm_icons/fireball" )

end

SWEP.Base				= "gmdm_base"
SWEP.PrintName			= "#Rail Gun"			
SWEP.Slot				= 4
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_IRifle.mdl"
SWEP.WorldModel			= "models/weapons/w_IRifle.mdl"
SWEP.Weight				= 8

local ShootSound = Sound( "Weapon_Pistol.NPC_Single" )
local Launch_Sound = Sound( "Weapon_AR2.NPC_Double" )

function SWEP:Initialize()

	self:GMDMInit()
	self:SetWeaponHoldType( "smg" )
	
end

SWEP.RunArmAngle  = Angle( 60, 00, 0 )
SWEP.RunArmOffset = Vector( 25, 0, -10 )

/*---------------------------------------------------------
   Name: FirstTimePickup
   Desc: First time this respawner weapon has been picked up
		 (Use this to give them ammo)
---------------------------------------------------------*/
function SWEP:FirstTimePickup( Owner )
	Owner:AddCustomAmmo( "Rails", 16 )	
end

function RailGunCallback( attacker, tr, dmginfo )
	
	if( !SERVER ) then return end
	
	local hitEnt = tr.Entity;
	
	if( hitEnt and hitEnt:IsPlayer() ) then
		if( util.tobool( GetConVarNumber( "gmdm_headshotmode" ) ) == true and tr.HitGroup != HITGROUP_HEAD ) then return end
		if( gmdm_teamplay:GetBool() == true and util.tobool( GetConVarNumber( "mp_friendlyfire" ) ) == false and hitEnt:Team() == attacker:Team() ) then return end
		-- we hit a player
		--local attacker = dmginfo:GetAttacker()
		
		if( attacker and attacker:IsValid() and attacker:IsPlayer() ) then
			local vDir = dmginfo:GetReportedPosition() - tr.HitPos
			timer.Simple( 0.01, MakeRailCallbackBullet, attacker, tr.HitPos, tr.Normal )
		end
	end
end

function MakeRailCallbackBullet( pl, src, dir )
	local bullet = 
	{	
		Num 		= 1,
		Src 		= src,
		Dir 		= dir,	
		Spread 		= Vector( math.Rand( 0, 0.2 ),math.Rand( 0, 0.2 ),math.Rand( 0, 0.5 ) ),
		Tracer		= 1,
		TracerName 	= "railgun_tracer",
		Force		= 1000,
		Damage		= 1000,
		AmmoType 	= "Pistol",
		HullSize	= 1,
		Callback	= RailGunCallback
	}
		
	pl:FireBullets( bullet )
end

function DoKillSpreeCheck( pl )
	local killsthen = pl.FragsThen;
	local killsnow = pl:Frags()
	
	if( killsnow > killsthen ) then
		local diff = killsnow - killsthen
		
		if( diff == 2 ) then
			GMDM_PrintCenterAll( pl:Name() .. " got a double kill!" )
			Msg("2")
		elseif( diff == 3 ) then
			GMDM_PrintCenterAll( pl:Name() .. " got a triple kill!" )
			Msg("3")
		elseif( diff > 3 ) then
			GMDM_PrintCenterAll( pl:Name() .. " ultra-kill - " .. tostring( diff ) .. " simulataneous kills!" )
			Msg("more")
		end
	end
end

/*---------------------------------------------------------
   PRIMARY
   Semi Auto
---------------------------------------------------------*/

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + 1.5 )

	if ( !self:CanShootWeapon() ) then return end	
	if ( self.Owner:GetCustomAmmo( "Rails" ) < 1 ) then return end
	
	self.Weapon:EmitSound( Launch_Sound )
	self.Owner:Recoil( -5, 0 )
	self:NoteGMDMShot()
	
	if ( SERVER ) then
		self.Owner:TakeCustomAmmo( "Rails", 1 )	
		self.Owner.FragsThen = self.Owner:Frags()
		timer.Simple( 0.5, DoKillSpreeCheck, self.Owner )
	end
	
	local bullet = 
	{	
		Num 		= 1,
		Src 		= self.Owner:GetShootPos(),
		Dir 		=  self.Owner:GetAimVector(),	
		Spread 		= Vector( 0, 0, 0 ),
		Tracer		= 1,
		TracerName 	= "railgun_tracer",
		Force		= 1000,
		Damage		= 1000,
		AmmoType 	= "Pistol",
		HullSize	= 3,
		Callback	= RailGunCallback
	}
		
	self.Owner:FireBullets( bullet )
	
	if ( SERVER ) then
		self:CheckRedundancy()
	end
	
	if ( CLIENT ) then
	
		ColorModify[ "$pp_colour_addr" ] = 0.2
		ColorModify[ "$pp_colour_addg" ] = 0.2
	
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

	self:SetNextSecondaryFire( CurTime() + 0.1 )
	
	if (!SERVER) then return end

	if ( self.Zoomed ) then
	
		// Reset Zoom
		self.Owner:SetFOV( 0, 0.2 )
	
	else
	
		self.Owner:SetFOV( 20, 0.2 )
	
	end
	
	self.Zoomed = !self.Zoomed

end


function SWEP:CustomAmmoCount()

	if ( !ValidEntity( self.Owner ) ) then return 0 end
	return self.Owner:GetCustomAmmo( "Rails" )
	
end

/*---------------------------------------------------------
   Name: HasUsableAmmo
---------------------------------------------------------*/
function SWEP:HasUsableAmmo()
	return self:CustomAmmoCount() > 0
end

/*---------------------------------------------------------
   Name: AdjustMouseSensitivity()
   Desc: Allows you to adjust the mouse sensitivity.
---------------------------------------------------------*/
function SWEP:AdjustMouseSensitivity()

	local fov = self.Owner:GetFOV()

	return (fov / 90) ^ 1.2
	
end
