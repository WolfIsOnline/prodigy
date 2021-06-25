/*
*    Project : prodigy
*    Author : WolfIsOnline
*    Description : Main gsc for prodigy, this will probably be broken up and organized later
*    Date : 3/3/2021
*/

init_prodigy()
{
    self.prodigy["state"] = "closed";
    self.prodigy["current"] = "main";
    
    self.prodigy["cursor"] = 0;
    self.prodigy["prev_cursor"] = 0;
    
    self.prodigyUI = [];
    self.prodigy["data"] = [];
    self.prodigy["data"]["name"] = [];
    self.prodigy["data"]["index"] = [];

    dev_tools(); // load dev menu
    t_prodigy(); // load default theme
    thread control_loop();
}

enter_menu(menu)
{
    thread set_state("open");

    for(c = 0; c < read_data().size; c++)
    {
        if(!is_text(read_data_index()[c]))
        self.prodigyUI[read_data_index()[c].name] = create_hud(read_data_index()[c].position[0], read_data_index()[c].position[1], read_data_index()[c].position[2], read_data_index()[c].position[3], read_data_index()[c]._size[0], read_data_index()[c]._size[1], read_data_index()[c].properties[0], read_data_index()[c].properties[1], read_data_index()[c].properties[2], read_data_index()[c].properties[3]);
        else if(is_text(read_data_index()[c]) && read_data_index()[c].name != "options")
        {
            if(!isDefined(read_data_index()[c].color))
            {
                self.prodigy["data"]["name"][read_data_index()[c].name].color = color(0xFFFFFF);
                self.prodigy["data"]["name"][read_data_index()[c]].color = color(0xFFFFFF);
            }
            self.prodigyUI[read_data_index()[c].name] = create_text(read_data_index()[c].properties[0], read_data_index()[c].properties[1], read_data_index()[c].position[0], read_data_index()[c].position[1], read_data_index()[c].position[2], read_data_index()[c].position[3], read_data_index()[c].properties[2], read_data_index()[c].properties[3], read_data_index()[c].text, read_data_index()[c].color);
        }
    }
    load_menu(menu); 
}

exit_menu()
{
    thread set_state("closed");
    for(c = 0; c < read_data().size; c++)
        self.prodigyUI[read_data_index()[c].name] destroy();
    self.prodigyUI["watermark"] destroy();
    self.prodigyUI["title"] destroy();
    destroy_options();
}

load_menu(menu)
{
    if(!isDefined(self.prodigy[menu].option))
    {
        debug("error", menu + " is not defined. exiting to avoid crash");
        exit_menu();
        return;
    }
    
    thread set_menu(menu);
    thread set_cursor(0);
    destroy_options();
    self.prodigyUI["title"] destroy();
    if(!isDefined(read_data()["title"].color))
    {
        self.prodigy["data"]["name"]["title"].color = color(0xFFFFFF);
        self.prodigy["data"]["index"]["title"].color = color(0xFFFFFF);
    }
    
    if(!isDefined(self.prodigyUI["title"]))
        self.prodigyUI["title"] = create_text(read_data()["title"].properties[0], read_data()["title"].properties[1], read_data()["title"].position[0], read_data()["title"].position[1], read_data()["title"].position[2], read_data()["title"].position[3], read_data()["title"].properties[2], read_data()["title"].properties[3], self.prodigy[menu].title, read_data()["title"].color);
    
    self.prodigyUI["option"] = [];  
    if(!isDefined(read_data()["options"].color))
    {
        self.prodigy["data"]["name"]["options"].color = color(0xFFFFFF);
        self.prodigy["data"]["index"]["options"].color = color(0xFFFFFF);
    }
    
    for(c = 0; c < self.prodigy[menu].option.size; c++)
    {
        if(!isDefined(self.prodigyUI["option"][c]))
            self.prodigyUI["option"][c] = create_text(read_data()["options"].properties[0], read_data()["options"].properties[1], read_data()["options"].position[0], read_data()["options"].position[1], read_data()["options"].position[2], (read_data()["options"].position[3] + (c * read_data()["options"].spacing)), read_data()["options"].properties[2], read_data()["options"].properties[3], self.prodigy[menu].option[c], read_data()["options"].color);
    }
    thread update_cursor();
}
    
destroy_options()
{
    if(isDefined(self.prodigyUI["option"]))
    {
        for(c = 0; c < self.prodigyUI["option"].size; c++)
            self.prodigyUI["option"][c] destroy();
    }
}
    
update_cursor()
{
    self.prodigyUI["cursor"].y = (get_cursor() * read_data()["options"].spacing) + self.prodigyUI["option"][0].y;
    self.prodigyUI["option"][get_prev_cursor()].color = read_data()["options"].color;
    self.prodigyUI["option"][get_prev_cursor()].alpha = read_data()["options"].properties[3];
    self.prodigyUI["option"][get_cursor()].color = read_data()["options"].hover_color;
    self.prodigyUI["option"][get_cursor()].alpha = read_data()["options"].hover_alpha;
}
    
add_menu(menu, title, parent)
{
    if(!isDefined(self.prodigy))
        self.prodigy = [];
    if(!isDefined(self.prodigy["menus"]))
        self.prodigy["menus"] = [];
    if(!isDefined(self.prodigy[menu]))
        self.prodigy["menus"][self.prodigy["menus"].size] = menu;
        
    self.prodigy[menu] = spawnStruct();
    self.prodigy[menu].title = title;
    self.prodigy[menu].name = menu;
    self.prodigy[menu].parent = parent;
    self.prodigy[menu].option = [];
    self.prodigy[menu].function = [];
    self.prodigy[menu].argument1 = [];
    self.prodigy[menu].argument2 = [];
    self.prodigy[menu].argument3 = [];
    self.prodigy[menu].argument4 = [];
    self.prodigy[menu].argument5 = [];
}

