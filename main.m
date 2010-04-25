//
//  main.m
//  Maestro
//
//  Created by Ryan Bates on 4/24/10.
//  Copyright Artbeats 2010. All rights reserved.
//

#import <MacRuby/MacRuby.h>
#import "MIDIUtility.h"

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
