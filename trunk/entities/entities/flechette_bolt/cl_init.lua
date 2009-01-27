include('shared.lua')

function ENT:Initialize()
	util.PrecacheModel("models/crossbow_bolt.mdl")
	self.DrawSprite = false
	self.Time = 0
end

function ENT:Think()
	if self.DrawSprite then return end
end

function ENT:Draw()
	self:SetModel( "models/crossbow_bolt.mdl" )
	self.Entity:DrawModel()
	render.SetMaterial( Material("effects/blueflare1") )
	render.DrawSprite( self.Entity:GetPos(), 5, 5, Color(200, 0, 0, 250) ) 
end

