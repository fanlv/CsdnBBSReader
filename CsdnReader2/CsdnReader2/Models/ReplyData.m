//
//  Reply.m
//  CsdnReader
//
//  Created by Fan Lv on 13-1-20.
//  Copyright (c) 2013年 Fan Lv. All rights reserved.
//

#import "ReplyData.h"
#import "GlobalData.h"



@interface ReplyData()<UIWebViewDelegate>
{
    
}

@end

@implementation ReplyData


@synthesize name,content,date,profileImageUrl,grade,nickName,closeRate,rank,topic_extra_infoContent,
            totalTechnicalpoints,imageView,isAuthor,indexR,isModerator;

@synthesize contentHeight = _contentHeight;



- (void) setRawContents:(NSString *)rawContents
{
    _rawContents = rawContents;
    
//    
//    if (_rawContents)
//    {
//        UIWebView *webView = [[UIWebView alloc] init];
//        [webView loadHTMLString:_rawContents baseURL:nil];
//        webView.delegate = self;
//    }
//   
}


- (float)contentHeight
{
    if (_webContentHeight != 0)
    {
        return _webContentHeight;
    }
    if (_contentHeight == 0)
    {
        
        CGSize size = [GlobalData getTextSizeWithText:content rect:CGSizeMake(SCREEN_WIDTH - 10, 20) font:MID_FONT2];
        _contentHeight = size.height;
        if ( topic_extra_infoContent)
        {
            CGSize size1 = [GlobalData getTextSizeWithText:topic_extra_infoContent rect:CGSizeMake(SCREEN_WIDTH - 10, 20) font:MID_FONT2];
            _contentHeight -= size1.height;
        }
        
//        NSUInteger count = 0, length = [_rawContents length];
//        NSRange range = NSMakeRange(0, length);
//        while(range.location != NSNotFound)
//        {
//            range = [_rawContents rangeOfString: @"<img" options:0 range:range];
//            if(range.location != NSNotFound)
//            {
//                range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
//                _contentHeight += 200;
//            }
//        }
//        
//        count = 0;
//        length = [_rawContents length];
//        range = NSMakeRange(0, length);
//        while(range.location != NSNotFound)
//        {
//            range = [_rawContents rangeOfString: @"<fieldset>" options:0 range:range];
//            if(range.location != NSNotFound)
//            {
//                range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
//                count++;
//                _contentHeight += 50;
//
//            }
//        }
//        
//        count = 0;
//        length = [_rawContents length];
//        range = NSMakeRange(0, length);
//        while(range.location != NSNotFound)
//        {
//            range = [_rawContents rangeOfString: @"<img src=\"http://forum.csdn.net/PointForum/ui/scripts/csdn/Plugin" options:0 range:range];
//            if(range.location != NSNotFound)
//            {
//                range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
//                count++;
//                _contentHeight -= 150;
//                
//            }
//        }
//        _contentHeight += 100;
        if (_contentHeight < 66)
        {
            _contentHeight = 66;
        }
    }
    return _contentHeight;
}



//- (void)webViewDidFinishLoad:(UIWebView *)aWebView
//{
//    CGRect frame = aWebView.frame;
//    frame.size.height = 1;
//    aWebView.frame = frame;
//    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
////    frame.size = fittingSize;
////    aWebView.frame = frame;
//    
//    self.webContentHeight = fittingSize.height;
//    
//    NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
//}



@end




















