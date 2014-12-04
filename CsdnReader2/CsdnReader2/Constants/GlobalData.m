//
//  GlobalData.h
//  SmartWuhan
//
//  Created by Fanlv on 13-4-25.
//  Copyright (c) 2013年 Fiberhome. All rights reserved.
//

#import "GlobalData.h"
#import "Reachability.h"
#import "Constants.h"
#import "MUser.h"
#import "GTMBase64.h"
#import "HTMLParser.h"

static GlobalData *globalData=nil;

@implementation GlobalData


+(GlobalData *)getInstance
{
    if (globalData==nil) {
        globalData = [[GlobalData alloc] init];
    }
    
    return globalData;
}

+(BOOL)connectToNetwork{
    BOOL network = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable;
    if (network) {
//        NSLog(@"有网络");
    }else{
        NSLog(@"无网络");
    }
	return network;
}



+(NSString*)getCurrentIp{
    NSURL *url = [NSURL URLWithString:@"http://automation.whatismyip.com/n09230945.asp"];
    NSString *ipStr = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
    return ipStr;
}



+(NSString*)getDateWithString:(NSString*)string  format:(NSString *)strFormat{

    if(string == NULL || [string length] <= 0 || [string isEqualToString:@"0"])
        return @"未知";
    
   //    //时间戳转成时间
    NSTimeInterval timeInterval = [string doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:strFormat];
    
    NSString *newStr = [formatter stringFromDate:date];
    return newStr;
}


//计算两点间的实际距离
+(double)distancecoor1:(CLLocationCoordinate2D)coor1 coor2:(CLLocationCoordinate2D)coor2
{
    double lon1,lon2,lat1,lat2;
    lat1=coor1.latitude; lat2=coor2.latitude;
    lon1=coor1.longitude;lon2=coor2.longitude;
    if(lat1 == 0 || lat2 == 0 || lon1 == 0 || lon2 == 0)
        return 0;
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lon1];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lon2];
    double distance  = [curLocation distanceFromLocation:otherLocation];
    return distance;
}


+(NSString *)convertHanziToPinyin:(NSString *)hanzi
{
    NSMutableString *string = [hanzi mutableCopy];
    NSLog(@"Before: %@", string); // Before: 你好
    CFStringTransform((__bridge CFMutableStringRef)string, NULL, kCFStringTransformMandarinLatin, NO);
    NSLog(@"After: %@", string);  // After: nǐ hǎo
    CFStringTransform((__bridge CFMutableStringRef)string, NULL, kCFStringTransformStripDiacritics, NO);
    NSLog(@"Striped: %@", string); // Striped: ni hao
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}


+ (void)setValue:(id)value forKey:(id)key
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectForKey:(id)key
{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return value;
}

+ (int)intValueForKey:(id)key
{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    int notificationCount = 0;
    if (value)
        notificationCount = [value intValue];
    return notificationCount;
}


