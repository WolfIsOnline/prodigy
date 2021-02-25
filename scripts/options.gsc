prodigy_options()
{
    menu = "main";
    addMenu(menu, "Main Menu", undefined);
    addSubMenu(menu, 0, "Debug Menu", "_dbg");
    for(c = 1; c < 10; c++)
        addSubMenu(menu, c, "SubMenu " + (c), "sub");
    
    menu = "sub";
    addMenu(menu, "SubMenu 1-10", "main");
    for(c = 0; c < 10; c++)
    addOption(menu, c, "Option " + (c + 1), ::test);
    
    menu = "_dbg";
    addMenu(menu, "Debug Menu", "main");
    addOption(menu, 0, "getDataIndex() Test", ::dataTest);
}

dataTest()
{
    debug(getDataIndex()[0].position[3]);
}