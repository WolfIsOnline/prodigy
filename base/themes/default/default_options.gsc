/*
*    Project : prodigy
*    Author : WolfIsOnline
*    Description : Default options for prodigy
*    Date : 6/25/2021
*/

dev_menu()
{
    menu = "main";
    add_menu(menu, "Development Tools", undefined);
    add_submenu(menu, "Useful Tools", "useful");
    add_submenu(menu, "Menu Debug Tools", "menu_debug");
    add_submenu(menu, "Testing Menu", "testing");
    add_option(menu, ">> " + GREEN + "Activate Demo Menu" + WHITE + " <<", ::load_theme, ::t_prodigy, ::example_menu);
    
    menu = "useful";
    // add_option(menu, "Display ")
    menu = "menu_debug";
    add_menu(menu, "Menu Debug Tools", "main");
    add_option(menu, "call flush_memory()", ::flush_memory);
    add_option(menu, "call load_menu()", ::load_menu, get_menu());
    add_option(menu, "call exit_menu()", ::exit_menu);
    add_option(menu, "call display_menu_count()", ::display_menu_count);
    add_option(menu, "call display_option_count()", ::display_option_count);
   
    menu = "testing"; 
    add_menu(menu, "Testing Menu", "main");
    add_option(menu, "Change me to 'hi'", ::update_option, "main", 1, "hi");    
}

display_menu_count()
{
    debug("output", self.prodigy["menu"].size);
}

display_option_count()
{
    debug("output", self.prodigy["main"].option.size);
}