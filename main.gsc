#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\_utility;
#include maps\_hud_util;

init()
{
    shaders = strTok("white;gradient_center;gradient;gradient_bottom;gradient_left;gradient_right;gradient_top", ";");
    foreach(shader in shaders)
        precacheShader(shader);
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
