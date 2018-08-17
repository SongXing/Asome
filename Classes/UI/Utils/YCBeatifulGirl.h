//
//

#import <Foundation/Foundation.h>

//字符串混淆加密 和 解密的宏开关
#define zzs_beatifulgirl
#ifdef zzs_beatifulgirl
#define beatifulgirl_NSSTRING(string) [NSString stringWithUTF8String:ycDecryptConstString(string)]
#define beatifulgirl_CSTRING(string) ycDecryptConstString(string)
#else
#define beatifulgirl_NSSTRING(string) @string
#define beatifulgirl_CSTRING(string) string
#endif

extern char* ycDecryptConstString(char* string);
