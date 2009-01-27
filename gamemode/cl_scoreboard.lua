include( "vgui/menubackground.lua" );

surface.CreateFont( "coolvetica", 19, 500, true, false, "GMDMScoreboardPlayerRow" )

PlayerPanel = {}
PlayerPanel.Player = nil;
PlayerPanel.FramesInvalid = 0;

PlayerPanel.ExtraColumns = {}
PlayerPanel.ExtraColumns[1] = {
			header = "Souls",
			valuefunc = function( pl ) return pl:GetNetworkedInt( "Souls", 0 ) end,
			shoulddraw = function() if( gmdm_soulcollector:GetBool() ) then return true end return false end,
		};
		
function GM:RegisterScoreboardColumn( header, valuefunc, shoulddrawfunc, width )

		if( !width ) then
			width = 60
		end
		
		local temp = {}
		temp.header = header;
		temp.valuefunc = valuefunc;
		temp.shoulddraw = shoulddrawfunc;
		temp.width = width;
		
		table.insert( PlayerPanel.ExtraColumns, temp );
end

function GM:RemoveColumnByHeader( header )
	for k, v in pairs( PlayerPanel.ExtraColumns ) do
		if( v.header == header ) then
			table.remove( PlayerPanel.ExtraColumns, k );
		end
	end
end
		
function PlayerPanel:Init()
	self.AvatarPanel = vgui.Create( "AvatarImage", self )
	self.AvatarPanel:SetPos( 5, 0 )
	self.AvatarPanel:SetSize( 30, 30 );
end

function PlayerPanel:SetPlayer( player )

	if( !player or !player:IsValid() or !player:IsPlayer() ) then
		return false
	end
	
	self.AvatarPanel:SetPlayer( player )
	self.Player = player
end

function PlayerPanel:Paint( )
	
	if( self.Player:IsValid() == false ) then
		self.FramesInvalid = self.FramesInvalid + 1
		
		if( self.FramesInvalid > 5 ) then
			Msg( "Player invalid for more than 30 frames!\n ")
			self:Remove()
		end
		
		return
	end
	
	local pl = self.Player
	
	draw.SimpleText( pl:Nick(), "GMDMScoreboardPlayerRow", 45, 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT );
	draw.SimpleText( tostring( pl:Ping() ), "GMDMScoreboardPlayerRow", self:GetWide(), 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT );
	draw.SimpleText( tostring( pl:Deaths() ), "GMDMScoreboardPlayerRow", self:GetWide()-60, 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT );
	draw.SimpleText( tostring( pl:Frags() ), "GMDMScoreboardPlayerRow", self:GetWide()-120, 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT );

	local off = 0;
	local xoffset = 120;
	for _, v in pairs( self.ExtraColumns ) do
		if( ( type( v.shoulddraw ) == "bool" and v.shoulddraw ) or v.shoulddraw() == true ) then
			off = off + 1;
			local width = v.width or 60;
			
			draw.SimpleText( tostring( v.valuefunc( pl ) ), "GMDMScoreboardPlayerRow", self:GetWide()-xoffset-width, 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT );
			
			xoffset = xoffset + width;
			
		end
	end
	
end

vgui.Register( "GMDMPlayerRow", PlayerPanel, "DPanel" );

local TeamPanel = {}
TeamPanel.TeamID = TEAM_FREEFORALL;
TeamPanel.ShowScore = true
TeamPanel.PlayerRows = {}
TeamPanel.CleanUp = 0

function TeamPanel:Init( )
	self:SetPaintBackgroundEnabled( true )
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
end

function TeamPanel:SetTeam( teamid )
	self.TeamID = teamid
	self.PlayerRows[ self.TeamID ] = {}
end

