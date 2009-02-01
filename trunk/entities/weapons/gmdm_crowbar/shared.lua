
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Base				= "gmdm_base"
SWEP.PrintName			= "Crowbar"			
SWEP.Slot				= 0
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_crowbar.mdl"
SWEP.WorldModel			= "models/weapons/w_crowbar.mdl"

function SWEP:Initialize( )
	self:GMDMInit()
	self:SetWeaponHoldType( "melee" )	
end

function SWEP:HasUsableAmmo( )
	return true
end

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.CanSprintAndShoot		= true;

SWEP.ConstantAccuracy	= true
SWEP.Primary.Cone		= 0.0;

function SWEP:PrimaryAttack( )
	
	if not self:CanShootWeapon( ) then return end
	
	local bKillAnim = false;
	local vShootPos = self.Owner:GetShootPos()
	local vDirection = self.Owner:GetAimVector()
	
	self.Weapon:EmitSound( "Weapon_Crowbar.Single" )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	--if( SERVER ) then
		local tTraceData = {}
		tTraceData = util.GetPlayerTrace( self.Owner );
		
		local tTraceRes = util.TraceLine( tTraceData )
		--local hitEnt = self.Owner:TraceHullAttack( vShootPos, vShootPos + ( vDirection * 50 ), Vector( -16, -16, -16 ), Vector( 36, 36, 36 ), 25, DMG_CLUB, 5 )

		if( tTraceRes.Entity == nil ) then
			Msg( "hitent was nil\n" )
		elseif( tTraceRes.Entity and ( tTraceRes.HitPos - self.Owner:GetPos() ):Length() < 95 ) then
			local hitEnt = tTraceRes.Entity;
			
			if( tTraceRes.HitWorld ) then
		
				local effectdata = EffectData()
				effectdata:SetEntity( hitEnt )
				effectdata:SetOrigin( tTraceRes.HitPos )
				effectdata:SetNormal( tTraceRes.HitNormal )
				effectdata:SetScale( 0.5 );
				util.Effect( "hitsmoke", effectdata )
				
				local effectdata = EffectData()
				effectdata:SetEntity( hitEnt )
				effectdata:SetOrigin( tTraceRes.HitPos )
				effectdata:SetNormal( tTraceRes.HitNormal )
				util.Effect( "Impact", effectdata )
				
			elseif( hitEnt:IsPlayer() or hitEnt:IsNPC() ) then
				
				if( SERVER ) then
					local multiplier = GAMEMODE:GetHitboxMulti( tTraceRes.HitGroup )
					hitEnt:TakeDamage( 35 * multiplier, self.Owner, self.Weapon )
					
					if( 35 * multiplier >= hitEnt:Health() ) then
						bKillAnim = true;
					end
				end
				
				local effectdata = EffectData()
				effectdata:SetEntity( hitEnt )
				effectdata:SetOrigin( tTraceRes.HitPos )
				effectdata:SetNormal( tTraceRes.HitNormal )
				util.Effect( "bodyshot", effectdata )
				
				self:EmitSound( "physics/flesh/flesh_squishy_impact_hard3.wav", 120, 100 )
			end
			
			if( kKillAnim ) then
				self.Weapon:SendWeaponAnim( ACT_VM_HITKILL )
			else
				self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
			end
		else
			self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
		end
	--end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )
	
end

function SWEP:Reload( )
	return
end

function SWEP:SecondaryAttack( )
	self:PrimaryAttack( )
end
