
if (SERVER) then
	AddCSLuaFile( "shared.lua" )
end

if ( CLIENT ) then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	
	if( GAMEMODE.FOVModifier <= 0 ) then
		SWEP.ViewModelFOV		= 65;
	else
		SWEP.ViewModelFOV		= 75
	end

	surface.CreateFont( "csd", 64, 500, true, true, "HVACSKillIcons" );
	surface.CreateFont( "Day of Defeat Logo", 58, 500, true, true, "HVADODKillIcons" );
end

SWEP.Base						= "gmdm_base";
SWEP.Author						= "SteveUK";
SWEP.Contact					= "stephen.swires@gmail.com";
SWEP.Purpose					= "CCTF Weapon";
SWEP.Instructions				= "To defeat the cyberdemon, shoot at it until it dies.";

SWEP.Category					= "Combat CTF";

SWEP.HoldType					= "ar2"

SWEP.IsCSWeapon					= true;
SWEP.ViewModel					= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel					= "models/weapons/w_pist_usp.mdl"

if( CLIENT and SWEP.IsCSWeapon == true ) then
	SWEP.ViewModelFlip		= true;
	SWEP.CSMuzzleFlashes	= true;
else
	SWEP.ViewModelFlip		= false;
	SWEP.CSMuzzleFlashes	= false;
end

SWEP.Primary.Sound				= Sound( "Weapon_AK47.Single" );
SWEP.Primary.Recoil				= 0.75;
SWEP.Primary.Damage				= 50;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.01;
SWEP.Primary.Delay				= 0.4;

SWEP.SilencedSound				= Sound( "Weapon_M4A1.Silenced" );

SWEP.Primary.BurstShots			= 0;
SWEP.Primary.BurstDelay			= 0.08;

SWEP.Primary.Automatic			= true
SWEP.Primary.ClipSize			= 30;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= false;
SWEP.Primary.Ammo				= "smg1";

SWEP.VMPlaybackRate				= 1.0

SWEP.HasIronsights				= true; -- HVA Specific
SWEP.IronsightsFOV				= 45; -- HVA Specific
SWEP.IronsightAccuracy			= 5; -- what to divide spread by to increase accuracy
SWEP.StopIronsightsAfterShot	= false;
SWEP.IronsightFOVSpeed			= 0.25;
SWEP.IronsightDelayFOV			= false;

SWEP.SprayAccuracy				= 0.8;
SWEP.SprayTime					= 0.4;

SWEP.ReloadSpeedMultiplier		= 1.0;

-- HVA Run speed stuff
SWEP.WalkSpeed					= 1.0;
SWEP.RunSpeed					= 1.0;
SWEP.IronsightWalkSpeed			= 0.6;
SWEP.IronsightRunSpeed			= 0.6;

function SWEP:Deploy()

	if( SERVER ) then
		if( self.Owner ) then
			GAMEMODE:SetPlayerSpeed( self.Owner, GAMEMODE.PlayerWalkSpeed * self.WalkSpeed, GAMEMODE.PlayerRunSpeed * self.RunSpeed );
		end
		
		if( self.Weapon ) then
			if( self.SupportsSilencer and self.Weapon:GetNetworkedBool( "Silenced" ) == true ) then
				self.Weapon:SendWeaponAnim( ACT_VM_DRAW_SILENCED )
			else
				self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
			end
		end
	end
	
	self:SetIronsights( false );
		
	return self.BaseClass:Deploy();
end

function SWEP:Holster()

	if( self.Owner ) then
		GAMEMODE:SetPlayerSpeed( self.Owner, GAMEMODE.PlayerWalkSpeed, GAMEMODE.PlayerRunSpeed );
	end
	
	self:SetIronsights( false );
	return self.BaseClass:Holster();
end

function SWEP:Initialize()

	if ( SERVER ) then
		self:SetWeaponHoldType( self.HoldType );
		self:SetNPCMinBurst( self.Primary.ClipSize );
		self:SetNPCMaxBurst( self.Primary.ClipSize );
		self:SetNPCFireRate( self.Primary.Delay );
	end
	
	self.Weapon:SetNetworkedBool( "Ironsights", false );
	
	local printname = self.PrintName or self:GetClass()
	pickup:SimpleAdd( self:GetClass(), printname, self.WorldModel, self.Primary.Ammo, self.Primary.DefaultClip/2, false )
	
end

