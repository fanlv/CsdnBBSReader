//
//  FLAsyncImageView.m
//  Droponto
//
//  Created by Fan Lv on 14-5-6.
//  Copyright (c) 2014年 Haoqi. All rights reserved.
//

#import "FLAsyncImageView.h"
#import "FileManage.h"

#define UPDATE_USER_IMAGE_CHANGED     @"UPDATE_USER_IMAGE_CHANGED"

#define DOWNLOAD_IMAGE_SUCCESSED     @"DOWNLOAD_IMAGE_SUCCESSED"


@interface FLAsyncImageView()
{
    NSString *notificattionName;
    NSMutableData *data;
    long long mFileSize;
    int tryDownloadCount;
}
///图片本地默认保存的路径，不设置的话会保存在cache文件夹
@property (nonatomic, strong) NSString *localPath;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation FLAsyncImageView

static NSMutableDictionary *imageCacheDic;
static NSMutableArray *downingImageUrls;


@synthesize imageUrl,isCacheImage,isSaveToCacheFolder;


- (UIActivityIndicatorView *)spinner
{
    if (_spinner == nil)
    {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _spinner.hidesWhenStopped = YES;
        _spinner.frame = CGRectMake((self.frame.size.width - 30)/2, (self.frame.size.height - 30)/2, 30, 30);
        [self addSubview:_spinner];
    }
    return _spinner;
}

- (NSString *)localPath
{
    if (_localPath == nil)
    {
        NSString *imageCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *fileName = [imageUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"_"];
        fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
        fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        _localPath = [imageCachePath stringByAppendingPathComponent:fileName];
    }
    return _localPath;
}

- (id)init
{
	if (self = [super init])
    {
		[self setup];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
    {
		[self setup];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
    {
		[self setup];
	}
	return self;
}

- (void)setDefaultImage:(UIImage *)defaultImage
{
    _defaultImage = defaultImage;
}

-(void)setIsCircleShape:(BOOL)isCircleShape
{
    _isCircleShape = isCircleShape;
    self.clipsToBounds = isCircleShape;
    if (isCircleShape)
    {
        self.clipsToBounds = isCircleShape;
        self.layer.cornerRadius = self.frame.size.width/2.0;
    }
}

- (void)setIsShowSpinnerWhenDownLoad:(BOOL)isShowSpinnerWhenDownLoad
{
    _isShowSpinnerWhenDownLoad = isShowSpinnerWhenDownLoad;
    if (isShowSpinnerWhenDownLoad)
    {
        [self addSubview:self.spinner];
    }
    else
    {
        [self.spinner removeFromSuperview];
    }
}

- (void)setup
{
    self.spinner.tag = 0;
    self.isShowSpinnerWhenDownLoad = YES;
    self.isSaveToCacheFolder = NO;
    notificattionName = nil;
    if (imageCacheDic == nil)
    {
        imageCacheDic = [[NSMutableDictionary alloc] init];
    }
    if (downingImageUrls == nil)
    {
        downingImageUrls = [[NSMutableArray alloc] init];
    }
    tryDownloadCount = 0;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateImge:)
                                                 name:DOWNLOAD_IMAGE_SUCCESSED object:nil];
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (self.isCircleShape)
    {
        self.clipsToBounds = self.isCircleShape;
        self.layer.cornerRadius = self.frame.size.width/2.0;
    }
    self.spinner.frame = CGRectMake((self.frame.size.width - 30)/2, (self.frame.size.height - 30)/2, 30, 30);
    
}


- (void)setSyncImgaeTag:(int)syncImgaeTag
{
    _syncImgaeTag = syncImgaeTag;
    if (notificattionName) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:notificattionName object:nil];
    }
    notificattionName = [NSString stringWithFormat:@"%@%d",UPDATE_USER_IMAGE_CHANGED,syncImgaeTag];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userProfileImageChange:)
                                                 name:notificattionName object:nil];
}

- (void)initView
{
    _localPath = nil;
    imageUrl = nil;
}


- (void)setImageUrl:(NSString *)url
{
    [self initView];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (url== nil || [url isKindOfClass:[NSNull class]] ||[url length] == 0)
        {
            imageUrl = nil;
            self.image = _defaultImage;
            if (self.delegate && [self.delegate respondsToSelector:@selector(downloadProgress:)])
            {
                [self.delegate downloadProgress:100];
            }
        }
        else
        {
            imageUrl = url;
            [self downloadImage];
        }
    });
}



