//
//  FileManage.h
//  GuideApp
//
//  Created by fan on 13-5-9.
//
//

#import <Foundation/Foundation.h>

@interface FileManage : NSObject

#define PATH_SYMBOL @"/"


+(NSString*)getDataBasePath;

//获取应用的docment目录
+(NSString*)getDocPath;

//获取用户发送的图片保存的目录
+(NSString*)getImagePath;

//创建文件夹,可以递归创建
+(BOOL)createDir:(NSString*)path;

//创建文件,指定的文件夹必须存在，否则创建失败
+(BOOL)createFile:(NSString*)fileName;

//检索指定文件夹下的文件，可指定是否递归检索
+(NSArray*)enumPath:(NSString*)path isRecursion:(BOOL)isRecursion;

//add by loner
/**
 *模糊查找。
 *@param
 * vagueFileName: 需要查找的字段。可能为名字的一部分，或者为后缀。
 *@return
 * 如果没有找到，返回空。
 **/
+(NSArray*)enumPath:(NSString*)vagueFileName fileDir:(NSString*)fileDir;

//判断文件/文件夹是否存在
+(BOOL)isExist:(NSString*)path;

//删除文件/文件夹
+(BOOL)removeItem:(NSString*)path;

//获取文件/文件夹属性
+(NSDictionary*)getAttributes:(NSString*)path;

//重命名、移动文件/文件夹
+(BOOL)rename:(NSString*)srcPath toPath:(NSString*)dstPath;

//复制文件/文件夹
+(BOOL)copyItem:(NSString*)srcPath toPath:(NSString*)dstPath;

//获取整个文件夹的大小
+(unsigned long long)getDirSize:(NSString*)path;

//获取文件的大小
+(unsigned long long)getFileSize:(NSString*)file;

//文件追加UTF8编码字符
+(BOOL)appendUTF8:(NSString*)path str:(NSString*)str;

//获取某一目录下的文件或文件夹，directoryOrFile：yes为获取文件夹，NO为获取文件
+(NSArray*)getDocumentFile:(NSString*)pathStr directory:(BOOL)directoryOrFile;

//保存图片时，用来获取保存的名字，避免重复
+(NSString*)fileRename:(NSString*)toPath :(NSString*)fileName;

//将根目录下面的图片移到其他的文件夹中
+(NSArray*)getRootDocumentsFile;


+(BOOL)saveImgaeToImageFolder:(UIImage *)image ImageName:(NSString *)imageName;





@end
