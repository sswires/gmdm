AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

function ENT:Initialize()

	util.PrecacheModel( "models/items/ar2_grenade.mdl" )
	self:SetModel( "models/items/ar2_grenade.mdl" )
	
	// Don't use the model's physics - create a sphere instead
	self.Entity:PhysicsInitSphere( 2, "metal_bouncy" )
	
	// Set collision bounds exactly
	self.Entity:SetCollisionBounds( Vector()*-2, Vector()*2 )
	
	self:StartMotionController()
	
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetTrigger(true)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableCollisions(true)
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:SetMass(999)
		phys:Wake()
	end
	
	self.RicoSound = Sound("npc/manhack/mh_blade_snick1.wav")
	self.HitFlesh1 = Sound("npc/roller/blade_in.wav")
	self.HitFlesh2 = Sound("physics/flesh/flesh_impact_bullet2.wav")

	self.Trail = util.SpriteTrail(self, 0, Color(250,50,50,250), false, 2, 1, 0.15, 1/32 * 0.1, "trails/plasma.vmt")
	
end

function ENT:Think()
	if self:WaterLevel() > 0 then self.DieTime = CurTime() - 1 end
	if self.DieTime then
		if self.DieTime < CurTime() then
			self:DoExplode() 
		end
	end
	self:NextThink(CurTime())
	return true
end

function ENT:PhysicsUpdate(phys,deltatime)
	if self.HitWeld then return SIM_NOTHING end
	phys:Wake()
	phys:SetVelocityInstantaneous(self:GetAngles():Forward():Normalize() * 99999)
	phys:AddAngleVelocity(Angle(0,0.15,0)) //slowly arc
end

function ENT:DoExplode()
	self.Trail:Fire("kill",1,0.001)
	self:Fire("kill",1,0.0001)
end

function ENT:Touch(ent)
	if ent:IsPlayer() or ent:IsNPC() then
		self:EmitSound(self.HitFlesh1,100,math.random(120,140))
		self:EmitSound(self.HitFlesh2,100,math.random(90,110))
		ent:TakeDamage( 40, self.Entity:GetOwner(), self )
		self:Remove()
	end
end

function ENT:PhysicsCollide( data, phys )

	if not self.HitWeld and not data.HitEntity:IsPlayer() then
	
		if data.HitEntity:IsWorld() and not self.DieTime then
	
			self.HitWeld = constraint.Weld( self, data.HitEntity, 0, 0, 0, true )
			self:EmitSound(self.RicoSound,100,math.random(110,150))
			self.DieTime = CurTime() 
			self:NextThink(CurTime()) 
			
		elseif not self.DieTime then
		
			self.DieTime = CurTime() 
			self:NextThink(CurTime()) 
			self:EmitSound(self.RicoSound,100,math.random(110,150))
		
		end
	end
end


