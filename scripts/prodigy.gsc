#define HOVER_COLOR = color(0xFFFFFF);
#define OPTION_COLOR = color(0xFFFFFF);
#define HOVER_ALPHA = 1;
#define OPTION_ALPHA = .3;
#define PRODIGY_NAME = "^1Prodigy ^7Menu Base";
#define PRODIGY_VERSION = "^3v1.0-alpha^7";
#define PRODIGY_COPYRIGHT = "Made By ^3WolfIsOnline";
#define SCROLL_SPEED = .1;

init_prodigy()
{
    self.prodigy["state"] = "closed";
    self.prodigy["cursor"] = 0;
    self.prodigy["prev_cursor"] = 0;
    self.prodigy["current"] = "main";
    self.prodigy["data"] = [];
    self.prodigy["data"]["background"] = spawnStruct();
    self.prodigy["data"]["cursor"] = spawnStruct();
    self.prodigy["data"]["outline"] = spawnStruct();
    prodigy_options();
    pd_theme();
    self endon("disconnect");
    while(true)
    {
        if(self isClosed() )
        {
    
            if(self FragButtonPressed() && isClosed() ) 
                thread enterMenu("main");
        }
            
        else if(isOpen() )
        {
       
       	    if(self adsButtonPressed() || self attackButtonPressed() )     
            {
                cursor = getCursor();
                setPrevCursor(cursor);
                cursor += self attackButtonPressed();
                cursor -= self adsButtonPressed();
                if(cursor < 0)
                    cursor = self.prodigy[getMenu()].option.size - 1;
                if(cursor >= self.prodigy[getMenu()].option.size)
                    cursor = 0;
                setCursor(cursor);
                thread updateCursor();
                wait SCROLL_SPEED;
            }
            
            if(self useButtonPressed() )
            {
                thread [[self.prodigy[getMenu()].function[getCursor()]]] (self.prodigy[getMenu()].argument[getCursor()]);
                wait .15;
            }
            
            if(self MeleeButtonPressed() || self actionSlotThreeButtonPressed() ) 
            {
                if(getMenu() == "main")
                    thread exitMenu();
                else 
                    loadMenu(self.prodigy[getMenu()].parent);
                wait .15;
            }
        }
        wait .05;
    }
}

enterMenu(menu)
{
    thread setState("open");
    if(!isDefined(self.prodigyUI["background"])) 
        self.prodigyUI["background"] = createHud(getData()["background"].position[0], getData()["background"].position[1], getData()["background"].position[2], getData()["background"].position[3], getData()["background"]._size[0], getData()["background"]._size[1], getData()["background"].properties[0], getData()["background"].properties[1], getData()["background"].properties[2], getData()["background"].properties[3]);       
    if(!isDefined(self.prodigyUI["cursor"]) && isDefined(getData()["cursor"])) 
        self.prodigyUI["cursor"] = createHud("LEFT", "TOP", align("background", "left"), align("background", "top") + 13, getData()["cursor"]._size[0], getData()["cursor"]._size[1], getData()["cursor"].properties[0], getData()["cursor"].properties[1], getData()["cursor"].properties[2], getData()["cursor"].properties[3]);
    if(!isDefined(self.prodigyUI["background_outline"]))
        self.prodigyUI["background_outline"] = createHud("CENTER", "TOP", self.prodigyUI["background"].x, self.prodigyUI["background"].y - 5, getData()["outline"]._size[0], getData()["outline"]._size[1], getData()["outline"].properties[0], getData()["outline"].properties[1], getData()["outline"].properties[2], getData()["outline"].properties[3]);   
    
    if(!isDefined(self.prodigyUI["watermark"]))
        self.prodigyUI["watermark"] = createText("default", 1.0, "LEFT", "TOP", align("background", "left") + 5, align("background_outline", "bottom") - 7, 100, 1, PRODIGY_NAME + " " + PRODIGY_VERSION + " | " + PRODIGY_COPYRIGHT, (1,1,1));
    loadMenu(menu); 
}