add_submenu(menu, name, child)
{
    index = self.prodigy[menu].option.size;
    self.prodigy[menu].option[index] = name;
    self.prodigy[menu].function[index] = ::load_menu;
    self.prodigy[menu].argument1[index] = child;
}

add_option(menu, option, function, argument1, argument2, argument3, argument4, argument5)
{
    index = self.prodigy[menu].option.size;
    self.prodigy[menu].option[index] = option;
    if(isDefined(function))  self.prodigy[menu].function[index] = function;
    if(isDefined(argument1)) self.prodigy[menu].argument1[index] = argument1;
    if(isDefined(argument2)) self.prodigy[menu].argument2[index] = argument2;
    if(isDefined(argument3)) self.prodigy[menu].argument3[index] = argument3;
    if(isDefined(argument4)) self.prodigy[menu].argument4[index] = argument4;
    if(isDefined(argument5)) self.prodigy[menu].argument5[index] = argument5;
}

update_option(menu, index, option, function, argument1, argument2, argument3, argument4, argument5)
{
    self.prodigy[menu].option[index] = option;
    if(isDefined(function))  self.prodigy[menu].function[index] = function;
    if(isDefined(argument1)) self.prodigy[menu].argument1[index] = argument1;
    if(isDefined(argument2)) self.prodigy[menu].argument2[index] = argument2;
    if(isDefined(argument3)) self.prodigy[menu].argument3[index] = argument3;
    if(isDefined(argument4)) self.prodigy[menu].argument4[index] = argument4;
    if(isDefined(argument5)) self.prodigy[menu].argument5[index] = argument5;
    
    self.prodigyUI["option"][index] destroy(); 
    self.prodigyUI["option"][index] = create_text(read_data()["options"].properties[0], read_data()["options"].properties[1], read_data()["options"].position[0], read_data()["options"].position[1], read_data()["options"].position[2], (read_data()["options"].position[3] + (index * read_data()["options"].spacing)), read_data()["options"].properties[2], read_data()["options"].properties[3], option, read_data()["options"].color);
    update_cursor();
}

set_theme_data(data, controls)
{   
    self.prodigy["data"]["controls"].open = controls.open;
    self.prodigy["data"]["controls"].close = controls.close;
    self.prodigy["data"]["controls"].scroll_up = controls.scroll_up;
    self.prodigy["data"]["controls"].scroll_down = controls.scroll_down;
    self.prodigy["data"]["controls"].select = controls.select;    
    for(index = 0; index < data.size; index++)
    {
        if(!isDefined(self.prodigy["data"]["name"][data[index].name])) self.prodigy["data"]["name"][data[index].name] = spawnStruct();
        if(!isDefined(self.prodigy["data"]["index"][index])) self.prodigy["data"]["index"][index] = spawnStruct();

        self.prodigy["data"]["name"][data[index].name].position = data[index].position;
        self.prodigy["data"]["name"][data[index].name]._size = data[index]._size;
        self.prodigy["data"]["name"][data[index].name].properties = data[index].properties;
        self.prodigy["data"]["name"][data[index].name].index = index;
            
        self.prodigy["data"]["index"][index].position = data[index].position;
        self.prodigy["data"]["index"][index]._size = data[index]._size;
        self.prodigy["data"]["index"][index].properties = data[index].properties;
        self.prodigy["data"]["index"][index].name = data[index].name;
            
        if(is_text(data[index]))
        {
            self.prodigy["data"]["name"][data[index].name].text = data[index].text;
            self.prodigy["data"]["name"][data[index].name].color = data[index].color;
                
            self.prodigy["data"]["index"][index].text = data[index].text;
            self.prodigy["data"]["index"][index].color = data[index].color;
                
        }
            
        switch(data[index].name)
        {
            case "options":
                self.prodigy["data"]["name"][data[index].name].spacing = data[index].spacing;
                self.prodigy["data"]["name"][data[index].name].hover_color = data[index].hover_color;
                self.prodigy["data"]["name"][data[index].name].hover_alpha = data[index].hover_alpha;
                    
                self.prodigy["data"]["index"][index].spacing = data[index].spacing;
                self.prodigy["data"]["index"][index].hover_color = data[index].hover_color;
                self.prodigy["data"]["index"][index].hover_alpha = data[index].hover_alpha;
            break;
                
            case "cursor":
                self.prodigy["data"]["name"][data[index].name].speed = data[index].speed;
                self.prodigy["data"]["index"][index].speed = data[index].speed;
            break;

        }
    }
}

read_controls()
{
    return self.prodigy["data"]["controls"];
}

read_data()
{
    return self.prodigy["data"]["name"];
}

read_data_index()
{
    return self.prodigy["data"]["index"];
}

// This can crash the game if used incorrectly
flush_memory()
{
    if(!isDefined(self.prodigy["menus"])) return;
    
    state = get_state();
    set_state("locked");
    for(c = 0; c < self.prodigy["menus"].size; c++)
    {
        self.prodigy[self.prodigy["menus"][c]].option = undefined;
        self.prodigy[self.prodigy["menus"][c]].function = undefined;
        self.prodigy[self.prodigy["menus"][c]].argument = undefined;
    }
    set_state(state);
    debug("warn", "memory flushed");
}

load_options(load)
{
    exit_menu();
    flush_memory();
    [[load]]();
    enter_menu("main");
}