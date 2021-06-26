/*
*    Project : prodigy
*    Author : Serious
*    Description : These are some useful functions created by Serious
*                  This isn't the complete gsc file, I have removed some things that I already have or do not need.
                   You can view the full gsc file here: https://github.com/seriousyt/iw-gsc-util/blob/master/serious-gsc.gsc
*               
*    Date : 6/25/2021
*/

/*
    serious mw3 utility
    youtube.com/anthonything
*/

// [CALLER] none
// [value] The RGB color component to convert
// Convert a hex integer into a color vector
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

// [CALLER] none
// [array] array to search
// [element] element to search for
// Return true if the element requested is in the array supplied
IsInArray(array, element)
{
   if(!isdefined(element))
        return false;
   foreach(e in array)
        if(e == element)
            return true;
}
        

// [CALLER] none
// [array] array to modify
// [item] item to add to the array
// [?allow_dupes] if false, the element will only be added if it is not already in the array
// Add an element to an array and return the new array.  
ArrayAdd(array, item, allow_dupes = 1)
{
    if(isdefined(item))
    {
        if(allow_dupes || !IsInArray(array, item))
        {
            array[array.size] = item;
        }
    }
    return array;
}

// [CALLER] none
// [array] array to clean
// Remove any undefined values from an array and return the new array.
ArrayRemoveUndefined(array)
{
    a_new = [];
    foreach(elem in array)
        if(isdefined(elem))
            a_new[a_new.size] = elem;
            
    return a_new;
}

// [CALLER] none
// [array] array to clean
// [value] value to remove from the array
// Remove all instances of value in array
ArrayRemove(array, value)
{
    a_new = [];
    
    foreach(elem in array)
        if(value != elem)
            a_new[a_new.size] = elem;      
    return a_new;
}

// [CALLER] none
// [array] array to change
// [index] index to use to insert the value
// [value] value to insert into the array
// Insert a value into an array
ArrayInsertValue(array, index, value)
{
    a_new = [];
    
    for(i = 0; i < index; i++)
    {
        a_new[i] = array[i];
    }
    
    a_new[index] = value;
    
    for(i = index + 1; i <= array.size; i++)
    {
        a_new[i] = array[i - 1];
    }
    
    return a_new;
}

// [CALLER] none
// [array] array to search
// [value] value to search for
// Find the index of a value in an array. If the value isnt found, return -1
ArrayIndexOf(array, value)
{
     for(i = 0; i < array.size; i++)
        if(isdefined(array[i]) && value == array[i])
            return i;
            
    return -1;
}
