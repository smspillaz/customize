#import <UIKit/UIKit.h>
#import "CustomizeApp.h"

int main(int argc, char **argv)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    return UIApplicationMain(argc, argv, [CustomizeApp class]);
}

int NSCopyFile(NSString *from, NSString *to)
{
  NSString* copyCommand = [[NSString alloc] initWithFormat:@"/Applications/Customize.app/bin/cp \"%@\" \"%@\"",from,to];
  NSLog(@"Copy with command: %@",copyCommand);
	return system([copyCommand UTF8String]);
}

int copyFile(char *from, char *to)
{
	FILE *fpFrom = fopen(from, "rb");
	FILE *fpTo = fopen(to, "wb");
	unsigned char buf[1024];
	int len;
	while (!feof(fpFrom)) {
		len = fread(buf, 1, 1024, fpFrom);
		if (!ferror(fpFrom)) {
			fwrite(buf, 1, len, fpTo);
		}
		else {
			fclose(fpFrom);
			fclose(fpTo);
			return 0;
		}
	}
	fclose(fpFrom);
	fclose(fpTo);
	return 1;
}