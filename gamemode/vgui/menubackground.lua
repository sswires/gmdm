-- VGUI table
local MenuPanel = {}

MenuPanel.Title = ""
MenuPanel.Description = ""

-- fonts
surface.CreateFont( "coolvetica", 36, 400, true, false, "GMDMMenuCaption" );
surface.CreateFont( "Arial", 14, 400, true, false, "GMDMMenuDesc" );

-- helper functions
local function DrawMaterial( material, x, y, w, h )	
	surface.SetMaterial( material );
	surface.SetDrawColor( 255, 255, 255, 255 );
	surface.DrawTexturedRect( x, y, w, h );
end

local function DrawCaption( strText )
	draw.SimpleText( strText, "GMDMMenuCaption", 32, 22, Color( 0, 0, 0, 100 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT );
	draw.SimpleText( strText, "GMDMMenuCaption", 30, 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT );
end

local function DrawDescription( strText )
	draw.SimpleText( strText, "GMDMMenuDesc", 32, 57, Color( 50, 50, 50, 100 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT );
	draw.SimpleText( strText, "GMDMMenuDesc", 30, 55, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT );
end

function MenuPanel:Init()

	self.DrawBlur = true;
	self:SetPos( 0, 0 );
	self:SetSize( ScrW(), ScrH() );
	
	-- do u liek my hack to get rid of untitle dframe?
	self:SetTitle( " " );
	self.SetTitle = self.SetTitleZ;
	
end

function MenuPanel:SetTitleZ( text )
	self.Title = text;
end

function MenuPanel:SetText( text )
	self.Description = text;
end

function MenuPanel:Paint( drawblur )

	if( drawblur ) then
		self.DrawBlur = drawblur
	end

	if( self.DrawBlur == true ) then
		Derma_DrawBackgroundBlur( self )
	end
	
	if( !self.Description ) then
		self.Description = " ";
	end
	
	if( !self.Title ) then
		self.Title = " ";
	end
	
	local scrW = ScrW();
	local scrH = ScrH();
	
	-- res independant stuff
	surface.SetDrawColor( 0, 0, 0, 125 );
	surface.DrawRect( 0, 80, self:GetWide(), self:GetTall() - 80 );
	
	DrawCaption( self.Title );
	DrawDescription( self.Description );
	
	
end

vgui.Register( "GMDMMenu", MenuPanel, "DFrame" );
