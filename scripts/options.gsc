prodigy_options()
{
    menu = "main";
    addMenu(menu, "Main Menu", undefined);
    addSubMenu(menu, 0, "Demo Menu", "demo");
    addSubMenu(menu, 1, "SubMenu 2", "sub");
    addSubMenu(menu, 2, "SubMenu 3", "sub");
    addSubMenu(menu, 3, "SubMenu 4", "sub");
    addSubMenu(menu, 4, "SubMenu 5", "sub");
    addSubMenu(menu, 5, "SubMenu 6", "sub");
    addSubMenu(menu, 6, "SubMenu 7", "sub");
    addSubMenu(menu, 7, "SubMenu 8", "sub");
    addSubMenu(menu, 8, "SubMenu 9", "sub");
    addSubMenu(menu, 9, "SubMenu 10", "sub");
    
    
    menu = "demo";
    addMenu(menu, "Demo Menu", "main");
    addOption(menu, 0, "Placeholder", ::test, "");
    
    
    menu = "sub";
    addMenu(menu, "SubMenu 1-10", "main");
    for(c = 0; c < 10; c++)
        addOption(menu, c, "Option " + (c + 1), ::test, "args working!");
}