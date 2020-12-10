#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;

init()
{
    thread init_hitmarkers();
}

init_hitmarkers()
{
    precacheshader( "damage_feedback" );
    precacheshader( "damage_feedback_flak" );
    precacheshader( "damage_feedback_tac" );
    level.redHm = getDvarIntDefault( "redHitmarkers", 0 );
    level.can_be_mad - getDvarIntDefault( "canBeMad", 1 );
    level.callbackactordamage = ::actor_damage_hitmarkers;
    level endon( "end_game" );
    while ( 1 )
    {
    	flag_wait( "initial_blackscreen_passed" );
        foreach( player in level.players )
        {
        	if( !isDefined( player.hud_damagefeedback ))
        	{
        		player init_player_hitmarkers();
        	}
        	wait 0.1;
        }
    }
}

init_player_hitmarkers()
{
    self.hud_damagefeedback = newdamageindicatorhudelem( self );
    self.hud_damagefeedback.horzalign = "center";
    self.hud_damagefeedback.vertalign = "middle";
    self.hud_damagefeedback.x = -12;
    self.hud_damagefeedback.y = -12;
    self.hud_damagefeedback.alpha = 0;
    self.hud_damagefeedback.archived = 1;
    self.hud_damagefeedback.color = ( 1, 1, 1 );
    self.hud_damagefeedback setshader( "damage_feedback", 24, 48 );
    self.hitsoundtracker = 1;
    self.hud_damagefeedback_red = newdamageindicatorhudelem( self );
    self.hud_damagefeedback_red.horzalign = "center";
    self.hud_damagefeedback_red.vertalign = "middle";
    self.hud_damagefeedback_red.x = -12;
    self.hud_damagefeedback_red.y = -12;
    self.hud_damagefeedback_red.alpha = 0;
    self.hud_damagefeedback_red.archived = 1;
    self.hud_damagefeedback_red.color = ( 1, 0, 0 );
    self.hud_damagefeedback_red setshader( "damage_feedback", 24, 48 );
}

actor_damage_hitmarkers( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex ) //checked does not match cerberus output did not change
{
	if(isDefined(level.sloth) && level.sloth == self) {
		if(level.can_be_mad && level.script == "zm_buried") {
			if((self.health-damage) >= 0 ) {
				self thread zombies_hitmarker_damage_callback( meansofdeath, attacker, damage, 0 );
				self finishactordamage( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
				self.health += damage;
			} else {
				self thread zombies_hitmarker_damage_callback( meansofdeath, attacker, 1, 0 );
				self finishactordamage( inflictor, attacker, 1, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
				self.health += damage;
			}
		}
		
	} else {
		if ((self.health - damage) > 0 )
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
		if( isDefined( death ) && death && level.redHM )
		{
    			self.hud_damagefeedback_red setshader( "damage_feedback", 24, 48 );
			self.hud_damagefeedback_red.alpha = 1;
			self.hud_damagefeedback_red fadeovertime( 1 );
			self.hud_damagefeedback_red.alpha = 0;
		}
		else
		{
        		self.hud_damagefeedback setshader( "damage_feedback", 24, 48 );
			self.hud_damagefeedback.alpha = 1;
			self.hud_damagefeedback fadeovertime( 1 );
			self.hud_damagefeedback.alpha = 0;
		}
	}
    return 0;
}