function SWEP:Reload()
	if( self.Weapon:Clip1() < self.Primary.ClipSize ) then		
		local timenow = CurTime();
		
		if( self.SupportsSilencer and self.Weapon:GetNetworkedBool( "Silenced", false ) ) then
			self.Weapon:DefaultReload( ACT_VM_RELOAD_SILENCED );
		else
			self.Weapon:DefaultReload( ACT_VM_RELOAD );
		end
		
		self:SetIronsights( false );
		self.Owner:SetFOV( 0, 0.25 );
		
		if( self.ReloadSpeedMultiplier != 1.0 ) then
			local diff = self.Owner:GetViewModel():SequenceDuration();
			
			local newtime = diff/self.ReloadSpeedMultiplier;
			
			self.Owner:GetViewModel():SetPlaybackRate( self.ReloadSpeedMultiplier );
			self.Weapon:SetNextPrimaryFire( CurTime())
			self.Weapon:SetNextSecondaryFire( CurTime() )
		end
	end
end

function SWEP:GetStanceAccuracyBonus( )

	if( self.Owner:IsNPC() ) then
		return 0.8;
	end
	
	local LastAccuracy = self.LastAccuracy or 0;
	local Accuracy = 1.0;
	local LastShoot = self.LastAttack;
	
	local speed = math.ceil( self.Owner:GetVelocity():Length() / 100 ) * 100
	-- 200 walk, 500 sprint, 705 noclip
	local speedperc = math.Clamp( math.abs( speed / 705 ), 0, 1 );	
	
	if( self.Weapon:GetNetworkedBool( "Ironsights", false ) == true ) then
		Accuracy = Accuracy * self.IronsightAccuracy;
	end
	
	if( CurTime() <= LastShoot + self.SprayTime ) then
		Accuracy = Accuracy * self.SprayAccuracy;
	end
	
	if( speed > 10 ) then -- moving
		Accuracy = Accuracy * ( ( ( 1 - speedperc ) + 0.1 ) / 1.5 );
	end
	
	if( self.Owner:KeyDown( IN_DUCK ) == true ) then -- ducking moving forward
		Accuracy = Accuracy * 1.50;
	end

	if( self.Owner:KeyDown( IN_LEFT ) or self.Owner:KeyDown( IN_RIGHT ) ) then -- just strafing
		Accuracy = Accuracy * 0.95;
	end
	
	if( LastAccuracy != 0 ) then
		if( Accuracy > LastAccuracy ) then
			Accuracy = math.Approach( self.LastAccuracy, Accuracy, FrameTime() * 2 )
		else
			Accuracy = math.Approach( self.LastAccuracy, Accuracy, FrameTime() * -2 )
		end
	end
	
	self.LastAccuracy = Accuracy;
	return Accuracy;
	
end

SWEP.LastAttack = 0;

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	if( self.Weapon:Clip1() <= 0 ) then
		self:Reload()
		return;
	end	
	
	if( !self:CanShootWeapon() ) then return end
	
	if( self.Owner:IsPlayer() ) then self.Owner:LagCompensation( true ) end
	
	if( self.HasIronsights == false ) then
		self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay ); -- only disallow secondary attack if we don't have ironsights on our weapon
	end
	
	local DeltaAttack = CurTime() - self.LastAttack;

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay + (self.Primary.BurstShots * self.Primary.BurstDelay) )
	
	if ( !self:CanPrimaryAttack() ) then
		return;
	end
	
	local sound = self.Primary.Sound;
	
	if( self.SupportsSilencer == true and self.Weapon:GetNetworkedBool( "Silenced" ) == true ) then
		sound = self.SilencedSound;
	end
	
	// Play shoot sound
	self.Weapon:EmitSound( sound )
	
	local fDamage, fRecoil, iBullets, fAimCone = 0, 0, self.Primary.NumShots, 0;
	
	// Shoot the bullet
	fDamage = ( self.Primary.Damage * math.random( 1.0, 1.25 ) ) * math.Clamp( self:GetStanceAccuracyBonus(), 0.8, 1.3 );
	fRecoil = ( self.Primary.Recoil / self:GetStanceAccuracyBonus() )
	fAimCone = (self.Primary.Cone / self:GetStanceAccuracyBonus())
		
	self:GMDMShootBullet( fDamage, nil, -fRecoil, 0, iBullets, fAimCone )
	
	if( self.Primary.BurstShots > 0 ) then
		local x = 0;
		while( x < self.Primary.BurstShots ) do
			x = x + 1;
			
			if( self.Weapon:Clip1() - x > 0 ) then
				timer.Simple( self.Primary.BurstDelay * x, self.GMDMShootBullet, self, fDamage, nil, -fRecoil, 0, iBullets, fAimCone );
				timer.Simple( self.Primary.BurstDelay * x, self.Weapon.EmitSound, self.Weapon, sound )
				timer.Simple( self.Primary.BurstDelay * x, self.TakePrimaryAmmo, self, 1 )
			end
		end
	end
	
	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )
	
	if( bIron ) then
		if( self.StopIronsightsAfterShot == true ) then
			self:SetIronsights( false )
		end
		
		self.Owner:GetViewModel():SetPlaybackRate( self.VMPlaybackRate )  
	end
		
	// Remove 1 bullet from our clip
	self:TakePrimaryAmmo( 1 )
	
	if ( self.Owner:IsNPC() ) then return end
	
	// Punch the player's view
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	
	// In singleplayer this function doesn't get called on the client, so we use a networked float
	// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
	// send the float.
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	
	self.LastAttack = CurTime();
		
	if( self.Owner:IsPlayer() ) then self.Owner:LagCompensation( false ) end
