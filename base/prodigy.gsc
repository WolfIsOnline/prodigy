#define PRODIGY_NAME = "^1Prodigy ^7Menu Base";
#define PRODIGY_VERSION = "^3v0.2-alpha^7";
#define PRODIGY_COPYRIGHT = "Made By ^3WolfIsOnline";

/*
 BUG:
    MENU WILL NOT DESTROY WHEN CLOSED
*/
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
                wait readData()["cursor"].speed;
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
    
    for(c = 0; c < readData().size; c++)
    {
        if(!isText(readDataIndex()[c]))
            self.prodigyUI[readDataIndex()[c].name] = createHud(readDataIndex()[c].position[0], readDataIndex()[c].position[1], readDataIndex()[c].position[2], readDataIndex()[c].position[3], readDataIndex()[c]._size[0], readDataIndex()[c]._size[1], readDataIndex()[c].properties[0], readDataIndex()[c].properties[1], readDataIndex()[c].properties[2], readDataIndex()[c].properties[3]);
        else if(isText(readDataIndex()[c]) && readDataIndex()[c].name != "options")
        {
            if(!isDefined(readDataIndex()[c].color))
            {
                self.prodigy["data"]["name"][readDataIndex()[c].name].color = color(0xFFFFFF);
                self.prodigy["data"]["name"][readDataIndex()[c]].color = color(0xFFFFFF);
            }
            self.prodigyUI[readDataIndex()[c].name] = createText(readDataIndex()[c].properties[0], readDataIndex()[c].properties[1], readDataIndex()[c].position[0], readDataIndex()[c].position[1], readDataIndex()[c].position[2], readDataIndex()[c].position[3], readDataIndex()[c].properties[2], readDataIndex()[c].properties[3], readDataIndex()[c].text, readDataIndex()[c].color);
        }
    }
    
    if(!isDefined(self.prodigyUI["watermark"]))
        self.prodigyUI["watermark"] = createText("default", 1.0, "LEFT", "TOP", align("background", "left") + 5, align("outline", "bottom") - 7, 100, 1, PRODIGY_NAME + " " + PRODIGY_VERSION + " | " + PRODIGY_COPYRIGHT, (1,1,1));
    loadMenu(menu); 
}

exitMenu()
{
    thread setState("closed");
    for(c = 0; c < readData().size; c++)
        self.prodigyUI[readDataIndex()[c].name] destroy();
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
    if(!isDefined(readData()["options"].color))
    {
        self.prodigy["data"]["name"]["options"].color = color(0xFFFFFF);
        self.prodigy["data"]["index"]["options"].color = color(0xFFFFFF);
    }
    
    for(c = 0; c < self.prodigy[menu].option.size; c++)
    {
        if(!isDefined(self.prodigyUI["option"][c]))
            self.prodigyUI["option"][c] = createText(readData()["options"].properties[0], readData()["options"].properties[1], readData()["options"].position[0], readData()["options"].position[1], readData()["options"].position[2], (readData()["options"].position[3] + (c * readData()["options"].spacing)), readData()["options"].properties[2], readData()["options"].properties[3], self.prodigy[menu].option[c], readData()["options"].color);
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
    self.prodigyUI["cursor"].y = (getCursor() * readData()["options"].spacing) + self.prodigyUI["option"][0].y;
    self.prodigyUI["option"][getPrevCursor()].color = readData()["options"].color;
    self.prodigyUI["option"][getPrevCursor()].alpha = readData()["options"].properties[3];
    self.prodigyUI["option"][getCursor()].color = readData()["options"].hover_color;
    self.prodigyUI["option"][getCursor()].alpha = readData()["options"].hover_alpha;
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
        
        for(index = 0; index < data.size; index++)
        {
            if(!isDefined(self.prodigy["data"]["name"][data[index].name]))
                self.prodigy["data"]["name"][data[index].name] = spawnStruct();
            if(!isDefined(self.prodigy["data"]["index"][index]))
                self.prodigy["data"]["index"][index] = spawnStruct();

            self.prodigy["data"]["name"][data[index].name].position = data[index].position;
            self.prodigy["data"]["name"][data[index].name]._size = data[index]._size;
            self.prodigy["data"]["name"][data[index].name].properties = data[index].properties;
            self.prodigy["data"]["name"][data[index].name].index = index;
            
            self.prodigy["data"]["index"][index].position = data[index].position;
            self.prodigy["data"]["index"][index]._size = data[index]._size;
            self.prodigy["data"]["index"][index].properties = data[index].properties;
            self.prodigy["data"]["index"][index].name = data[index].name;
            
            if(isText(data[index]))
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

readData()
{
    return self.prodigy["data"]["name"];
}

readDataIndex()
{
    return self.prodigy["data"]["index"];
}

isCustom(struct)
{
    array = strTok("options;title;background;cursor;outline", ";");
    for(c = 0; c < array.size; c++)
    {
        if(struct.name != array[c])
            continue;
        return false;
    }
    return true;
}

isText(struct)
{
    if(isString(struct.properties[1]))
        return false;
    return true;
}