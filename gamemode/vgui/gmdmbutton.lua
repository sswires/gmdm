surface.CreateFont( "Arial", 16, 500, true, false, "GMDMButtonFontx" );

local GMDMButton = {}

GMDMButton.Hover = false
GMDMButton.DoHover = nil;

function GMDMButton:OnCursorEntered( )
	self.Hover = true
	
	if( self.DoHover ) then
		self:DoHover()
	end
end

function GMDMButton:OnCursorExited()
	self.Hover = false
end

function GMDMButton:Init( )
	self:SetDrawBackground( false )
	self:SetDrawBorder( false )
end

function GMDMButton:Paint( )
	if( self.Hover == false ) then
		draw.RoundedBox( 3, 0, 0, self:GetWide(), self:GetTall(), Color( 60, 60, 60, 200 ) )
	else
		draw.RoundedBox( 3, 0, 0, self:GetWide(), self:GetTall(), Color( 75, 75, 75, 200 ) )
	end

	draw.SimpleText( self:GetValue(), "GMDMButtonFontx", self:GetWide()/2, self:GetTall()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
	return true
end


vgui.Register( "GMDMButton", GMDMButton, "Button" );