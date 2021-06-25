dev_tools()
{
    menu = "main";
    add_menu(menu, "Development Tools", undefined);
    add_submenu(menu, "Useful Tools", "useful");
    add_submenu(menu, "Menu Debug Tools", "menu_debug");
    add_submenu(menu, "Testing Menu", "testing_menu");
    add_option(menu, ">> " + GREEN + "Activate Demo Menu" + WHITE + " <<", ::load_options, ::example_options);
    
    menu = "useful";
    // add_option(menu, "Display ")
    menu = "menu_debug";
    add_menu(menu, "Menu Debug Tools", "main");
    add_option(menu, "call flush_memory()", ::flush_memory);
    add_option(menu, "call load_menu()", ::load_menu, get_menu());
    add_option(menu, "call exit_menu()", ::exit_menu);
   
    menu = "testing"; 
    add_menu(menu, "Testing Menu", "main");
    add_option(menu, "Change me to 'hi'", ::update_option, "main", 1, "hi");    
    
    debug("Development Tools Loaded");
}