AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

function ENT:Initialize()

	util.PrecacheModel("models/items/crossbowrounds.mdl")
	self:SetModel("models/items/crossbowrounds.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
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
	
	self.HitFlesh1 = Sound("weapons/crossbow/bolt_skewer1.wav")
	self.HitFlesh2 = Sound("physics/flesh/flesh_impact_bullet1.wav")
	self.HitSound = Sound("npc/roller/blade_out.wav")
	self.Break = Sound("physics/glass/glass_impact_bullet1.wav")

	self.Trail = util.SpriteTrail(self, 0, Color(250,50,50,250), false, 2, 1, 0.20, 1/32 * 0.5, "trails/plasma.vmt")
	
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
	self:EmitSound(self.Break,100,math.random(90,110))
	for i=1,10 do
		local da = ents.Create("flechette_shrapnel")
		da:SetAngles((self:GetAngles():Forward() * -1):Angle() + Angle(math.random(-20,20),math.random(-20,20),math.random(-20,20)))
		da:SetPos(self:GetPos() + self:GetAngles():Forward() * -5)
		da:Spawn()
		da:SetOwner(self:GetOwner())
	end
	self.Trail:Fire("kill",1,0.001)
	self:Fire("kill",1,0.0001)
end

function ENT:Touch(ent)
	if ent:IsPlayer() or ent:IsNPC() then
		if ent == self:GetOwner() then return end
		self:EmitSound(self.HitFlesh1,100,math.random(130,140))
		self:EmitSound(self.HitFlesh2,100,math.random(130,140))
		ent:TakeDamage( 100, self.Entity:GetOwner(), self )
		self:Remove()
	end
end

function ENT:PhysicsCollide( data, phys )

	if not self.HitWeld and not data.HitEntity:IsPlayer() then
	
		if data.HitEntity:IsWorld() and not self.DieTime then
	
			self.HitWeld = constraint.Weld( data.HitEntity, self, 0, 0, 0, true )
			self.DieTime = CurTime() + 5
			self:EmitSound(self.HitSound,100,math.random(120,140))
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			
		elseif not self.DieTime then
		
			self.DieTime = CurTime() 
			self:NextThink(CurTime()) 
			self:EmitSound(self.HitSound,100,math.random(120,140))
		
		end
	end
end


