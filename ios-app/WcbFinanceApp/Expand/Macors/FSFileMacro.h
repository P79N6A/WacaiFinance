//
//  FSFileMacro.h
//  FinanceApp
//
//  Created by 叶帆 on 4/7/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#ifndef FSFileMacro_h
#define FSFileMacro_h

#define DocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define FileDefaultHandle [NSFileManager defaultManager]
#define DocumentHtmlResourcePacket  [DocumentPath stringByAppendingPathComponent:@"wacaiFinancial.bundle"]

// For 资源包
//缓存目录
#define FinanceCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define FinanceDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

//资源文件路径
#define FinanceDocumentHtmlResourcePacket  [FinanceDocumentPath stringByAppendingPathComponent:@"wacaiFinancial.bundle"]
//存储资源文件的路径
#define FinanceHtmlStoreFinanceCachePath [FinanceDocumentPath stringByAppendingPathComponent:@"HtmlWriteFileFolder"]
#define FinanceHtmlStroeCachePath [FinanceDocumentPath stringByAppendingPathComponent:@"HtmlWriteFileFolder"]



#endif /* FSFileMacro_h */
