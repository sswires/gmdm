include('shared.lua')

function ENT:Initialize()
	util.PrecacheModel( "models/weapons/rifleshell.mdl" )
end

function ENT:Draw()
	self:SetModel( "models/weapons/rifleshell.mdl" )
	self.Entity:DrawModel()
end