+ (void)insertContent:(NSString *)content ToLocalFile:(NSString *)name
{
    NSString *contentIDs = [[NSUserDefaults standardUserDefaults] objectForKey:name];
    if (contentIDs == nil)
    {
        contentIDs =@"";
    }
    NSString *contentIdString = [NSString stringWithFormat:@"%@%@,",contentIDs,content];
    [[NSUserDefaults standardUserDefaults] setValue:contentIdString forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeContent:(NSString *)content FromLocalFile:(NSString *)name
{
    NSString *contentIDs = [[NSUserDefaults standardUserDefaults] objectForKey:name];
    if (contentIDs == nil)
    {
        contentIDs =@"";
    }
    NSString *removeString = [NSString stringWithFormat:@"%@,",content];
    contentIDs = [contentIDs stringByReplacingOccurrencesOfString:removeString withString:@""];
    [[NSUserDefaults standardUserDefaults] setValue:contentIDs forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (BOOL)isExitContent:(NSString *)content FromLocalFile:(NSString *)name
{
    NSString *contentIDs = [[NSUserDefaults standardUserDefaults] objectForKey:name];
    if (contentIDs == nil)
        contentIDs = @"";
    NSString *serarchstring = [NSString stringWithFormat:@"%@,",content];
    NSRange isRange = [contentIDs rangeOfString:serarchstring options:NSCaseInsensitiveSearch];
    BOOL isExit = (isRange.location != NSNotFound);
    return isExit;
}

+ (NSArray *)sortArray:(NSArray *)array WithKey:(NSString *)key ascending:(BOOL)ascending
{
    NSMutableArray *tmpArray = [array mutableCopy];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    NSArray *sortDescriptors = [NSArray arrayWithObject: sortDescriptor];
    [tmpArray sortUsingDescriptors:sortDescriptors];
    array = [tmpArray copy];
    
    return array;
}

+ (CGSize)getTextSizeWithText:(NSString*)text rect:(CGSize)size font:(UIFont*)font
{
    if (text == nil || [text isEqualToString:@""]) {
        return CGSizeZero;
    }
    
    if (OS_VERSION >= 7.0) {
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text
                                                                                   attributes:attributesDictionary];
        CGSize tmpSize =  [string boundingRectWithSize:CGSizeMake(size.width, MAXFLOAT)
                                    options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                    context:nil].size;
        
        tmpSize.height += 5;
        return tmpSize;
    } else {
        UILabel *label = [[UILabel alloc] init];
        label.text = text;
        label.font = font;
        return [label textRectForBounds:CGRectMake(0, 0, size.width, MAXFLOAT) limitedToNumberOfLines:0].size;
    }
}




+ (float)calculateStringWidthWithString:(NSString *)string font:(UIFont *)font
{
//    // 调整在不同版本系统下文字的高度计算问题
//    if (OS_VERSION < 7.0)
//    {
//        CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
//        return size.width;
//        
//    }else
    {
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              font, NSFontAttributeName,nil];
        NSMutableAttributedString *tmpString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributesDictionary];
        CGRect rect = [tmpString boundingRectWithSize:CGSizeMake(MAXFLOAT, 1000.0)
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              context:nil];
        return rect.size.width;
        
        
    }
}


+ (BOOL)downLoadFiletoDocumentWith:(NSString *)fileName andWebUrl:(NSString *)url
{
    NSString *path = [FileManage getDocPath];
    NSString *localPath = [path stringByAppendingPathComponent:fileName];
    
    NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    if (urlData)
    {
        BOOL isSaveSuccess = [urlData writeToFile:localPath atomically:YES];
        return isSaveSuccess;
    }

    return NO;
}




+ (NSString *)getTodayStringwith:(NSString *)formatterString
{
//    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formatterString];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    return dateString;
}


+ (NSString *)showMinusTimeWithSeconds:(double)seconds
{
 
    
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    
    NSString *showDateString = [[NSString alloc] init];
    int distance = fabs([timeData timeIntervalSinceNow]);
    if (distance < 60)
    {
        int i = distance;
        NSString *mStr = (i == 1)?@"":@"s";
        showDateString = [NSString stringWithFormat:@"%d second%@ ago",i,mStr];
    }
    else if (distance < 3600)
    {
        int i = distance/60;
        NSString *mStr = (i == 1)?@"":@"s";
        showDateString = [NSString stringWithFormat:@"%d miniute%@ ago",i,mStr];
    }
    else if (distance < 86400)
    {
        int i = distance/3600;
        NSString *mStr = (i == 1)?@"":@"s";
        showDateString = [NSString stringWithFormat:@"%d hour%@ ago",i,mStr];
    }
    else if (distance < 86400 * 30)
    {
        int i = distance/86400;
        NSString *mStr = (i == 1)?@"":@"s";
        showDateString = [NSString stringWithFormat:@"%d day%@ ago",i,mStr];
    }
    else
    {
        int i = distance/86400/30;
        NSString *mStr = (i == 1)?@"":@"s";
        showDateString = [NSString stringWithFormat:@"%d month%@ ago",i,mStr];
    }
    
    return showDateString;
    
}


+ (NSString *) GetVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
    NSString *Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return Version;
}

//拨打电话的方法
+ (BOOL)makeCall:(NSString *)number
{
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", number]];
    return  [[UIApplication sharedApplication] openURL:telURL];
    // [self AfterCallTaxi];
}





+ (UIColor *)getColor:(NSString *)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}




