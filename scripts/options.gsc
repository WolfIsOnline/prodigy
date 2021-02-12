prodigy_options()
{
    menu = "main";
    addMenu(menu, "Main Menu", undefined);
    for(c = 0; c < 10; c++)
        addSubMenu(menu, c, "SubMenu " + (c + 1), "sub");
    
    menu = "sub";
    addMenu(menu, "SubMenu 1-10", "main");
    for(c = 0; c < 10; c++)
    addOption(menu, c, "Option " + (c + 1), ::test);
}