#define black = "^0";
#define red = "^1";
#define green = "^2";
#define yellow = "^3";
#define blue = "^4";
#define cyan = "^5";
#define pink = "^6";
#define white = "^7";

/*
    * better than using my convert_rgb(color) function
    * script made by serious
    * taken from serious-gsc.gsc > https://github.com/seriousyt/iw-gsc-util/blob/master/serious-gsc.gsc
*/
color(value)
{
    /*
        Size constraints comment:
        
        Why is this better than rgb = (r,g,b) => return (r/255, g/255, b/255)?
        
        This will emit PSC, GetInt, align(4), value, SFT, align(1 + pos, 4), 4
        rgb... emits PSC, {GetInt, align(4), value}[3], SFT, align(1 + pos, 4), 4
        Vector emits Vec, align(4), r as float, b as float, g as float 
        
        color:  Min: 14, Max: 17
        rgb:    Min: 30, Max: 33
        vector: Min: 13, Max: 16
    */

    return
    (
    (value & 0xFF0000) / 0xFF0000,
    (value & 0x00FF00) / 0x00FF00,
    (value & 0x0000FF) / 0x0000FF
    );
}

getRandomColor()
{
    chars = "0123456789ABCDEF";
    for(c = 0; c < 6; c++)
        append += chars[RandomInt(16)];
}

runRandomColor()
{
    while(true)
    {
        newColor = getRandomColor();
        self.prodigyUI["background"].color = color(newColor);
        debug("background color set to ^1" + newColor + "^7");
        wait .5;
    }
}

setPrevCursor(integer)
{
    self.prodigy["prev_cursor"] = integer;
}

getPrevCursor()
{
    return self.prodigy["prev_cursor"];
}

setCursor(integer)
{
    self.prodigy["cursor"] = integer;
}

getCursor()
{
    return self.prodigy["cursor"];
}

isClosed()
{
    if(self.prodigy["state"] == "closed")
        return true;
    return false;
}

isOpen()
{
    if(self.prodigy["state"] == "open")
        return true;
    return false;
}

setState(state)
{
    self.prodigy["state"] = state;
}

getState()
{
    return self.prodigy["state"];
}

getMenu()
{
    return self.prodigy["current"];
}

setMenu(menu)
{
    self.prodigy["current"] = menu;
}

define_array(name)
{
    if(!isDefined(self.prodigy[name]))
        self.prodigy[name] = [];
}

createText(font, fontScale, align, relative, x, y, sort, alpha, text, color)
{
    font_string       = createFontString(font, fontScale);
    font_string.sort  = sort;
    font_string.alpha = alpha;
    font_string.color = color;
    font_string setPoint(align, relative, x, y);
    font_string setText(text);
    return font_string;
}

createHud(align, relative, x, y, width, height, color, shader, sort, alpha)
{
    hud          = newClientHudElem(self);
    hud.elemType = "bar";
    hud.children = [];
    hud.width    = width;
    hud.height   = height;
    hud.align    = align;
    hud.relative = relative;
    hud.xOffset  = 0;
    hud.yOffset  = 0;
    hud.sort     = sort;
    hud.color    = color;
    hud.alpha    = alpha;
    hud.shader   = shader;
    hud setParent(level.uiParent);
    hud setShader(shader,width,height);
    hud setPoint(align, relative, x, y);
    return hud;
}

convert_rgb(red, green, blue)
{
    return (red / 255, green / 255, blue / 255);
}

test()
{
}

debug(output)
{
    self iPrintln(yellow + "[PRODIGY]" + white + " > " + output);
}

alignment(point)
{
    switch(toLower(point))
    {
        case "left": return (self.position[2] + (self._size[0] / -2));
        case "right": return (self.position[2] + (self._size[0] / 2));
        case "top": return (self.position[3] + (self._size[1] / -2));
        case "bottom": return (self.position[3] + (self._size[1] / 2));
        default: debug("undefined point '" + point + "'");
    }
}