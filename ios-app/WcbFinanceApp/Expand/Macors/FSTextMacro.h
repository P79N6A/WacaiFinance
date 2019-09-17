//
//  FSTextMacro.h
//  FinanceApp
//
//  Created by 叶帆 on 4/7/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#ifndef FSTextMacro_h
#define FSTextMacro_h

//去空格和换行
#define TRIM(string) [(string) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

//判断字符是否为空
#define isEmpty(string) (!string || string.length == 0 || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)

//替换空格
#define ReplaceSpace(string) [(string) stringByReplacingOccurrencesOfString:@" " withString:@""]

//Safa String
#define SafeString(string) ((string == nil || ![string isKindOfClass:[NSString class]]) ? @"": string)
#define SafeStringByDefault(string,defalut) ((string == nil || ![string isKindOfClass:[NSString class]]) ? defalut: string)

//Valid String
#define IS_ZW(string) [[NSPredicate predicateWithFormat:@"self matches %@",@"[\u4e00-\u9fa5]+"] evaluateWithObject:string]
#define IS_CN(char) ([(char) characterAtIndex:0] > 0x4e00 && [(char) characterAtIndex:0] < 0x9fff)
#define IS_VAILD_TEL(telStr) [[NSPredicate predicateWithFormat:@"self matches %@",@"1\\d{10}"] evaluateWithObject:telStr]

//Convert To Strong
#define IntToString(i) [NSString stringWithFormat:@"%d",i]


#endif /* FSTextMacro_h */
