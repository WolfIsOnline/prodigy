/*
*    Project : prodigy
*    Author : WolfIsOnline
*    Description : Manages player controls
*    Date : 6/25/2021
*/

control_loop()
{
    self endon("disconnect");
    while(true)
    {
        if(self is_closed() ) 
        {
            if(self FragButtonPressed() && is_closed() ) 
                thread enter_menu("main");
        }
            
        else if(is_open() )
        {
       
            if(self adsButtonPressed() || self attackButtonPressed() )     
            {
                cursor = get_cursor();
                set_prev_cursor(cursor);
                
                cursor += self attackButtonPressed();
                cursor -= self adsButtonPressed();
                
                if(cursor < 0)
                    cursor = self.prodigy[get_menu()].option.size - 1;
                if(cursor >= self.prodigy[get_menu()].option.size)
                    cursor = 0;
                    
                set_cursor(cursor);
                thread update_cursor();
                wait read_data()["cursor"].speed;
            }
            
            if(self useButtonPressed() )
            {
                thread [[self.prodigy[get_menu()].function[get_cursor()]]] 
                (
                    self.prodigy[get_menu()].argument1[get_cursor()], 
                    self.prodigy[get_menu()].argument2[get_cursor()], 
                    self.prodigy[get_menu()].argument3[get_cursor()],
                    self.prodigy[get_menu()].argument4[get_cursor()],
                    self.prodigy[get_menu()].argument5[get_cursor()]
                );
                wait .15;
            }
            
            if(self MeleeButtonPressed() || self actionSlotThreeButtonPressed() ) 
            {
                if(get_menu() == "main")
                    thread exit_menu();
                else 
                    load_menu(self.prodigy[get_menu()].parent);
                wait .15;
            }
        }
        
        if(self secondaryoffhandbuttonpressed() )
        {
            
            display_option_count();
        }
        
        // rescue system incase you flush the memory
        if(self getstance() == "prone" && self MeleeButtonPressed() && self secondaryoffhandbuttonpressed() )
        {
            dev_menu();
            debug("success", "dev menu activated");
            wait .15;
        }
        wait .05;
    }
}