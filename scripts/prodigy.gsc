#define PRODIGY_NAME = "^1Prodigy ^7Menu Base";
#define PRODIGY_VERSION = "^3v0.1-alpha^7";
#define PRODIGY_COPYRIGHT = "Made By ^3WolfIsOnline";

init_prodigy()
{
    self.prodigy["state"] = "closed";
    self.prodigy["cursor"] = 0;
    self.prodigy["prev_cursor"] = 0;
    self.prodigy["current"] = "main";
    self.prodigy["data"] = [];
    self.prodigy["data"]["name"] = [];
    self.prodigy["data"]["index"] = [];

    prodigy_options();
    t_prodigy();
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
                wait getData()["cursor"].speed;
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
    
    for(c = 0; c < getData().size; c++)
        self.prodigyUI[getDataIndex()[c].name] = createHud(getDataIndex()[c].position[0], getDataIndex()[c].position[1], getDataIndex()[c].position[2], getDataIndex()[c].position[3], getDataIndex()[c]._size[0], getDataIndex()[c]._size[1], getDataIndex()[c].properties[0], getDataIndex()[c].properties[1], getDataIndex()[c].properties[2], getDataIndex()[c].properties[3]);
    if(!isDefined(self.prodigyUI["watermark"]))
        self.prodigyUI["watermark"] = createText("default", 1.0, "LEFT", "TOP", align("background", "left") + 5, align("outline", "bottom") - 7, 100, 1, PRODIGY_NAME + " " + PRODIGY_VERSION + " | " + PRODIGY_COPYRIGHT, (1,1,1));
    loadMenu(menu); 
}

exitMenu()
{
    thread setState("closed");
    for(c = 0; c < getData().size; c++)
        self.prodigyUI[getDataIndex()[c].name] destroy();
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
    self.prodigyUI["title"] = createText("objective", 1.7, "CENTER", "TOP", self.prodigyUI["outline"].x, align("outline", "top") + 15, 100, 1, self.prodigy[menu].title, (1,1,1));
    
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

setThemeData(data)
{
        
        for(c = 0; c < data.size; c++)
        {
            if(!isDefined(self.prodigy["data"]["name"][data[c].name]))
                self.prodigy["data"]["name"][data[c].name] = spawnStruct();
            if(!isDefined(self.prodigy["data"]["index"][c]))
                self.prodigy["data"]["index"][c] = spawnStruct();

            self.prodigy["data"]["name"][data[c].name].position = data[c].position;
            self.prodigy["data"]["name"][data[c].name]._size = data[c]._size;
            self.prodigy["data"]["name"][data[c].name].properties = data[c].properties;
            self.prodigy["data"]["name"][data[c].name].index = c;
            
            self.prodigy["data"]["index"][c].position = data[c].position;
            self.prodigy["data"]["index"][c]._size = data[c]._size;
            self.prodigy["data"]["index"][c].properties = data[c].properties;
            self.prodigy["data"]["index"][c].name = data[c].name;
            if(isDefined(data[c].speed))
            {
                self.prodigy["data"]["name"][data[c].name].speed = data[c].speed;
                self.prodigy["data"]["index"][c].speed = data[c].speed;
            }
            wait .05;
        }
}


getData()
{
    return self.prodigy["data"]["name"];
}

getDataIndex()
{
    return self.prodigy["data"]["index"];
}