end

function SWEP:SecondaryAttack()
	
	if ( !self.IronSightsPos ) then return end
	if ( self.Owner:KeyDown( IN_SPEED ) ) then return end

	if( self.SupportsSilencer == true and self.Owner and self.Owner:IsPlayer() and self.Owner:KeyDown( IN_USE ) ) then
		local silenced = self.Weapon:GetNetworkedBool( "Silenced", false )
		
		if( !silenced ) then
			self.Weapon:SendWeaponAnim( ACT_VM_ATTACH_SILENCER )
		else
			self.Weapon:SendWeaponAnim( ACT_VM_DETACH_SILENCER )
		end
		
		self.Weapon:SetNetworkedBool( "Silenced", !silenced )
		return
	end
	
	bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )
	
	self:SetIronsights( bIronsights )
	
	self.NextSecondaryAttack = CurTime() + 0.3
	
end

function SWEP:SetFOV( fov, delay, ironsightcheck )

	if not ironsightcheck then
		ironsightcheck = false
	end
	
	if( self.Owner and self.Weapon and self.Owner:IsPlayer() ) then
	
		if( ironsightcheck == true and self.Weapon:GetNetworkedBool( "Ironsights" )	 == false ) then
			return
		end
		
		local active = self.Owner:GetActiveWeapon()
		
		if( active and active:IsValid() ) then
			if( active == self.Weapon ) then
				self.Owner:SetFOV( fov, delay );
			end
		end
	end
end

function SWEP:SetIronsights( b )

	if( SERVER ) then
		if( self.HasIronsights == true and self.Owner ) then
			if( b == true ) then
				if( self.IronsightDelayFOV ) then
					local delay = self.ScopeTime or 0.25;
					timer.Simple( delay, self.SetFOV, self, self.IronsightsFOV, 0, true );
				else
					self.Owner:SetFOV( self.IronsightsFOV, self.IronsightFOVSpeed );
				end
				
				GAMEMODE:SetPlayerSpeed( self.Owner, GAMEMODE.PlayerWalkSpeed * self.IronsightWalkSpeed, GAMEMODE.PlayerRunSpeed * self.IronsightRunSpeed );
			else
				self.Owner:SetFOV( 0, 0.2 );
				GAMEMODE:SetPlayerSpeed( self.Owner, GAMEMODE.PlayerWalkSpeed * self.WalkSpeed, GAMEMODE.PlayerRunSpeed * self.RunSpeed );
			end
		end
		
		if( self.Weapon ) then
			self.Weapon:SetNetworkedBool( "Ironsights", b )
		end
	end
	
end

function SWEP:Think()
	if( self.Weapon:GetNetworkedBool( "Ironsights" ) == true and self.Owner:KeyDown( IN_SPEED ) ) then
		self:SetIronsights( false )
	end
end


local IRONSIGHT_TIME = 0.25

SWEP.RunArmOffset = Vector (-6.3159, -4.3201, 0.3808)
SWEP.RunArmAngle = Vector (-11.5989, -66.0094, -5.4286)


