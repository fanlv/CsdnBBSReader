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
    //    NSMutableData *data;
    long long mFileSize;
    int tryDownloadCount;
}
///图片本地默认保存的路径，不设置的话会保存在cache文件夹
@property (nonatomic, readonly) NSString *localPath;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation FLAsyncImageView

static NSMutableDictionary *imageCacheDic;
//static NSMutableArray *downingImageUrls;
static NSMutableDictionary *imageDataDic;


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
    //    if (_localPath == nil)
    //    {
    //        NSString *imageCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //        NSString *fileName = [imageUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"_"];
    //        fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    //        fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    //        _localPath = [imageCachePath stringByAppendingPathComponent:fileName];
    //    }
    return [self urlToLocalPath:imageUrl];
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
        self.spinner = nil;
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
    if (imageDataDic == nil)
    {
        imageDataDic = [[NSMutableDictionary alloc] init];
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




- (void)setImageUrl:(NSString *)url
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        imageUrl = nil;
        [self.spinner stopAnimating];
        
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


- (NSString *)urlToLocalPath:(NSString *)url
{
    NSString *imageCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [url stringByReplacingOccurrencesOfString:@"\\" withString:@"_"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    fileName = [imageCachePath stringByAppendingPathComponent:fileName];
    return fileName;
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
            [self.spinner stopAnimating];
            self.image =img;
        });
    }
    
}

- (void)userProfileImageChange:(NSNotification *)note
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.spinner stopAnimating];
        
        if (self.image != note.object)
        {
            self.image = note.object;
        }
        
        //---------如果需要缓存则缓存改图片下次会直接获取。
        if (isCacheImage && self.image != _defaultImage && self.image && imageUrl)
        {
            @try {
                @synchronized(imageCacheDic)
                {
                    [imageCacheDic setObject:self.image forKey:imageUrl];
                    //                    if (isSaveToCacheFolder)
                    //                    {
                    //                        NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(self.image,1)];
                    //                        [imageData writeToFile:self.localPath atomically:YES];
                    //                    }
                    
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
    [self.spinner stopAnimating];
    
    
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

#pragma mark - downloadImage


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
                    UIImage *image = [UIImage imageWithContentsOfFile:self.localPath];
                    [self downLaodSucceed:image downUrl:imageUrl];
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


-(void)downLoadWithUrl:(NSString *)url
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadProgress:)])
    {
        [self.delegate downloadProgress:0];
    }
    if (![[imageDataDic allKeys] containsObject:url])
    {
        NSURL *netUrl = [[NSURL alloc] initWithString:url];
        NSURLRequest* request = [NSURLRequest requestWithURL:netUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (conn)
        {
            //            @try {
            //                @synchronized(downingImageUrls)
            //                {
            //                    [downingImageUrls addObject:url];
            //                }
            //            }
            //            @catch (NSException *exception) {
            //                NSLog(@"downingImageUrl : %@",exception);
            //            }
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

- (void)downLaodSucceed:(UIImage *)image downUrl:(NSString *)url
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(downloadProgress:)])
        {
            [self.delegate downloadProgress:100];
        }
        [self.spinner stopAnimating];
        
        
        if (notificattionName)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:notificattionName object:image];
        }
        else
        {
            //下载完成以后显示的时候需要判断下当前设置的imageUrl是否与下载完成的url相等。
            if (image && [imageUrl isEqualToString:url])
            {
                self.image = image;
                NSLog(@"imageUrl %@:",imageUrl);
                
            }
            else
            {
                NSLog(@"1url %@:",url);
                NSLog(@"2Url %@:",imageUrl);
                id imageCache = [imageCacheDic objectForKey:imageUrl];
                if (imageCache)//如果有缓存的话直接缓存读取。
                {
                    NSLog(@"imageCache not nil");
                    self.image = imageCache;
                }
                else
                {
                    NSLog(@"nil");
                    self.image = _defaultImage;
                }
            }
            if ([imageUrl length] >0 && image)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOAD_IMAGE_SUCCESSED object:@[imageUrl,image]];
            }
            
        }
    });
    
}



