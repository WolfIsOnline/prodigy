#define BLACK = "^0";
#define RED = "^1";
#define GREEN = "^2";
#define YELLOW = "^3";
#define BLUE = "^4";
#define CYAN = "^5";
#define PINK = "^6";
#define WHITE = "^7";

/*
    * better than using my convert_rgb(color) function
    * made by serious
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

    return((value & 0xFF0000) / 0xFF0000, (value & 0x00FF00) / 0x00FF00, (value & 0x0000FF) / 0x0000FF);
}

set_prev_cursor(position)
{
    self.prodigy["prev_cursor"] = position;
}

get_prev_cursor()
{
    return self.prodigy["prev_cursor"];
}

set_cursor(position)
{
    self.prodigy["cursor"] = position;
}

get_cursor()
{
    return self.prodigy["cursor"];
}

is_closed()
{
    if(self.prodigy["state"] == "closed")
        return true;
    return false;
}

is_open()
{
    if(self.prodigy["state"] == "open")
        return true;
    return false;
}

set_state(state)
{
    self.prodigy["state"] = state;
}

get_state()
{
    return self.prodigy["state"];
}

get_menu()
{
    return self.prodigy["current"];
}

set_menu(menu)
{
    self.prodigy["current"] = menu;
}

create_text(font, fontScale, align, relative, x, y, sort, alpha, text, color)
{
    font_string       = createFontString(font, fontScale);
    font_string.sort  = sort;
    font_string.alpha = alpha;
    font_string.color = color;
    font_string setPoint(align, relative, x, y);
    font_string setText(text);
    return font_string;
}

create_hud(align, relative, x, y, width, height, color, shader, sort, alpha)
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

create_server_hud(align, relative, x, y, width, height, color, shader, sort, alpha)
{
    hud          = newHudElem(self);
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

// Would recommend using color(value) instead of this
convert_rgb(red, green, blue)
{
    return (red / 255, green / 255, blue / 255);
}

test()
{
}

debug(oLevel, output)
{
    switch(toLower(oLevel))
    {
        case "success": type = GREEN + "[PRODIGY] SUCCESS"; break;
        case "warn": type = YELLOW + "[PRODIGY] WARNING"; break;
        case "error": type = RED + "[PRODIGY] ERROR"; break;
        default: type = WHITE + "[PRODIGY] OUTPUT"; break;
    }
    self iPrintln(type  + " --- " + output);
}

/*
    This is obsolete if you are using the prodigy menu base.
    Use the alignment(point) function instead. 
    Will keep this here because it's still useful to use if you are using it outside of the menu base.
*/
align(side)
{
    switch(toLower(side))
    {
        case "left": return self.x + (self.width / -2); 
        case "right": return self.x + (self.width / 2);
        case "top": return self.y + (self.height / -2);
        case "bottom": return self.y + (self.height / 2);
        default: return;
    }
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

is_text(struct)
{
    if(isString(struct.properties[1]))
        return false;
    return true;
}