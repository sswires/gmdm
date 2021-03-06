
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

local Explode_Sound = Sound("npc/scanner/cbot_energyexplosion1.wav")
local Burn_Sound = Sound("Fire.Plasma")

util.PrecacheModel("models/weapons/w_missile.mdl")

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:SetModel("models/weapons/w_missile_closed.mdl")
	
	// Don't use the model's physics - create a sphere instead
	self.Entity:PhysicsInitSphere( 4, "metal_bouncy" )
	
	// Wake the physics object up. It's time to have fun!
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetDamping( .0001, .0001 )
		phys:EnableGravity( false )
	end
	
	// Make it face the right way
	self.Entity:SetAngles(self.Entity:GetOwner():GetAimVector():Angle())
	
	// Set collision bounds exactly
	self.Entity:SetCollisionBounds( Vector()*-4, Vector()*4 )

	self.Sound = CreateSound( self.Entity, Burn_Sound )
	self.Sound:SetSoundLevel( 95 )
	self.Sound:Play()
	
	self:StartMotionController()
	
	self.ExplodeTime = CurTime() + 0.3
	self.Spread = 200
	
end

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:OnRemove()

	if ( self.Sound ) then
		self.Sound:Stop()
	end
	
end

function ENT:Think() 

	if self.Dead then
		self:Explode()
	end
	
	if self.ExplodeTime < CurTime() then
		self.Dead = true
	end
	
end

/*---------------------------------------------------------
   Name: Explode
---------------------------------------------------------*/
function ENT:Explode()

	if ( self.Exploded ) then return end
	
	self.Exploded = true
	
	local angs = self:GetAngles()
	
	for i=1,8 do
		
		local clust = ents.Create("rpg_clustlet")
		clust:SetPos(self:GetPos())
		clust:SetAngles(self:GetAngles())
		clust:SetOwner(self:GetOwner())
		clust:Spawn()
		
		local phys = clust:GetPhysicsObject()
		if phys and phys:IsValid() then
		
			phys:Wake()
			
			local spread = self:GetRight() * math.random(self.Spread * -2,self.Spread * 2) + self:GetUp() * math.random(self.Spread * -1,self.Spread)
			phys:ApplyForceCenter( self:GetVelocity() + spread )
	
		end
	end

	self:EmitSound(Explode_Sound)
	self.Entity:Remove()

end

/*---------------------------------------------------------
   Name: PhysicsCollide
---------------------------------------------------------*/
function ENT:PhysicsSimulate( phys, deltatime )

	if self.Dead then return SIM_NOTHING end
		
	local fSin = math.sin( CurTime() * 20 ) * 1.1
	local fCos = math.cos( CurTime() * 20 ) * 1.1
	
	local vAngular = Vector(0,0,0)
	local vLinear = (self.FlyAngle:Right() * fSin) + (self.FlyAngle:Up() * fCos)
	vLinear = vLinear * deltatime * 10

	return vAngular, vLinear, SIM_GLOBAL_FORCE
	
end

/*---------------------------------------------------------
   Name: PhysicsCollide
---------------------------------------------------------*/
function ENT:PhysicsCollide( data, physobj )
	
	self.Dead = true
	
end
