#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\_utility;
#include maps\_hud_util;

init()
{
    level thread player_connected();
}

player_connected()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread player_spawned();
    }
}

player_spawned()
{
    self endon("disconnect");
    level endon("game_ended");
    for(;;)
    {
        self waittill("spawned_player");
        if(isDefined(self.spawned))
            continue;
        self.spawned = true;

        self freezeControls(false);
        self thread init_prodigy();
    }
}