- (void)downloadImage
{
    @try
    {
        @synchronized(imageCacheDic)
        {
            id imageCache = [imageCacheDic objectForKey:imageUrl];
            if (imageCache)//如果有缓存的话直接缓存读取。
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = imageCache;
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadProgress:)])
                    {
                        [self.delegate downloadProgress:100];
                    }
                });
                
            }
            else
            {
                self.image = _defaultImage;
                [self.spinner startAnimating];
                if ([FileManage isExist:self.localPath])
                {
                    [self downLaodSucceed:nil downUrl:nil];
                }
                else
                {
                    [self downLoadWithUrl:imageUrl];
                }
            }
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"imageCacheDic exception : %@",exception);
    }
    
    
    
    
    
    
}

- (void)downLaodSucceed:(NSData *)imageData downUrl:(NSString *)url
{
    dispatch_queue_t queue=dispatch_queue_create("downLaodSucceed", NULL);

    dispatch_async(queue, ^{
        UIImage *image;
        //有时候会有几个线程同时下载同一张图片保存的时候需要判断下
        if (imageData)
        {
            image = [UIImage imageWithData:imageData];
            if (isSaveToCacheFolder)
            {
                [imageData writeToFile:self.localPath atomically:YES];
            }
        }
        else
        {
            image = [UIImage imageWithContentsOfFile:self.localPath];
        }
        
        //---------如果需要缓存则缓存改图片下次会直接获取。
        if (isCacheImage)
        {
            @try {
                @synchronized(imageCacheDic)
                {
                    if (image && url)
                    {
                        [imageCacheDic setObject:image forKey:url];
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"imageCacheDic exception : %@",exception);
            }
            
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(downloadProgress:)])
            {
                [self.delegate downloadProgress:100];
            }
            [self.spinner removeFromSuperview];
            self.spinner = nil;

            if (notificattionName)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:notificattionName object:image];
            }
            else
            {
                if (image)
                {
                    self.image = image;
                }
                else
                {
                    UIImage *img = [UIImage imageWithData:imageData];
                    NSLog(@"IMAGE IS niL,%@  , %@",url,img);
                }
                if ([imageUrl length] >0 && image)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOAD_IMAGE_SUCCESSED object:@[imageUrl,image]];
                }

            }
        });
    });
    
}


- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    if (notificattionName && image && (image != _defaultImage))
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificattionName object:image];
    }
}


- (void)updateCache:(UIImage *)image
{
    if ([imageUrl length]> 0 && image)
    {
        @try {
            @synchronized(imageCacheDic)
            {
                if (image)
                {
                    [imageCacheDic setObject:image forKey:imageUrl];
                    if(isSaveToCacheFolder)
                    {
                        NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(image,1)];
                        [imageData writeToFile:self.localPath atomically:YES];
                    }
                }
               
                    
            }
        }
        @catch (NSException *exception) {
            NSLog(@"imageCacheDic setImage:(UIImage *)image : %@",exception);
        }
    }
}

#pragma mark - NSNotification

- (void)upDateImge:(NSNotification *)note
{
    NSArray *array  = note.object;
    NSString *url = [array objectAtIndex:0];
    UIImage *img = [array objectAtIndex:1];
    
    
 
    
    if ([url isEqualToString:imageUrl] && self.image != img)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner removeFromSuperview];
            self.spinner = nil;
            self.image =img;
        });
    }

}

- (void)userProfileImageChange:(NSNotification *)note
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.spinner removeFromSuperview];
        self.spinner = nil;

        if (self.image != note.object)
        {
            self.image = note.object;
        }
        
        //---------如果需要缓存则缓存改图片下次会直接获取。
        if (isCacheImage && self.image != _defaultImage)
        {
            @try {
                @synchronized(imageCacheDic)
                {
                    if (self.image && imageUrl)
                    {
                        [imageCacheDic setObject:self.image forKey:imageUrl];
                        if (isSaveToCacheFolder)
                        {
                            NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(self.image,1)];
                            [imageData writeToFile:self.localPath atomically:YES];
                        }
                    }
               
                }
            }
            @catch (NSException *exception) {
                NSLog(@"imageCacheDic : %@",exception);
            }
        }
    });
    
}



#pragma mark - Action

- (void)updateLocalImage
{
    UIImage *img = [UIImage imageWithContentsOfFile:self.localPath];
    if(notificattionName && img)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificattionName object:img];
    }
}


