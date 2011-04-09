//
//  NameGenerator.c
//  ScreenShottr
//
//  Created by Ashwin Bhat on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "NameGenerator.h"

char *characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
#define NUM_CHARACTERS 62

void start_rng()
{
    srand((unsigned int) time(NULL));
}

char * random_filename(int length)
{
    char *filename;
    int i;
    
    filename = (char *) malloc(length * sizeof(*filename));
    for(i = 0; i < length; ++i)
        filename[i] = characters[rand() % NUM_CHARACTERS];
    return filename;
}