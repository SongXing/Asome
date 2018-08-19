//
//

#import "YCBeatifulGirl.h"

/*
 *  字符串混淆解密函数，将char[] 形式字符数组和 aa异或运算揭秘
 *  如果没有经过混淆，请关闭宏开关
 */
extern char* ycDecryptConstString(char* string)
{
    char* origin_string = string;
    while(*string) {
//        *string ^= 0xAA;
        *string ^= 0xAB;
        string++;
    }
    return origin_string;
}

