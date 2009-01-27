
if (SERVER) then
	AddCSLuaFile( "shared.lua" )
end

if( CLIENT ) then
	SWEP.PrintName			= "P90";	
	SWEP.IconLetter			= "m";
	killicon.AddFont( "gmdm_p90", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
end

SWEP.Base						= "gmdm_csbase";
SWEP.Category					= "Combat CTF";

SWEP.IsCSWeapon					= true;

SWEP.ViewModel					= "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel					= "models/weapons/w_smg_p90.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_P90.Single" );
SWEP.Primary.Recoil				= 0.09;
SWEP.Primary.Damage				= 10.3;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.043;
SWEP.Primary.ClipSize			= 50;
SWEP.Primary.Delay				= 0.03;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 3.2;

SWEP.SprayAccuracy				= 0.9;
SWEP.SprayTime					= 0.3;

SWEP.HasIronsights				= true; -- HVA Specific


SWEP.IronSightsPos = Vector (2.4551, -0.2364, 1.3595)
SWEP.IronSightsAng = Vector (1.1311, 1.639, -3.2533)

SWEP.IronsightsFOV				= 0; -- HVA Specific


SWEP.VMPlaybackRate				= 1.0

-- HVA Run speed stuff
SWEP.WalkSpeed					= 1.0;
SWEP.RunSpeed					= 1.0;
SWEP.IronsightWalkSpeed			= 0.9;
SWEP.IronsightRunSpeed			= 0.9;


function SWEP:SecondaryAttack()

	if ( !self.IronSightsPos ) then return end

	local bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )
	
	self:SetIronsights( bIronsights )
	
	self.NextSecondaryAttack = CurTime() + 0.3
	
end


function SWEP:SetIronsights( b )

	if( b == true ) then
		self.Owner:SetFOV( self.IronsightsFOV, 0.25 );
		GAMEMODE:SetPlayerSpeed( self.Owner, 250 * self.IronsightWalkSpeed, 500 * self.IronsightRunSpeed );
	else
		self.Owner:SetFOV( 0, 0.2 );
		GAMEMODE:SetPlayerSpeed( self.Owner, 250 * self.WalkSpeed, 500 * self.RunSpeed );
	end
	
	self.Weapon:SetNetworkedBool( "Ironsights", b )
end

function SWEP:DrawHUD()
	
	local bIronsights = self.Weapon:GetNetworkedBool( "Ironsights", false )
	
	if( bIronsights ) then
		local viewmodel = self.Owner:GetViewModel()
		local laserAttachment = viewmodel:LookupAttachment( "1" )
		
		if( laserAttachment == 0 ) then
			laserAttachment = viewmodel:LookupAttachment( "muzzle" )
		end


		local lasernormal = Vector( -0.8902, 0.4548, -0.0259 )

		local plTrace = util.GetPlayerTrace( LocalPlayer() )
		--local plTrace = {}
		--plTrace.startpos = viewmodel:GetAttachment( laserAttachment ).Pos
		--plTrace.endpos = viewmodel:GetAttachment( laserAttachment ).Pos * ( lasernormal * 1024 )
 
		local trace = util.TraceLine( plTrace )

		cam.Start3D( EyePos(), EyeAngles() )
			render.SetMaterial( Material( "sprites/bluelaser1" ) )
			render.DrawBeam( viewmodel:GetAttachment( laserAttachment ).Pos, trace.HitPos, 2, 0, 12.5, Color(255, 0, 0, 255))
			render.SetMaterial( Material( "Sprites/light_glow02_add_noz" ) )
			render.DrawQuadEasy( trace.HitPos, lasernormal, 1.35, 1.35, Color(255,0,0,255), 0 )
		cam.End3D()  	
		
		Msg( tostring( ( EyePos() - trace.HitPos ):GetNormal() ) .. "\n")
	end
	
	if( self.Weapon:GetNetworkedBool( "Ironsights", false ) == true and self.DrawCrosshair == true ) then
		self.DrawCrosshair = false;
	elseif( self.Weapon:GetNetworkedBool( "Ironsights", false ) == false and self.DrawCrosshair == false ) then
		self.DrawCrosshair = true;
	end
end