/*---------------------------------------------------------
   Name: GetViewModelPosition
   Desc: Allows you to re-position the view model
---------------------------------------------------------*/
function SWEP:GetViewModelPosition( pos, ang )

	--if( !self:CanShootWeapon() ) then return self.BaseClass.GetViewModelPosition( pos, ang )	 end

	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )	
	
	local vel = self.Owner:GetVelocity()
				
	if( self.LastOffset and !bIron ) then
		if( vel.z == 0 and self.LastOffset != 0 ) then
			if( !self.LastRestoreOffset ) then
				self.LastRestoreOffset = self.LastOffset;
			end
			
			local offset = math.Approach( self.LastRestoreOffset, 0, -0.5);
			pos.z = pos.z - offset
			
			self.LastRestoreOffset = offset
			
			if( offset == 0 ) then
				self.LastOffset = 0;
				self.LastRestoreOffset = nil;
			end
		else
			local offset = math.Clamp( vel.z / 50, -3, 2 )
			pos.z = pos.z - offset
				
			self.LastOffset = offset
			self.LastOffTime = CurTime()		
		end
	else
		self.LastOffset = 0;
	end

	
	local DashDelta = 0
	
	// If we're running, or have just stopped running, lerp between the 
	if ( self.Owner:KeyDown( IN_SPEED ) ) then
		
		if (!self.DashStartTime) then
			self.DashStartTime = CurTime()
		end
		
		DashDelta = math.Clamp( ((CurTime() - self.DashStartTime) / 0.1) ^ 1.2, 0, 1 )
		
	else
	
		if ( self.DashStartTime ) then
			self.DashEndTime = CurTime()
		end
	
		if ( self.DashEndTime ) then
		
			DashDelta = math.Clamp( ((CurTime() - self.DashEndTime) / 0.1) ^ 1.2, 0, 1 )
			DashDelta = 1 - DashDelta
			if ( DashDelta == 0 ) then self.DashEndTime = nil end
		
		end
	
		self.DashStartTime = nil
	
	end
	
	if ( DashDelta ) then
	
		local Down = ang:Up() * -1
		local Right = ang:Right()
		local Forward = ang:Forward()
	
		local bUseVector = false
		
		if( !self.RunArmAngle.pitch ) then
			bUseVector = true
		end
		
		// Rotate the viewmodel to self.RunArmAngle
		if( bUseVector == true ) then -- using ironsights designer probably so make it support that
			ang:RotateAroundAxis( ang:Right(), 		self.RunArmAngle.x * DashDelta )
			ang:RotateAroundAxis( ang:Up(), 		self.RunArmAngle.y * DashDelta )
			ang:RotateAroundAxis( ang:Forward(), 	self.RunArmAngle.z * DashDelta )
			
			pos = pos + self.RunArmOffset.x * ang:Right() * DashDelta 
			pos = pos + self.RunArmOffset.y * ang:Forward() * DashDelta 
			pos = pos + self.RunArmOffset.z * ang:Up() * DashDelta 
		else
			ang:RotateAroundAxis( Right,	self.RunArmAngle.pitch * DashDelta )
			ang:RotateAroundAxis( Down,  	self.RunArmAngle.yaw   * DashDelta )
			ang:RotateAroundAxis( Forward,  self.RunArmAngle.roll  * DashDelta )

			// Offset the viewmodel to self.RunArmOffset
			pos = pos + ( Down * self.RunArmOffset.x + Forward * self.RunArmOffset.y + Right * self.RunArmOffset.z ) * DashDelta			
		end
		
		if( self.DashEndTime ) then
			return pos, ang
		end
	
	end


	if( !self.IronSightsPos or !self.HasIronsights ) then return pos, ang end
	
	if ( bIron != self.bLastIron ) then
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		
		if ( bIron ) then 
			self.SwayScale 	= 0.1
			self.BobScale 	= 0.3
		else 
			self.SwayScale 	= 2.5
			self.BobScale 	= 3.0
		end
	
	end
	
	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
		return pos, ang
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
	
		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
		
		if (!bIron) then Mul = 1 - Mul end
	
	end

	local Offset	= self.IronSightsPos
	
	if ( self.IronSightsAng ) then
	
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
	
	
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul
	
	return pos, ang

	
end

function SWEP:DrawHUD()
	-- nothing

	self:DrawCrosshairHUD()
	
	if( self.Weapon:Clip1() < 1 ) then
			local colorrbg = ( math.sin( CurTime() * 3 ) + 1.0 ) * 20 + 50;
			draw.SimpleTextOutlined( "Reload - empty magazine", "HudBarItem", ScrW()/2, ScrH()*0.8, Color( 150,colorrbg,colorrbg ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color( 0,0,0 ) )
	end
	
end