function TeamPanel:Paint( )

	if( !self.TeamID ) then return end
	
	
	local FFAColor = team.GetColor( self.TeamID )
	surface.SetDrawColor( FFAColor.r, FFAColor.g, FFAColor.b, 255 );
	surface.DrawRect( 0, 0, self:GetWide(), 25 );
	
	surface.SetDrawColor( 20, 20, 20, 150 )
	surface.DrawOutlinedRect( 0, 0, self:GetWide(), 25 );
	
	surface.SetDrawColor( 150, 150, 150, 40 );
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() );
	
	draw.SimpleText( team.GetName( self.TeamID ), "ScoreboardSub", 8, 4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT );
	draw.SimpleText( team.GetName( self.TeamID ), "ScoreboardSub", 6, 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT );

	if( self.ShowScore == true ) then
		draw.SimpleText( tostring( team.GetScore( self.TeamID ) ), "ScoreboardSub", 157, 4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT );
		draw.SimpleText( tostring( team.GetScore( self.TeamID ) ), "ScoreboardSub", 155, 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT );
	end
	
	surface.SetDrawColor( 50, 50, 50, 30 );
	surface.DrawRect( self:GetWide()-60, 0, 60, self:GetTall() )
	
	surface.SetDrawColor( 50, 50, 50, 60 );
	surface.DrawRect( self:GetWide()-120, 0, 60, self:GetTall() )
		
	surface.SetDrawColor( 50, 50, 50, 30 );
	surface.DrawRect( self:GetWide()-180, 0, 60, self:GetTall() )
		
	-- ScoreboardText
	draw.SimpleText( "Ping", "ScoreboardText", self:GetWide()-10, 3, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT );
	draw.SimpleText( "Deaths", "ScoreboardText", self:GetWide()-65, 3, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT );
	draw.SimpleText( "Kills", "ScoreboardText", self:GetWide()-125, 3, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT );

	local off = 0;
	local xoffset = 180;
	for _, v in pairs( PlayerPanel.ExtraColumns ) do
		if( ( type( v.shoulddraw ) == "bool" and v.shoulddraw ) or v.shoulddraw() == true ) then
			off = off + 1;
			
			if( off % 2 ) then
				surface.SetDrawColor( 50, 50, 50, 60 );
			else
				surface.SetDrawColor( 50, 50, 50, 30 );
			end
			
			local width = v.width or 60
			surface.DrawRect( self:GetWide()-xoffset-width, 0, 60, self:GetTall() );
			xoffset = xoffset + width
			
			draw.SimpleText( v.header, "ScoreboardText", self:GetWide()-125-(60*off), 3, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT );
		end
	end
	
	local loop = 0
	
	local TeamInfo = GAMEMODE:GetTeamScoreInfo()	
	if( !TeamInfo[ self.TeamID ] ) then return end
	local TeamPlayers = TeamInfo[ self.TeamID ].Players
	
	for k, v in pairs( TeamPlayers ) do
		local plObj = v.PlayerObj
		
		if( plObj:Team() == self.TeamID ) then
		
			if( (loop+1) % 2 == 0 ) then -- even
				surface.SetDrawColor( 150, 150, 150, 20 );
				surface.DrawRect( 0, ( 40 * loop ) + 26, self:GetWide() , 40 )			
			end
			
			if( plObj == LocalPlayer() ) then
				surface.SetDrawColor( 255, 255, 150, 50 );
				surface.DrawRect( 0, ( 40 * loop ) + 26, self:GetWide() , 40 )	
			end
			
			local UserID = plObj:EntIndex();
			
			if( self.PlayerRows[ self.TeamID ][ UserID ] and self.PlayerRows[ self.TeamID ][ UserID ]:IsValid() and self.PlayerRows[ self.TeamID ][ UserID ].Player and self.PlayerRows[ self.TeamID ][ UserID ].Player:IsValid() ) then
				self.PlayerRows[ self.TeamID ][ UserID ]:SetPos( 5, 30 + (loop * 40 ) )
			else
				self.PlayerRows[ self.TeamID ][ UserID ] = vgui.Create( "GMDMPlayerRow", self )
				self.PlayerRows[ self.TeamID ][ UserID ]:SetPlayer( plObj )
				self.PlayerRows[ self.TeamID ][ UserID ]:SetSize( self:GetWide() - 15, 31 )
				self.PlayerRows[ self.TeamID ][ UserID ]:SetPos( 5, 30 + (loop * 40 ) )
			end
			
			--local panel = self.PlayerRows[ v:UserID() ];
		
			loop = loop + 1
		end
	end
	
	if( self.CleanUp < CurTime() ) then
		for k, v in pairs( self.PlayerRows[ self.TeamID ] ) do
			local pl = player.GetByID( k )
			
			if( !pl or !pl:IsValid() or pl:Team() != self.TeamID ) then
				v:Remove()
			end
		end
		
		self.CleanUp = CurTime() + 0.5
	end
end

vgui.Register( "GMDMTeamScore", TeamPanel, "DPanel" );

local ScoreBoardPanel = {}
GM.ScoreBoardPanel = nil;

function ScoreBoardPanel:Init()
	self.BaseClass:SetTitleZ( GetGlobalString( "ServerName" ) );
	
	local AddonText = ""
	
	if( GAMEMODE.Author != "TEAM GMDM" ) then
		AddonText = " using GMDM Redux";
	end
	
	self.BaseClass.SetText( self, GAMEMODE.Name .. " / Created by " .. GAMEMODE.Author .. AddonText );
	
	self.LastHostname = CurTime()
	
	self.TeamVGUICreated = false
	self.FFAVGUICreated = false
