devOptions()
{
    menu = "main";
    addMenu(menu, "Development Menu", undefined);
    addOption(menu, "Run Struct Detection", ::structDetector);
    addOption(menu, "Run Custom Detection", ::customDetector);
    addOption(menu, "Flush Memory", ::flushMemory);
    addOption(menu, ">> " + GREEN + "Activate Demo Menu" + WHITE + " <<", ::loadOptions, ::demoOptions);
    
    for(c = 0; c < 3; c++)
    {
        addMenu("main_" + c, "Testing", "main");
        addOption("main_" + c, "Options", ::test);
    }
}

demoOptions()
{
    menu = "main";
    addMenu(menu, "Demo Menu", undefined);
    for(c = 1; c <= 9; c++)
        addSubMenu(menu, "SubMenu " + c, "menu");
    addOption(menu, ">> " + RED + "Go Back To Dev Menu" + WHITE + " <<", ::loadOptions, ::devOptions);
        
    menu = "menu";
    addMenu(menu, "SubMenu", "main");
    for(z = 1; z <= 10; z++)
        addOption(menu, "Option " + z, ::test);
}

// This can crash the game if used incorrectly
flushMemory()
{
    if(!isDefined(self.prodigy["menus"]))
        return;
        
    state = getState();
    setState("locked");
    for(c = 0; c < self.prodigy["menus"].size; c++)
    {
        self.prodigy[self.prodigy["menus"][c]].option = undefined;
        self.prodigy[self.prodigy["menus"][c]].function = undefined;
        self.prodigy[self.prodigy["menus"][c]].argument = undefined;
    }
    
    debug("memory flushed.");
    setState(state);
}

loadOptions(load)
{
    exitMenu();
    flushMemory();
    [[load]]();
    enterMenu("main");
}