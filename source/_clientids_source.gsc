#include maps\mp/zombies\_zm_spawner;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;

init()
{
    level maps\mp\zombies\_zm_spawner::register_zombie_damage_callback( ::zombies_hitmarker_damage_callback );
    level maps\mp\zombies\_zm_spawner::register_zombie_death_event_callback( ::zombies_hitmarker_death_event_callback );

    precacheshader( "damage_feedback" );
	precacheshader( "damage_feedback_flak" );
	precacheshader( "damage_feedback_tac" );
    level thread on_player_connect();
}

zombies_hitmarker_damage_callback( smeansofdeath, hit_location, hit_origin, eattacker, idamage )
{
    if ( isDefined( eattacker ) && isplayer( eattacker ) && eattacker != self )
    {
        if ( dodamagefeedback( eattacker, idamage, smeansofdeath ) )
        {
            if ( idamage > 0 )
            {
                eattacker thread updatedamagefeedback( smeansofdeath, eattacker );
            }
        }
    }
}

dodamagefeedback( einflictor, idamage, smeansofdeath ) //checked matches cerberus output
{
	if ( level.allowhitmarkers == 0 )
	{
		return 0;
	}
	return 1;
}

on_player_connect()
{
    level endon( "end_game" );
    while ( 1 )
    {
        level waittill( "connected", player );
        player.hud_damagefeedback = newdamageindicatorhudelem( player );
        player.hud_damagefeedback.horzalign = "center";
        player.hud_damagefeedback.vertalign = "middle";
        player.hud_damagefeedback.x = -12;
        player.hud_damagefeedback.y = -12;
        player.hud_damagefeedback.alpha = 0;
        player.hud_damagefeedback.archived = 1;
        player.hud_damagefeedback setshader( "damage_feedback", 24, 48 );
        player.hitsoundtracker = 1;
    }
}

updatedamagefeedback( mod, inflictor ) //checked matches cerberus output
{
	if ( !isplayer( self ) )
	{
		return;
	}
	if ( isDefined( mod ) && mod != "MOD_CRUSH" && mod != "MOD_GRENADE_SPLASH" && mod != "MOD_HIT_BY_OBJECT" )
	{
		if ( isDefined( inflictor ) )
		{
			self playlocalsound( "mpl_hit_alert" );
		}
        self.hud_damagefeedback setshader( "damage_feedback", 24, 48 );
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback fadeovertime( 1 );
		self.hud_damagefeedback.alpha = 0;
	}
    return 0;
}

zombies_hitmarker_death_event_callback( eattacker )
{
    eattacker thread dohitmarker();
}

dohitmarker()
{
    if ( !isplayer( self ) )
	{
		return;
	}
    self playlocalsound( "mpl_hit_alert" );
    self.hud_damagefeedback setshader( "damage_feedback", 24, 48 );
	self.hud_damagefeedback.alpha = 1;
	self.hud_damagefeedback fadeovertime( 1 );
	self.hud_damagefeedback.alpha = 0;
}
