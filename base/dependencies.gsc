#define BLACK = "^0";
#define RED = "^1";
#define GREEN = "^2";
#define YELLOW = "^3";
#define BLUE = "^4";
#define CYAN = "^5";
#define PINK = "^6";
#define WHITE = "^7";

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