#pragma mark - NSURLConnectionDataDelegate methods
//连接成功,当链接收到回复时调用该方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSURLRequest* request = [connection currentRequest];
    
    @try {
        @synchronized(imageDataDic)
        {
            [imageDataDic setObject:data forKey:[request.URL absoluteString]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"imageDataDic set %@",exception);
    }
    
    //对于http请求,成功的返回码为200
    if (httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)] &&httpResponse.statusCode ==200)
    {
        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
        mFileSize = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];
    }
    else
    {
        @try {
            //            @synchronized(downingImageUrls)
            //            {
            //                [downingImageUrls removeObject:[request.URL absoluteString]];
            //            }
            @synchronized(imageDataDic)
            {
                [imageDataDic removeObjectForKey:[request.URL absoluteString]];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"downingImageUrl : %@",exception);
        }
        NSLog(@"下载失败，%@",[request.URL absoluteString]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            if (_defaultImage)self.image  = _defaultImage;
        });
        
    }
}
//接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)incrementalData
{
    NSURLRequest* request = [connection currentRequest];
    NSMutableData *data = [imageDataDic objectForKey:[request.URL absoluteString]];
    
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
    NSMutableData *data = [imageDataDic objectForKey:[request.URL absoluteString]];
    
    dispatch_queue_t queue=dispatch_queue_create("downLaodSucceed", NULL);
    dispatch_async(queue, ^{
        UIImage *image = [UIImage imageWithData:data];;
        if (data && isSaveToCacheFolder)
        {
            NSString *filePath = [self urlToLocalPath:[request.URL absoluteString]];
            [data writeToFile:filePath atomically:YES];
        }
        //---------如果需要缓存则缓存改图片下次会直接获取。
        if (isCacheImage)
        {
            @try {
                @synchronized(imageCacheDic)
                {
                    if (image && [request.URL absoluteString])
                    {
                        [imageCacheDic setObject:image forKey:[request.URL absoluteString]];
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"imageCacheDic exception : %@",exception);
            }
        }
        
        NSLog(@"downLaodSucceed:image downUrl : %@",[request.URL absoluteString]);
        
        [self downLaodSucceed:image downUrl:[request.URL absoluteString]];
        
    });
    
    
    
    @try {
        //        @synchronized(downingImageUrls)
        //        {
        //            [downingImageUrls removeObject:[request.URL absoluteString]];
        //        }
        @synchronized(imageDataDic)
        {
            [imageDataDic removeObjectForKey:[request.URL absoluteString]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"downingImageUrl : %@",exception);
    }
    
    
    
}


#pragma mark  NSURLConnectionDelegate methods
//连接失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.spinner stopAnimating];
        
        
        if (_defaultImage)
        {
            self.image  = _defaultImage;
        }
    });
    NSURLRequest* request = [connection currentRequest];
    
    @try {
        //        @synchronized(downingImageUrls)
        //        {
        //            [downingImageUrls removeObject:[request.URL absoluteString]];
        //        }
        @synchronized(imageDataDic)
        {
            [imageDataDic removeObjectForKey:[request.URL absoluteString]];
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
    imageUrl = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notificattionName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DOWNLOAD_IMAGE_SUCCESSED object:nil];
}




#pragma mark - Help Class
//判断文件/文件夹是否存在
- (BOOL)isExist:(NSString*)path
{
    BOOL ret=NO;
    BOOL isdir=NO;
    ret = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isdir];
    // NSLog(@"file or dir is exist=%d isdir=%d path=%@",ret,isdir,path);
    return ret;
}


//删除文件/文件夹
- (BOOL)removeItem:(NSString*)path
{
    BOOL ret=NO;
    if(path!=nil){
        ret = [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    return ret;
}



@end
