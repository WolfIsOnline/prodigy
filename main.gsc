#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes_zm\_hud_util;

init()
{
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    level endon("game_ended");
    for(;;)
    {
        self waittill("spawned_player");
        if(isDefined(self.playerSpawned))
            continue;
        self.playerSpawned = true;

        self freezeControls(false);
        self thread init_prodigy();
    }
}