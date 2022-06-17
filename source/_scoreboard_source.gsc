#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;

init()
{
    precacheshader("damage_feedback");

    level thread onplayerconnect();

    maps/mp/zombies/_zm_spawner::register_zombie_damage_callback(::do_hitmarker);
    maps/mp/zombies/_zm_spawner::register_zombie_death_event_callback(::do_hitmarker_death);

    level.red_hitmarkers_on_death = getDvarIntDefault("redHitmarkers", 0);
}

onplayerconnect()
{
    for(;;)
    {
        level waittill("connected", player);

        if (!isdefined(player.hud_damagefeedback))
            player thread init_player_hitmarkers();
    }
}

init_player_hitmarkers()
{
    self.hud_damagefeedback = newdamageindicatorhudelem(self);
    self.hud_damagefeedback.horzalign = "center";
    self.hud_damagefeedback.vertalign = "middle";
    self.hud_damagefeedback.x = -12;
    self.hud_damagefeedback.y = -12;
    self.hud_damagefeedback.alpha = 0;
    self.hud_damagefeedback.archived = 1;
    self.hud_damagefeedback.color = (1, 1, 1);

    self.hud_damagefeedback setshader("damage_feedback", 24, 48);
    self.hitsoundtracker = 1;
}

// a improved updatedamagefeedback
do_hitmarker_internal(mod, death)
{
    if (!isplayer(self))
        return;

    if (!isdefined(death))
        death = false;

    if (isdefined(mod) && mod != "MOD_CRUSH" && mod != "MOD_GRENADE_SPLASH" && mod != "MOD_HIT_BY_OBJECT")
    {
        self.hud_damagefeedback.color = (1, 1, 1);

        if (death && level.red_hitmarkers_on_death)
            self.hud_damagefeedback.color = (1, 0, 0);

        self.hud_damagefeedback setshader("damage_feedback", 24, 48);
        self.hud_damagefeedback.alpha = 1;
        self.hud_damagefeedback fadeovertime(1);
        self.hud_damagefeedback.alpha = 0;
    }
}

do_hitmarker(mod, hit_location, hit_origin, player, amount)
{
    if (isdefined(player) && isplayer(player) && player != self)
        player thread do_hitmarker_internal(mod, player);

    return false;
}

do_hitmarker_death()
{
    // self is the zombie victim in this case
    if (isdefined(self.attacker) && isplayer(self.attacker) && self.attacker != self)
        self.attacker thread do_hitmarker_internal(self.damagemod, self.attacker, true);
}