// ---------date = 07-28 12:05
+ (NSString *)showMinusTimeWithNoYearDateString:(NSString *)date
{
    //------显示发布时间和发布人
    //得到日历对象
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //选择获取的时间单元标识，这里可以根据年来对应时间组件获取的参数调整，可以看看下面的对应列表
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //根据标识和时间创建事件组件，NSDateComponents还有很多用途，可以查看官方文档
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
    //获取相应的时间操作
    [comps year];     //对应 - NSMonthCalendarUnit
    NSMutableString *dateString = [[NSMutableString alloc] initWithString:date ];
    [dateString insertString:[NSString stringWithFormat:@"%ld-", (long)[comps year]] atIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    NSDate *sendDate = [dateFormatter dateFromString:dateString];
    
    
    NSString *showDateString = [[NSString alloc] init];
    int distance = fabs([sendDate timeIntervalSinceNow]);
    if (distance < 60)
    {
        showDateString = [NSString stringWithFormat:@"%d秒前",distance];
    }
    else if (distance < 3600)
    {
        showDateString = [NSString stringWithFormat:@"%d分前",distance/60];
    }
    else if (distance < 86400)
    {
        showDateString = [NSString stringWithFormat:@"%d小时前",distance/3600];
    }
    else if (distance < 86400 * 28)
    {
        showDateString = [NSString stringWithFormat:@"%d天前",distance/86400];
    }
    else
    {
        showDateString = date;
    }
    
    return showDateString;
    
}

+ (NSString *)isErrorPageWithHtml:(NSString *)htmlContent
{
    
    
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlContent error:&error];
    if (error)
    {
        return nil;
    }
    HTMLNode *bodyNode = [parser body];
    
    HTMLNode *fullNode = [bodyNode findChildOfClass:@"full"];
    
    HTMLNode *errorNode = [fullNode findChildOfClass:@"error"];
    
    NSArray *spanArray = [errorNode findChildTags:@"span"];
    
    HTMLNode *spanErrorNode = [spanArray objectAtIndex:0];
    
    NSString *errorCode = [spanErrorNode getAttributeNamed:@"class"];
    
    //HTMLNode *errorNode = [bodyNode findChildOfClass:@"error404"];
    NSString *errorString;
    if (errorCode)
    {
        errorString = [NSString stringWithFormat:@"服务器发生错误%@",errorCode];
        if ([errorCode isEqualToString:@"error500"])
        {
            errorString = @"服务器响应错误，error500";
        }
        else if ([errorCode isEqualToString:@"error404"])
        {
            errorString = @"该页面已经404，你懂的。。。。。。";
        }
    }
    

    
    
    return errorString;
}



//
//+ (CLLocationCoordinate2D )gpsGcj02ToBd09:(CLLocationCoordinate2D )locationCoord
//{
//    NSDictionary *baidudict =BMKBaiduCoorForGcj(CLLocationCoordinate2DMake(locationCoord.latitude, locationCoord.longitude));
//    //    NSLog(@"google坐标是:%f,%f",locationCoord.latitude,locationCoord.longitude);
//    NSString *xbase64 =[baidudict objectForKey:@"x"];
//    NSString *ybase64 = [baidudict objectForKey:@"y"];
//    NSData *xdata = [GTMBase64 decodeString:xbase64];
//    NSData *ydata = [GTMBase64 decodeString:ybase64];
//    NSString *xstr = [[NSString alloc] initWithData:xdata encoding:NSUTF8StringEncoding];
//    NSString *ystr = [[NSString alloc] initWithData:ydata encoding:NSUTF8StringEncoding];
//    CLLocationCoordinate2D result;
//    result.latitude =[ystr floatValue];
//    result.longitude = [xstr floatValue];
//    //    NSLog(@"百度坐标是:%f,%f",result.latitude,result.longitude);
//    return result;
//}
//
//
//#pragma mark - 地球坐标系 (WGS-84) 到火星坐标系 (GCJ-02) 的转换算法
//
//const double pi = 3.14159265358979324;
//
////
//// Krasovsky 1940
////
//// a = 6378245.0, 1/f = 298.3
//// b = a * (1 - f)
//// ee = (a^2 - b^2) / a^2;
//const double a = 6378245.0;
//const double ee = 0.00669342162296594323;
//
////
//// World Geodetic System ==> Mars Geodetic System
//
//+ (NSArray *)GpsWgsToGCjWithWgLat:(double)wgLat WgLog:(double)wgLon
//{
//    
//    NSNumber *mgLat = 0;
//    NSNumber *mgLon = 0;
//    if ([self outOfChinaWithLat:wgLat Lon:wgLon])
//    {
//        mgLat = [NSNumber numberWithDouble:wgLat];
//        mgLon = [NSNumber numberWithDouble:wgLon];
//    }
//    else
//    {
//        double dLat =[self transformLatX:wgLon - 105.0 Y:wgLat - 35.0];
//        double dLon = [self transformLonX:wgLon - 105.0 Y:wgLat - 35.0];
//        double radLat = wgLat / 180.0 * pi;
//        double magic = sin(radLat);
//        magic = 1 - ee * magic * magic;
//        double sqrtMagic = sqrt(magic);
//        dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
//        dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
//        mgLat = [NSNumber numberWithDouble:wgLat + dLat];
//        mgLon = [NSNumber numberWithDouble:wgLon + dLon];
//    }
//    
//    return [NSArray arrayWithObjects:mgLat,mgLon, nil];
//    
//}
//
//
//+ (BOOL)outOfChinaWithLat:(double)lat Lon:(double)lon
//{
//    if (lon < 72.004 || lon > 137.8347)
//        return true;
//    if (lat < 0.8293 || lat > 55.8271)
//        return true;
//    return false;
//}
//
//+ (double)transformLatX:(double)x Y:(double)y
//{
//    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(ABS(x));
//    
//    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
//    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
//    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
//    return ret;
//}
//
//+ (double)transformLonX:(double)x Y:(double)y
//{
//    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(ABS(x));
//    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
//    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
//    ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
//    return ret;
//}
//
//
@end
