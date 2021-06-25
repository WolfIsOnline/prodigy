/*
*    Project : prodigy
*    Author : WolfIsOnline
*    Description : Manages theme loading
*    Date : 6/25/2021
*/

// This is where you load your theme you want and the options of your menu.
// I recommend using load_options(load) instead of calling the function directly.
start_theme()
{
    load_theme(::t_prodigy, ::dev_menu, false);
}

load_theme(theme_function, option_function, enter = true)
{
    if(!isDefined(self.prodigy["data"]["theme"])) self.prodigy["data"]["theme"] = [];
    
    // Lazy way to do this, I am working on a way to add, remove and edit data in the array more easily and neater way.
    self.prodigy["data"]["theme"][0] = theme_function;
    self.prodigy["data"]["theme"][1] = option_function;
    exit_menu();
    flush_memory();
    [[option_function]]();
    [[theme_function ]]();
    if(enter) enter_menu("main");
    debug("success", "theme loaded");
}

reload_theme()
{
    load_theme(self.prodigy["data"]["theme"][0], self.prodigy["data"]["theme"][1]);
}

load_options(load)
{
    exit_menu();
    flush_memory();
    [[load]]();
    enter_menu("main");
}
