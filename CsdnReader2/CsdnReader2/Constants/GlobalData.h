//
//  GlobalData.h
//  SmartWuhan
//
//  Created by Fanlv on 13-4-25.
//  Copyright (c) 2013年 Fiberhome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FileManage.h"

@interface GlobalData : NSObject



+(GlobalData *)getInstance;

+(BOOL)connectToNetwork;
+(NSString*)getCurrentIp;
+(NSString*)getDateWithString:(NSString*)string format:(NSString *)strFormat;
+(double)distancecoor1:(CLLocationCoordinate2D)coor1 coor2:(CLLocationCoordinate2D)coor2;

+(NSString *)convertHanziToPinyin:(NSString *)hanzi;

+ (void)insertContent:(NSString *)content ToLocalFile:(NSString *)name;
+ (void)removeContent:(NSString *)content FromLocalFile:(NSString *)name;
+ (BOOL)isExitContent:(NSString *)content FromLocalFile:(NSString *)name;

+ (NSArray *)sortArray:(NSArray *)array WithKey:(NSString *)key ascending:(BOOL)ascending;

+ (void)setValue:(id)value forKey:(id)key;

+ (id)objectForKey:(id)key;
+ (int)intValueForKey:(id)key;


+ (CGSize)getTextSizeWithText:(NSString*)text rect:(CGSize)size font:(UIFont*)font;

+ (BOOL)downLoadFiletoDocumentWith:(NSString *)fileName andWebUrl:(NSString *)url;


+ (NSString *)getTodayStringwith:(NSString *)formatterString;
+ (NSString *)showMinusTimeWithSeconds:(double)seconds;
+ (UIColor *)getColor:(NSString *)hexColor;


+ (NSString *) GetVersion;
+ (BOOL)makeCall:(NSString *)number;


+ (NSString *)showMinusTimeWithNoYearDateString:(NSString *)date;

+ (NSString *)isErrorPageWithHtml:(NSString *)htmlContent;



@end
