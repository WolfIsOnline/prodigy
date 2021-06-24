/*
    #### Small tutorial on how to build custom themes in prodigy ####
    * = required variblaes
    
    * this allows the menu to reference your hud when it needs to.
    hud_name.name       = hud_name; - this allows the menu to reference your hud when it needs to
    
    * align - choose from LEFT, RIGHT, TOP, BOTTOM
    * relative - choose from LEFT, RIGHT, TOP, BOTTOM
    * x - allows you to position the hud from left to right on an axis
    * y - allows you to position the hud from top to bottom on an axis
    hud_name.position = [align, relative, x, y]; 
    
    * width - the width of the hud
    * height - the height of the hud
    hud_name._size = [width, height];
    
    * color - the color of your hud, use color(value) to use hex colors
    * shader - can choose from a list of shaders, 
    * sort - can think of this as a z axis
    * alpha - basically the opacity of the hud
    hud_name.properties = [color, shader, sort, alpha]; 
    
    
    #### Small tutorial on how to use text with themes, the base can distinguish between a normal hud and a text hud ####
    
    * align - choose from LEFT, RIGHT, TOP, BOTTOM
    * relative - choose from LEFT, RIGHT, TOP, BOTTOM
    * x - allows you to position the hud from left to right on an axis
    * y - allows you to position the hud from top to bottom on an axis
    text_name.position = [align, relative, x, y];
    
    * this allows the menu to reference your hud when it needs to.
    - if the name is "options" it will display the options of the menu.
    - if the name is "title" it will display the name of the current menu that is selected.
    text_name.name = string_name;
    
    * font name - this is the font type, can choice between default, objective, bigfixed and smallfixed.
    * font size - the size of the font
    * sort - can think of this as a z axis
    * alpha - basically the opacity of the hud
    text_name.properties = [font name, font size, sort, alpha];
    
    * what the text will read
    text_name.text       = text;
    

    
    These are optional:
    - text_color and glow_color are not required. 
    - You can use one or both of them
    - if text_color is undefined then the color will be white
    - glow_color will remain undefined if it is not defined
      text_name.color = [text_color, glow_color]; 
      
    At the end of your theme file, you must pass your struct into setThemeData(data) for the menu to display it.
    See below for an example.
*/
  
#define PRODIGY_NAME = "^1Prodigy ^7Menu Base";
#define PRODIGY_VERSION = "^3v0.2-alpha^7";
#define PRODIGY_COPYRIGHT = "Made By ^3WolfIsOnline";

tProdigy()
{
    background            = spawnStruct();
    background.name       = "background";
    background.position   = ["CENTER", "TOP", 260, 200];
    background._size      = [300, 250];
    background.properties = [color(0x12151C), "white", 2, 1];
    
    outline            = spawnStruct();
    outline.name       = "outline";
    outline.position   = ["CENTER", "TOP", background.position[2], (background.position[3] - 5)];
    outline._size      = [background._size[0], background._size[1] + 50];
    outline.properties = [color(0x000000), "white", 1, 1];
    
    cursor            = spawnStruct();
    cursor.name       = "cursor";
    cursor._size      = [background._size[0], 25];
    cursor.position   = ["CENTER", "TOP", background.position[2], background alignment("top") + (cursor._size[1] / 2)];
    cursor.properties = [color(0x1B222C), "white", 3, 1];
    cursor.speed      = .1;
    
    options             = spawnStruct();
    options.name        = "options";
    options.position    = ["LEFT", "TOP", cursor alignment("left") + 4, cursor.position[3]];
    options.properties  = ["default", 1.3, 100, .3];
    options.spacing     = 25;
    options.hover_color = color(0xFFFFFF);
    options.hover_alpha = 1;
    
    title            = spawnStruct();
    title.name       = "title";
    title.position   = ["CENTER", "TOP", outline.position[2], outline alignment("top") + 15];
    title.properties = ["objective", 1.7, 100, 1];
    
    watermark            = spawnstruct();
    watermark.name       = "watermark";
    watermark.position   = ["LEFT", "TOP", background alignment("left") + 5, outline alignment("bottom") - 7];
    watermark.properties = ["default", 1.0, 100, 1];
    watermark.text       = PRODIGY_NAME + " " + PRODIGY_VERSION + " | " + PRODIGY_COPYRIGHT;
    
    data = [background, cursor, outline, options, title, watermark];
    setThemeData(data);
}