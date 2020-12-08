#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;

init()
{
    	precacheshader( "damage_feedback" );
	precacheshader( "damage_feedback_flak" );
	precacheshader( "damage_feedback_tac" );
    	thread init_hitmarkers();
    	level.callbackactordamage = ::actor_damage_hitmarkers;
	level.redHm = getDvarIntDefault( "redHitmarkers", 0 );
}

init_hitmarkers()
{
    	level endon( "end_game" );
    	while ( 1 )
    	{
    		flag_wait( "initial_blackscreen_passed" );
        	foreach( player in level.players )
        	{
        		if( !isDefined( player.hud_damagefeedback ))
        		{
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
        		wait 0.1;
        	}
    	}
}

actor_damage_hitmarkers( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex ) //checked does not match cerberus output did not change
{
	if (( self.health - damage ) > 0 )
	{
		self thread zombies_hitmarker_damage_callback( meansofdeath, attacker, damage, 0 );
		self finishactordamage( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
	}
	else
	{
		if (level.redHm)
			self thread zombies_hitmarker_damage_callback( meansofdeath, attacker, damage, 1 );
		else
			self thread zombies_hitmarker_damage_callback( meansofdeath, attacker, damage, 0 );
		self [[ level.callbackactorkilled ]]( inflictor, attacker, damage, meansofdeath, weapon, vdir, shitloc, psoffsettime );
		self finishactordamage( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
	}
}

zombies_hitmarker_damage_callback( smeansofdeath, eattacker, idamage, death )
{
    if ( isDefined( eattacker ) && isplayer( eattacker ) && eattacker != self )
    {
        if ( dodamagefeedback( eattacker, idamage, smeansofdeath ) )
        {
            if ( idamage > 0 )
            {
                eattacker thread updatedamagefeedback( smeansofdeath, eattacker, death );
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

updatedamagefeedback( mod, inflictor, death ) //checked matches cerberus output
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
		if( isDefined( death ) && death )
		{
			self.hud_damagefeedback.color = ( 1, 0, 0 );
    		self.hud_damagefeedback setshader( "damage_feedback", 24, 48 );
			self.hud_damagefeedback.alpha = 1;
			self.hud_damagefeedback fadeovertime( 1 );
			self.hud_damagefeedback.alpha = 0;
			self.hud_damagefeedback.color = ( 1, 0, 0 );
		}
		else
		{
        	self.hud_damagefeedback.color = ( 1, 1, 1 );
        	self.hud_damagefeedback setshader( "damage_feedback", 24, 48 );
			self.hud_damagefeedback.alpha = 1;
			self.hud_damagefeedback fadeovertime( 1 );
			self.hud_damagefeedback.alpha = 0;
			self.hud_damagefeedback.color = ( 1, 1, 1 );
		}
	}
    return 0;
}
