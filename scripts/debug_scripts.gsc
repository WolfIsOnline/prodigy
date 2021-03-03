structDetector()
{
    debug("struct detector starting...");
    wait 1;
    for(c = 0; c < readDataIndex().size; c++)
    {
        if(isText(readDataIndex()[c]))
            debug("^1" + readDataIndex()[c].name + "^7 is a text struct");
        else if(!isText(readDataIndex()[c]))
            debug("^1" + readDataIndex()[c].name + "^7 is a hud struct");
        wait 1;
    }
    wait .5;
    debug("struct detector done!");
}

customDetector()
{
    debug("custom detector starting...");
    wait 1;
    for(c = 0;c < readDataIndex().size; c++)
    {
        if(!isCustom(readDataIndex()[c]))
            debug("^1" + readDataIndex()[c].name + "^7 is a built in struct");
        else if(isCustom(readDataIndex()[c]))
            debug("^1" + readDataIndex()[c].name + "^7 is a custom struct");
        wait 1;
    }
    wait .5;
    debug("custom detector done!");
}