end

function ScoreBoardPanel:Paint()
	
	if( self.LastHostname + 2 < CurTime() ) then
		self.BaseClass.SetTitleZ( self, GetGlobalString( "ServerName" ) );
	end
	

	Derma_DrawBackgroundBlur( self )
	self.BaseClass.Paint( self, false )
	
	draw.SimpleText( GAMEMODE:GetModeDescription(), "GMDMMenuCaption", self:GetWide() - 20, 22, Color( 0, 0, 0, 100 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT );
	draw.SimpleText( GAMEMODE:GetModeDescription(), "GMDMMenuCaption", self:GetWide() - 22, 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT );
	
	
	if( GAMEMODE:IsTeamPlay() == true ) then
		if( self.FFAVGUICreated == true ) then
			self.FFAPanel:Remove()
			self.FFAVGUICreated = false
		end
		
		if( self.TeamVGUICreated == false ) then
			self.RedTeamPanel = vgui.Create( "GMDMTeamScore" )
			self.RedTeamPanel:SetPos( 20, 105 )
			self.RedTeamPanel:SetSize( ( ScrW() / 2 ) - 20, ScrH()-150 )
			self.RedTeamPanel:SetParent( self )
			self.RedTeamPanel:SetTeam( TEAM_RED )
			
			self.BlueTeamPanel = vgui.Create( "GMDMTeamScore" )
			self.BlueTeamPanel:SetPos( ( ScrW() / 2 ) + 10, 105 )
			self.BlueTeamPanel:SetSize( ( ScrW() / 2 ) - 20, ScrH()-150 )
			self.BlueTeamPanel:SetParent( self )
			self.BlueTeamPanel:SetTeam( TEAM_BLUE )
			
			self.TeamVGUICreated = true
		end
	else

		if( self.FFAVGUICreated == false ) then
			self.FFAPanel = vgui.Create( "GMDMTeamScore" )
			self.FFAPanel:SetPos( 20, 105 )
			self.FFAPanel:SetSize( ScrW() - 40, ScrH()-150 )
			self.FFAPanel:SetParent( self )
			self.FFAPanel:SetTeam( TEAM_FREEFORALL )
			self.FFAPanel.ShowScore = false
			
			self.FFAVGUICreated = true
		end
		
		if( self.TeamVGUICreated == true ) then
			self.RedTeamPanel:Remove()
			self.BlueTeamPanel:Remove()
			self.TeamVGUICreated = false
		end
	end
	
	local SpecString = ""
	local SpecCount = 0
	
	for k, v in pairs( player.GetAll() ) do
		if( v:Team() == TEAM_UNASSIGNED or v:Team() == TEAM_SPECTATOR ) then
			if( SpecCount == 0 ) then
				SpecString = v:Nick()
			else
				SpecString = SpecString .. ", " .. v:Nick()
			end
			
			SpecCount = SpecCount + 1
		end
	end
	
	if( SpecCount > 0 ) then
		draw.SimpleText( tostring( SpecCount ) .. " Spectators: " .. SpecString, "GMDMScoreboardPlayerRow", 20, self:GetTall() - 35, Color( 175, 175, 175, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT );
	end
	
end

vgui.Register( "GMDMScoreboard", ScoreBoardPanel, "GMDMMenu" );

function GM:InitScoreboard()
	Msg( "Init Scoreboard VGUI\n" );
	
	if( GAMEMODE.ScoreBoardPanel == nil ) then
		GAMEMODE.ScoreBoardPanel = vgui.Create( "GMDMScoreboard" );
		GAMEMODE.ScoreBoardPanel.DrawBlur = false;
		GAMEMODE.ScoreBoardPanel:SetTitle( GetGlobalString( "ServerName" ) );
		
		local AddonText = ""
		
		if( GAMEMODE.Author != "TEAM GMDM" ) then
			AddonText = " based on GMDM Redux";
		end
		
		GAMEMODE.ScoreBoardPanel:SetText( GAMEMODE.Name .. " / Created by " .. GAMEMODE.Author .. AddonText );
		GAMEMODE.ScoreBoardPanel:SetVisible( false );
	end
end

/*---------------------------------------------------------
   Name: gamemode:ScoreboardShow( )
   Desc: Sets the scoreboard to visible
---------------------------------------------------------*/
function GM:ScoreboardShow()
	GAMEMODE.ScoreBoardPanel:SetVisible( true );
end

/*---------------------------------------------------------
   Name: gamemode:ScoreboardHide( )
   Desc: Hides the scoreboard
---------------------------------------------------------*/
function GM:ScoreboardHide()
	GAMEMODE.ScoreBoardPanel:SetVisible( false );
end