exitMenu()
{
    thread setState("closed");
    self.prodigyUI["background"] destroy();
    self.prodigyUI["cursor"] destroy(); 
    self.prodigyUI["background_outline"] destroy();
    self.prodigyUI["watermark"] destroy();
    self.prodigyUI["title"] destroy();
    destroyOptions();
}

loadMenu(menu)
{
    thread setMenu(menu);
    thread setCursor(0);
    destroyOptions();
    self.prodigyUI["title"] destroy();
    if(!isDefined(self.prodigyUI["title"]))
        self.prodigyUI["title"] = createText("objective", 1.7, "CENTER", "TOP", self.prodigyUI["background_outline"].x, align("background_outline", "top") + 15, 100, 1, self.prodigy[menu].title, (1,1,1));
    
    self.prodigyUI["option"] = [];  
    for(c = 0; c < self.prodigy[menu].option.size; c++)
    {
        if(!isDefined(self.prodigyUI["option"][c]))
            self.prodigyUI["option"][c] = createText("default", 1.3, "LEFT", "TOP", align("background", "left") + 10, (align("background", "top") + (c * 25)) + 13, 100, OPTION_ALPHA, self.prodigy[menu].option[c], OPTION_COLOR);
    }
    thread updateCursor();
}
    
destroyOptions()
{
    if(isDefined(self.prodigyUI["option"]))
    {
        for(c = 0; c < self.prodigyUI["option"].size; c++)
            self.prodigyUI["option"][c] destroy();
    }
}
updateCursor()
{
    self.prodigyUI["cursor"].y = (getCursor() * 25) + self.prodigyUI["option"][0].y; 
    self.prodigyUI["option"][getPrevCursor()].color = OPTION_COLOR;
    self.prodigyUI["option"][getPrevCursor()].alpha = OPTION_ALPHA;
    self.prodigyUI["option"][getCursor()].color = HOVER_COLOR;
    self.prodigyUI["option"][getCursor()].alpha = HOVER_ALPHA;
}
    
addMenu(menu, title, parent)
{
    if(!isDefined(self.prodigy))
        self.prodigy = [];
    self.prodigy[menu] = spawnStruct();
    self.prodigy[menu].title = title;
    self.prodigy[menu].parent = parent;
    self.prodigy[menu].option = [];
    self.prodigy[menu].function = [];
    self.prodigy[menu].argument = [];
}

addSubMenu(menu, index, name, argument)
{
    self.prodigy[menu].option[index] = name;
    self.prodigy[menu].function[index] = ::loadMenu;
    self.prodigy[menu].argument[index] = argument;
}
    
addOption(menu, index, option, function, argument)
{
    self.prodigy[menu].option[index] = option;
    self.prodigy[menu].function[index] = function;
    if(isDefined(argument))
        self.prodigy[menu].argument[index] = argument;
}

// easy way to align ui to a certain side of another ui
align(ui, side)
{
    switch(toLower(side))
    {
        case "left": return self.prodigyUI[ui].x + (self.prodigyUI[ui].width / -2); 
        case "right": return self.prodigyUI[ui].x + (self.prodigyUI[ui].width / 2);
        case "top": return self.prodigyUI[ui].y + (self.prodigyUI[ui].height / -2);
        case "bottom": return self.prodigyUI[ui].y + (self.prodigyUI[ui].height / 2);
        default: return;
    }
}

// might be a more dynamic way of doing this
setData(data)
{
    if(!isDefined(self.prodigy["data"]))
        self.prodigy["data"] = [];
    self.prodigy["data"]["background"].position = data[0].position;
    self.prodigy["data"]["background"]._size = data[0]._size;
    self.prodigy["data"]["background"].properties = data[0].properties;
    self.prodigy["data"]["cursor"]._size = data[1]._size;
    self.prodigy["data"]["cursor"].properties = data[1].properties;
    self.prodigy["data"]["outline"]._size = data[2]._size;
    self.prodigy["data"]["outline"].properties = data[2].properties;
}
define_array(name)
{
    if(!isDefined(self.prodigy[name]))
        self.prodigy[name] = [];
}

getData()
{
    return self.prodigy["data"];
}
