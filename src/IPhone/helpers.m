/* 
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
   
   Copyright (c) 2010 Seleuco. Based in ZodTTD code.
   
*/

#include <sys/types.h>
#include <sys/sysctl.h>

#include "helpers.h"


const char* get_documents_path(char* file) {
    static char documents_path[1024];
#ifdef APPSTORE_BUILD
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex: 0];
    const char* path = [documentsDirectory UTF8String];
    sprintf(documents_path, "%s/%s", path, file);
#else
    sprintf(documents_path, "/var/mobile/Media/ROMs/MAME/%s", file);
#endif
    return documents_path;
}


@implementation Helper
 
+ (NSString *)machine
{
  size_t size;
 
  // Set 'oldp' parameter to NULL to get the size of the data
  // returned so we can allocate appropriate amount of space
  sysctlbyname("hw.machine", NULL, &size, NULL, 0); 
 
  // Allocate the space to store name
  char *name = malloc(size);
 
  // Get the platform name
  sysctlbyname("hw.machine", name, &size, NULL, 0);
 
  // Place name into a string
  NSString *machine = [NSString stringWithUTF8String:name];
 
  // Done with this
  free(name);
 
  return machine;
}

+(NSString*) resourcePathWithFilename:(NSString*)filename {
#ifdef APPSTORE_BUILD
    return [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], filename];  
#else
    return [NSString stringWithFormat:@"/Applications/iXpectrum.app/%s", filename];
#endif
 
}
+(NSString*) documentPathWithFilename:(NSString*)filename {
//#ifdef APPSTORE_BUILD
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths lastObject];
    if (!documentsDirectory) {
        NSLog(@"documents directory not found");
    }
    return [NSString stringWithFormat:@"%@/%@", documentsDirectory, filename];
//#else
//    return [NSString stringWithFormat:@"/var/mobile/Media/ROMs/iXpectrum/%s", filename];
//#endif
 
}

@end