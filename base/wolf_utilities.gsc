/*
*    Project : prodigy
*    Author : WolfIsOnline
*    Description : Useful Functions
*    Date : 6/25/2021
*/

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