- (void)clearCache
{
    if ([FileManage isExist:self.localPath])
    {
        [FileManage removeItem:self.localPath];
    }
    self.image = _defaultImage;
    [self.spinner removeFromSuperview];
    self.spinner = nil;

    @try {
        @synchronized(imageCacheDic)
        {
            if ([imageUrl length]>0)
            {
                [imageCacheDic removeObjectForKey:imageUrl];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"imageCacheDic : %@",exception);
    }
    
    
}

- (void)clearCacheOnly
{
    @try {
        @synchronized(imageCacheDic)
        {
            if ([imageUrl length]>0)
            {
                [imageCacheDic removeObjectForKey:imageUrl];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"imageCacheDic : %@",exception);
    }
}


-(void)downLoadWithUrl:(NSString *)url
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadProgress:)])
    {
        [self.delegate downloadProgress:0];
    }
    if (![downingImageUrls containsObject:url])
    {
        
        NSURL *netUrl = [[NSURL alloc] initWithString:url];
        NSURLRequest* request = [NSURLRequest requestWithURL:netUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (conn)
        {
            @try {
                @synchronized(downingImageUrls)
                {
                    [downingImageUrls addObject:url];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"downingImageUrl : %@",exception);
            }
            [conn start];//开始连接网络
        }
    }
    else
    {
//        if (tryDownloadCount >=3)
//        {
//            NSLog(@"tryDownloadCount >=3 ");
//            return;
//        }
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            sleep(5);
//            self.imageUrl = url;
//        });
//        tryDownloadCount++;
//        NSLog(@"已经开始下载，%@",url);
    }

}



#pragma mark - NSURLConnectionDataDelegate methods
//连接成功,当链接收到回复时调用该方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    data = [[NSMutableData alloc] init];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    //对于http请求,成功的返回码为200
    if (httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)] &&httpResponse.statusCode ==200)
    {
        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
        mFileSize = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];
    }
    else
    {
        NSURLRequest* request = [connection currentRequest];
        @try {
            @synchronized(downingImageUrls)
            {
                [downingImageUrls removeObject:[request.URL absoluteString]];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"downingImageUrl : %@",exception);
        }
        NSLog(@"下载失败，%@",[request.URL absoluteString]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner removeFromSuperview];
            self.spinner = nil;

            if (_defaultImage)
            {
                self.image  = _defaultImage;
            }
        });
        
    }
}
//接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)incrementalData
{
    [data appendData:incrementalData];
    float progress =  [data length]*1.0/mFileSize;
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadProgress:)])
    {
        [self.delegate downloadProgress:(progress * 100)];
    }

}
//数据接收完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSURLRequest* request = [connection currentRequest];
    
    @try {
        @synchronized(downingImageUrls)
        {
            [downingImageUrls removeObject:[request.URL absoluteString]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"downingImageUrl : %@",exception);
    }

    [self downLaodSucceed:data downUrl:[request.URL absoluteString]];
}


#pragma mark - NSURLConnectionDelegate methods
//连接失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.spinner removeFromSuperview];
        self.spinner = nil;

        if (_defaultImage)
        {
            self.image  = _defaultImage;
        }
    });
    NSURLRequest* request = [connection currentRequest];

    @try {
        @synchronized(downingImageUrls)
        {
            [downingImageUrls removeObject:[request.URL absoluteString]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"downingImageUrl : %@",exception);
    }
    NSLog(@"下载失败2，%@",[request.URL absoluteString]);

}



#pragma mark - touches Views

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.alpha = 0.8;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location=[[touches anyObject] locationInView:self];
    if (location.x >0 && location.x <self.bounds.size.width && location.y >0 && location.y <self.bounds.size.height
        && self.delegate && [self.delegate respondsToSelector:@selector(viewTouchesEnded:)])
    {
        [self.delegate viewTouchesEnded:self];
    }
    self.alpha = 1.0;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint location=[[touches anyObject] locationInView:self];
    if (location.x >0 && location.x <self.bounds.size.width && location.y >0 && location.y <self.bounds.size.height
        && self.delegate && [self.delegate respondsToSelector:@selector(viewTouchesEnded:)])
    {
        [self.delegate viewTouchesEnded:self];
    }
    self.alpha = 1.0;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notificattionName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DOWNLOAD_IMAGE_SUCCESSED object:nil];
}


@end
