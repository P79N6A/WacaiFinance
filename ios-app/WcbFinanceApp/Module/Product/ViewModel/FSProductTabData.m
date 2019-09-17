//
//  FSProductTabData.m
//  FinanceApp
//
//  Created by xingyong on 2/2/16.
//  Copyright © 2016 com.wacai.licai. All rights reserved.
//

#import "FSProductTabData.h"
#import "NSDictionary+FSUtils.h"
#import "EGOCache.h"
#define kFSProductTabData @"fs_productTabData"

static NSString *const kName = @"classifyName";
static NSString *const kTabId = @"classifyId";
static NSString *const kTabURL = @"url";
static NSString *const kTabType = @"type";

@interface FSProductTabData ()

@end
@implementation FSProductTabData

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.mtabName    = StringValue([dict fs_objectMaybeNilForKey:kName]);
        self.mtabId      = StringValue([dict fs_objectMaybeNilForKey:kTabId]);
        self.mTabURL     = StringValue([dict fs_objectMaybeNilForKey:kTabURL]);
        self.mTabType    = StringValue([dict fs_objectMaybeNilForKey:kTabType]);
     }
    
    return self;
    
}

- (NSDictionary *)dictionaryDescription
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    
    [mutableDict setValue:self.mtabName forKey:kName];
    [mutableDict setValue:self.mtabId forKey:kTabId];
    [mutableDict setValue:self.mTabURL forKey:kTabURL];
    [mutableDict setValue:self.mTabType forKey:kTabType];
 
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"理财超市tab：%@", [self dictionaryDescription]];
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.mtabName         = [aDecoder decodeObjectForKey:kName];
    self.mtabId       = [aDecoder decodeObjectForKey:kTabId];
    self.mTabURL       = [aDecoder decodeObjectForKey:kTabURL];
    self.mTabType       = [aDecoder decodeObjectForKey:kTabType];
 
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_mtabName forKey:kName];
    [aCoder encodeObject:_mtabId forKey:kTabId];
    [aCoder encodeObject:_mTabURL forKey:kTabURL];
    [aCoder encodeObject:_mTabType forKey:kTabType];
 
}

- (id)copyWithZone:(NSZone *)zone
{
    FSProductTabData *copy = [[FSProductTabData alloc] init];
    
    if (copy) {

        copy.mtabName    = [self.mtabName copyWithZone:zone];
        copy.mtabId   = [self.mtabId copyWithZone:zone];
        copy.mTabURL  = [self.mTabURL copyWithZone:zone];
        copy.mTabType = [self.mTabType copyWithZone:zone];
        
    }
    
    return copy;
}

- (BOOL)save
{
    NSString *filePath = [self documentPath:kFSProductTabData];
 
    BOOL status = [NSKeyedArchiver archiveRootObject:self toFile:filePath];
    if (status) {
        [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:filePath]];
    }
    return status;
}
+ (FSProductTabData *)loadTabData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,kFSProductTabData];
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}
- (BOOL)remove{
    
    NSString *filePath = [self documentPath:kFSProductTabData];
    NSError *error = nil;
    BOOL isFlag= [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    if (error !=nil) {
        return NO;
    }
    
    return isFlag;
}

- (NSString *)documentPath:(NSString *)fineName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,fineName];
    return filePath;
}
inline static NSString *StringValue(id obj)
{
    if([obj isKindOfClass:[NSString class]]){
        return (NSString *)obj;
    }else if ([obj isKindOfClass:[NSNull class]]|| obj == nil) {
        return  @"";
    }else if ([obj isKindOfClass:[NSNumber class]]) {
        return  [NSString stringWithFormat:@"%@",[obj description]];
    } else{
        return @"";
    }
    return @"";
}
//保证不会被同步
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

@end
