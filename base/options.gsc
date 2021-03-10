prodigy_options()
{
    menu = "main";
    addMenu(menu, "Main Menu", undefined);
    addOption(menu, "Run Struct Detection", ::structDetector);
    addOption(menu, "Run Custom Detection", ::customDetector);
}
