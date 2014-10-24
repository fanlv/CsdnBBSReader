//
//  FileManage.m
//  GuideApp
//
//  Created by fan on 13-5-9.
//
//

#import "FileManage.h"


@implementation FileManage

+(NSString*)getDataBasePath
{
    NSString *path = [NSString stringWithFormat:@"%@/%@.db",[self getDocPath],DB_NAME];
    return path;
}


//获取应用的docment目录
+(NSString*)getDocPath
{
	NSString* mDocPath=nil;
    mDocPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return mDocPath;
}

//获取用户发送的图片保存的目录
+(NSString*)getImagePath
{
    NSString *path = [NSString stringWithFormat:@"%@/image",[FileManage getDocPath]];
    if (![self isExist:path]) {
        [FileManage createDir:path];
    }
    return path;
}

+(NSString*)getCacheImagePath
{
    NSString *imageCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return imageCachePath;
}



//创建文件夹,可以递归创建
+(BOOL)createDir:(NSString*)path
{
    BOOL ret=NO;
	if(path!=nil){
        
        if([self isExist:path])
            return YES;
        
    	ret = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(!ret)
        NSLog(@"create dir fail,path=%@",path);
    return ret;
}

//创建文件,指定的文件夹必须存在，否则创建失败.fileName为绝对路径
+(BOOL)createFile:(NSString*)fileName
{
	BOOL ret=NO;
    if(fileName!=nil){
        if([self isExist:fileName])
            return YES;
    	ret = [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
    }
    if(!ret)
        NSLog(@"create file fail,filenme=%@",fileName);
    return ret;
}

//检索指定文件夹下的文件，可指定是否递归检索
+(NSArray*)enumPath:(NSString*)path isRecursion:(BOOL)isRecursion
{
	if(path!=nil){
        if(isRecursion)
    		return [[NSFileManager defaultManager] subpathsAtPath:path];
        else
            return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    }else {
        return nil;
    }
}

//判断文件/文件夹是否存在
+(BOOL)isExist:(NSString*)path
{
	BOOL ret=NO;
    BOOL isdir=NO;
    ret = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isdir];
    // NSLog(@"file or dir is exist=%d isdir=%d path=%@",ret,isdir,path);
    return ret;
}

//删除文件/文件夹
+(BOOL)removeItem:(NSString*)path
{
	BOOL ret=NO;
    if(path!=nil){
    	ret = [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    return ret;
}

//获取文件/文件夹属性
+(NSDictionary*)getAttributes:(NSString*)path
{
	if(path!=nil){
        return [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    }else {
        return nil;
    }
}

//重命名、移动文件/文件夹
+(BOOL)rename:(NSString*)srcPath toPath:(NSString*)dstPath
{
	BOOL ret=NO;
    if(srcPath==nil || dstPath==nil)
        return ret;
    
    ret = [[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:dstPath error:nil];
    if (!ret) {
        ret = [FileManage copyItem:srcPath toPath:dstPath];
        [FileManage removeItem:srcPath];
    }
    return ret;
}

//复制文件/文件夹
+(BOOL)copyItem:(NSString*)srcPath toPath:(NSString*)dstPath
{
	BOOL ret = NO;
    if(srcPath==nil || dstPath==nil)
        return ret;
    NSError* err=nil;
    ret = [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:dstPath error:&err];
    if(err){
    	NSLog(@"%@",err.userInfo);
    }
    
    return ret;
}

//获取整个文件夹的大小
+(unsigned long long)getDirSize:(NSString*)path
{
	NSDirectoryEnumerator *files=nil;
    unsigned long long size=0;

    NSFileManager* defaultmgr=[NSFileManager defaultManager];
    
    if(path==nil)
        return 0;
    
    files = [defaultmgr enumeratorAtPath:path];
    for (NSString* file in files) {
        NSString* filepath=[NSString stringWithFormat:@"%@/%@",path,file];
        NSDictionary *attr = [defaultmgr attributesOfItemAtPath:filepath error:nil];
        size+=attr.fileSize;
    }
        
	return size;
}


//获取文件的大小
+(unsigned long long)getFileSize:(NSString*)file
{
    if(file==nil)
        return 0;
    
    return[[NSFileManager defaultManager] attributesOfItemAtPath:file error:nil].fileSize;
    
}

//文件追加UTF8编码字符
+(BOOL)appendUTF8:(NSString*)path str:(NSString*)str
{
    //the code on the up does work when to write something to a file by append
    if (![FileManage isExist:path]) {
        return NO;
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    long long seek=0;
    seek = [fileHandle seekToEndOfFile];
    [fileHandle writeData:data];
    NSLog(@"bytepath=%@",path);
    
    return YES;
}


+(NSArray*)enumPath:(NSString*)vagueFileName fileDir:(NSString*)fileDir
{
	NSArray* array=[self enumPath:fileDir isRecursion:NO];
    NSMutableArray* arr=[[NSMutableArray alloc] init];
    if(array && array.count>0){
    	for (NSString* file in array) {
            NSRange range={0};
            range = [file rangeOfString:vagueFileName];
            if(range.length>0)
                [arr addObject:file];
        }
    }else {
        return nil;
    }
    
    if(arr.count>0)
	    return arr;
	else 
    	return nil;
    
}



//将根目录下面的图片移到其他的文件夹中
+(NSArray*)getRootDocumentsFile{
    NSArray *imgTypeArray = [NSArray arrayWithObjects:@"jpg",@"png",@"bmp", nil];
    
    NSMutableArray *fileArray = [NSMutableArray array];
    NSString *fullpath = [FileManage getDocPath];
    NSArray *allFile = [FileManage enumPath:fullpath isRecursion:NO];
    
    for (int i=0; i<[allFile count]; ++i) {
        //获取文件的名字
        NSString *fileName = [allFile objectAtIndex:i];
        //将文件名字拼接成文件所在目录，后面图片显示时是根据目录来读取的
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",fullpath,fileName];
        //获取文件的属性
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        //获取文件的类型，主要判断是文件夹还是文件
        NSString *fileType = [fileAttributes objectForKey: NSFileType];
                
        //查找当前目录下的所有图片（不包含文件夹内部的图片）
        if ([fileType isEqualToString:NSFileTypeRegular]){
            //判断文件的后缀，过滤掉不是图片的文件
            NSString *str1 = [[fileName pathExtension] lowercaseString];
            
            //[str1 lowercaseString];
            if (str1!=nil && [str1 length]!=0 && [imgTypeArray containsObject:str1]) {
//                NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:fullpath,fileName, [FileManage getThumbnailPath],nil] forKeys:[NSArray arrayWithObjects:@"fullpath",@"name",@"thumbpath", nil]];
                [fileArray addObject:fileName];
            }
        }
    }
    return fileArray;
}

//获取保存后图片的名字，如果存在同名的文件，则命名规则为name_1.jpng，1的值递增
+(NSString*)fileRename:(NSString*)toPath :(NSString*)fileName{
    NSString *name = fileName;
    NSString *ntoPath = [NSString stringWithFormat:@"%@/%@",toPath,fileName];

    if ([FileManage isExist:ntoPath]) {
        NSString *fileNameNoExt = [fileName stringByDeletingPathExtension];
        NSArray *array = [fileNameNoExt componentsSeparatedByString:@"_"];
        NSString *name = [array objectAtIndex:0];
        int i=0;
        @try {
            i = [[array objectAtIndex:1] intValue];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        NSString *fileExt = [fileName pathExtension];
        NSString *aname;
        if (fileExt==nil || [fileExt length]==0) {
            aname = [NSString stringWithFormat:@"%@_%d",name,++i];
        }else{
            aname = [NSString stringWithFormat:@"%@_%d.%@",name,++i,fileExt];
        }
        
        name = [FileManage fileRename:toPath :aname];
        return name;
    }
    return name;
}

//获取某一目录下的文件或文件夹，directoryOrFile：yes为获取文件夹，NO为获取文件
+(NSArray*)getDocumentFile:(NSString*)pathStr directory:(BOOL)directoryOrFile{
    NSArray *imgTypeArray = [NSArray arrayWithObjects:@"jpg",@"png",@"bmp", nil];
    
    NSMutableArray *fileArray = [NSMutableArray array];
    
    if (pathStr==nil) {
        pathStr = [FileManage getDocPath];
    }
    
    //如果查找的是文件夹，则添加进一个当前目录的数据
    if (directoryOrFile) {
        NSString *directoryImgPath= [[NSBundle mainBundle] pathForResource:@"xuanze_1" ofType:@"png"];
        if (directoryImgPath==nil) {
            directoryImgPath = @"";
        }
        NSArray *valueArray = [NSArray arrayWithObjects:@"所有文件",@"0",pathStr,directoryImgPath,nil];
        NSArray *keyArray = [NSArray arrayWithObjects:@"name",@"type",@"path",@"img",nil];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
        [fileArray addObject:dict];
    }
    
    NSArray *allFile = [FileManage enumPath:pathStr isRecursion:NO];
    
    for (int i=0; i<[allFile count]; ++i) {
        //获取文件的名字
        NSString *fileName = [allFile objectAtIndex:i];
        //将文件名字拼接成文件所在目录，后面图片显示时是根据目录来读取的
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",pathStr,fileName];
        //获取文件的属性
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        //获取文件的类型，主要判断是文件夹还是文件
        NSString *fileType = [fileAttributes objectForKey: NSFileType];
        
        NSDictionary *dict = nil;
        
        //查找当前目录下的所有文件夹
        //判断是否是文件夹\文件
        if (directoryOrFile && [fileType isEqualToString:NSFileTypeDirectory]) {
            //如果是文件夹，则将type=0，然后将有用的数据放到dict中。
            //filename:在缩略图上显示文件名字
            //type:用来判断是文件夹还是图片,0是文件夹，1是图片
            //path:文件所在目录，文件重命名时需要用
            //img:图片的完整路径，预览图读取时需用
            
            NSString *directoryImgPath= [[NSBundle mainBundle] pathForResource:@"xuanze_1" ofType:@"png"];
            if (directoryImgPath==nil) {
                directoryImgPath = @"";
            }
            NSArray *valueArray = [NSArray arrayWithObjects:fileName,@"0",filePath,directoryImgPath,nil];
            NSArray *keyArray = [NSArray arrayWithObjects:@"name",@"type",@"path",@"img",nil];
            dict = [NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
        }
        //查找当前目录下的所有图片（不包含文件夹内部的图片）
        else if (!directoryOrFile && [fileType isEqualToString:NSFileTypeRegular]){
            //判断文件的后缀，过滤掉不是图片的文件
            NSString *str1 = [[fileName pathExtension] lowercaseString];
            
            //[str1 lowercaseString];
            if (str1!=nil && [str1 length]!=0 && [imgTypeArray containsObject:str1]) {
                //此处的描述见上面
                NSArray *valueArray = [NSArray arrayWithObjects:fileName,@"1",pathStr,filePath,nil];
                NSArray *keyArray = [NSArray arrayWithObjects:@"name",@"type",@"path",@"img",nil];
                
                dict = [NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
            }
        }
        //查找文件夹中的文件
        else if (!directoryOrFile && [fileType isEqualToString:NSFileTypeDirectory]){
            NSArray *dArray = [FileManage getDocumentFile:filePath directory:NO];
            if (dArray!=nil) {
                [fileArray addObjectsFromArray:dArray];
            }
        }
        
        //将所有符合条件的文件添加到数组中
        if (dict!=nil) {
            [fileArray addObject:dict];
        }
    }
    return fileArray;
}


+(BOOL)saveImgaeToImageFolder:(UIImage *)image ImageName:(NSString *)imageName
{
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@",[self getImagePath],imageName];
    return [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
}





@end
