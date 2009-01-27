local WeaponSelectPanel = nil;
local WeaponSelectVGUI = {}
local LastSelect = 0

function WeaponSelectVGUI:Init()
	self.ModelPanel = vgui.Create( "DModelPanel" )
	self.ModelPanel:SetPos( 2, 15 )
	self.ModelPanel:SetModel( "models/weapons/w_smg1.mdl" )
	self.ModelPanel:SetSize( 75, 45 )
	self.ModelPanel:SetCamPos( Vector( 0, 20, 0 ) )
	self.ModelPanel:SetLookAt( Vector( 0, 0, 0 ) )
	self.ModelPanel:SetParent( self )
end

function WeaponSelectVGUI:Paint()
	
	if( LocalPlayer():Alive() == false ) then return end
	
	if( LastSelect + 3 < CurTime() ) then
		if( self:GetAlpha() > 0 ) then
			self:SetAlpha( math.Clamp( self:GetAlpha() - 10, 0, 255 ) )
		else
			self:SetVisible( false )
		end
	elseif( self:GetAlpha() < 255 ) then
		self:SetAlpha( 255 )
	end
	
	if( self.ActiveWeapon == nil or self.ActiveWeapon != LocalPlayer():GetActiveWeapon() ) then
		self.ActiveWeapon = LocalPlayer():GetActiveWeapon()
		self.ModelPanel:SetModel( self.ActiveWeapon.WorldModel )

		local weapons = LocalPlayer():GetWeapons()
		local count = table.Count( weapons )

		local prevweap = nil
		
		local prevcount = 0
		
		for k, v in pairs( weapons ) do
			if( v == WeaponSelectPanel.ActiveWeapon ) then
				prevweap = weapons[ k - 1 ]

				prevcount = k - 2
				
				while( prevweap == nil ) do
					if( prevcount < 1 ) then
						prevcount = count
					end
					
					prevweap = weapons[ prevcount ]			
					prevcount = prevcount-1					
				end
			end
		end
		
		self.NextWeapon = prevweap
	end
	
	draw.RoundedBox( 3, 0, 15, self:GetWide(), self:GetTall()-40, Color( 0, 0, 0, 50 ) )
	draw.SimpleTextOutlined( LocalPlayer():GetActiveWeapon():GetPrintName(), 	"HudBarItemSmall", 80, 25, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0,0,0,255) )
	draw.SimpleTextOutlined( "Next Weapon: " .. self.NextWeapon:GetPrintName(), 	"HudBarItemSmall", 10, -2, Color( 150, 150, 150 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0,0,0,255) )

	end

vgui.Register( "GMDMWeapons", WeaponSelectVGUI, "DPanel" )

local function HandleInventory( isnext )

	LastSelect = CurTime()
	
	if( WeaponSelectPanel == nil ) then
		WeaponSelectPanel = vgui.Create( "GMDMWeapons" )
		WeaponSelectPanel:SetPos( ( ScrW()/2 ) - 100, 40 )
		WeaponSelectPanel:SetSize( 200, 85 )
	end
	
	WeaponSelectPanel:SetVisible( true )
	
	local touse = 0
	local weapons = LocalPlayer():GetWeapons()
	local count = table.Count( weapons )

	if( count == 0 ) then return end
	
	for k, v in pairs( weapons ) do
		if( v == WeaponSelectPanel.ActiveWeapon ) then
			if( isnext == true ) then
				if( k + 1 >= count ) then
					touse = 1
				else
					touse = k + 1
				end
			else
				if( k - 1 < 1 ) then
					touse = count
				else
					touse = k - 1
				end
			end
		end
	end
	
	local nextactiveweapon = weapons[ touse ]
	
	while( nextactiveweapon == nil ) do
		if( isnext == true ) then
			if( touse >= count ) then
				touse = 0
			end
			
			nextactiveweapon = weapons[ touse + 1 ]
			touse = touse + 1
		else
			if( touse < 1 ) then
				touse = count + 1
			end
			
			nextactiveweapon = weapons[ touse - 1 ]
			touse = touse - 1
		end
	end

	LocalPlayer():ConCommand( "use " .. nextactiveweapon:GetClass() )
	
end

concommand.Add( "inv_gmdmnext", HandleInventory, true )
concommand.Add( "inv_gmdmprev", HandleInventory, true )