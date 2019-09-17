//
//  FSColorMacro.h
//  FinanceApp
//
//  Created by 叶帆 on 4/7/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#ifndef FSColorMacro_h
#define FSColorMacro_h

//颜色转换
#define HEXCOLOR(rgbValue)        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HEXCOLORALPHA(rgbValue,r) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(float)(r)]

#define COLOR_DEFAULT_BACKGROUND  HEXCOLOR(0xF6F6F6)


#endif /* FSColorMacro_h */
