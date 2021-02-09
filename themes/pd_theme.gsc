/*
    ui_name_here.position = [align, relative, x, y]
    ui_name_here._size = [width, height]
    ui_name_here.properties = [color, shader, sort, alpha]
*/

pd_theme()
{
    background = spawnstruct();
    cursor     = spawnstruct();
    outline    = spawnstruct();
    
    background.position   = ["CENTER", "TOP", 260, 200];
    background._size      = [300, 250];
    background.properties = [color(0x12151C), "white", 2, 1];
    
    cursor._size      = [background._size[0], 25];
    cursor.properties = [color(0x1B222C), "white", 3, 1];
    
    outline._size      = [background._size[0], background._size[1] + 50];
    outline.properties = [color(0x000000), "white", 1, 1];
    
    data = [background, cursor, outline]; //Warning: Array must be in this order.
    setData(data);
}