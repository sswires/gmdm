local iKeepTime = 4;
local fLastMessage = 0;
local fAlpha = 0;
local szMessage = "";

function GM:PrintCenterMessage( )
	if( fLastMessage + iKeepTime < CurTime() and fAlpha > 0) then
		fAlpha = fAlpha - (FrameTime()*200)
	end
	
	if( fAlpha > 0 ) then
		draw.SimpleTextOutlined( szMessage, "HudBarItem", ScrW()/2, ScrH()/4, Color( 255, 255, 255, math.Clamp( fAlpha, 0, 255 ) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, math.Clamp( fAlpha, 0, 255 ) ) );
	end
end

function GM:AddCenterMessage( message )
	fLastMessage = CurTime();
	szMessage = message;
	fAlpha = 255;
end

function ReceiveCenterMessage( usrmsg )
	fLastMessage = CurTime();
	szMessage = usrmsg:ReadString();	
	fAlpha = 255;
end
usermessage.Hook( "gmdm_printcenter", ReceiveCenterMessage );