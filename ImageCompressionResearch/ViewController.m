//
//  ViewController.m
//  ImageCompressionResearch
//
//  Created by apple on 2019/3/11.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *originImageView;
@property (weak, nonatomic) IBOutlet UIImageView *dealImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"test.png"];
    NSLog(@"%@", filePath);
    // UIImagePNGRepresentation:获取原图的大小
    // UIImageJPEGRepresentation(originImageData, 1.0); //得到的并不是原图的大小
    
        
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
            
        
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"5" ofType:@"jpeg"];
    UIImage *originImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
        
//        UIImage *originImage = [UIImage imageNamed:@"5.jpeg"];
    NSData *originImageData = UIImageJPEGRepresentation(originImage, 1);
    NSLog(@"原图大小:%@", [self formatSizeWithSize:originImageData.length]);
    NSLog(@"原图Size:%@", NSStringFromCGSize(originImage.size));

        dispatch_async(dispatch_get_main_queue(), ^{
            self.originImageView.image = originImage;
        });
    

    NSLog(@"---------------------------------------");
    
    
//    UIImage *newImage = [self scaleImage:originImage toScale:0.5];
//    NSData *newImageData = UIImagePNGRepresentation(newImage);
//    NSLog(@"处理后的图片大小:%@", [self formatSizeWithSize:newImageData.length]);
//    NSLog(@"处理后的图片Size:%@", NSStringFromCGSize(newImage.size));
    
//    UIImage *newImage = [self reSizeImage:originImage toSize:CGSizeMake(50, 100)];
//    NSData *newImageData = UIImagePNGRepresentation(newImage);
//    NSLog(@"处理后的图片大小:%@", [self formatSizeWithSize:newImageData.length]);
//    NSLog(@"处理后的图片Size:%@", NSStringFromCGSize(newImage.size));
//    self.dealImageView.image = newImage;
    
    
//    UIImage *newImage = [self compressImageSize:originImage toByte:1024*1024];
//    NSData *newImageData = UIImagePNGRepresentation(newImage);
//    NSLog(@"处理后的图片大小:%@", [self formatSizeWithSize:newImageData.length]); // 2.49M
//    NSLog(@"处理后的图片Size:%@", NSStringFromCGSize(newImage.size)); // 1301x863
//    self.dealImageView.image = newImage;
    
//    NSData *newData = [self compressOriginalImage:originImage toMaxDataSizeKBytes:1024 * 64];
//    UIImage *newImage = [UIImage imageWithData:newData];
//    NSLog(@"处理后的图片大小:%@", [self formatSizeWithSize:newData.length]); //
//    NSLog(@"处理后的图片Size:%@", NSStringFromCGSize(newImage.size)); //
//    self.dealImageView.image = newImage;
//
//
//    [newData writeToFile:filePath atomically:YES];
    
    
//    NSData *newData = [self compressWithOriginalImage:originImage maxLength:1024 * 64];
//    UIImage *newImage = [UIImage imageWithData:newData];
//    NSLog(@"处理后的图片大小:%@", [self formatSizeWithSize:newData.length]); //
//    NSLog(@"处理后的图片Size:%@", NSStringFromCGSize(newImage.size)); //
//    self.dealImageView.image = newImage;
//    [newData writeToFile:filePath atomically:YES];
    
    
    
    
//    NSData *newData = [self myCompressWithData:originImageData];
//    UIImage *newImage = [UIImage imageWithData:newData];
//    NSLog(@"处理后的图片大小:%@", [self formatSizeWithSize:newData.length]); //
//    NSLog(@"处理后的图片Size:%@", NSStringFromCGSize(newImage.size)); //
//    self.dealImageView.image = newImage;
//    [newData writeToFile:filePath atomically:YES];
    
    
    
    
    NSData *newData = [self reSizeImageData:originImage maxImageSize:375 maxSizeWithKB:64];
        UIImage *newImage = [[UIImage alloc] initWithData:newData];
    NSLog(@"处理后的图片大小:%@", [self formatSizeWithSize:newData.length]); //
    NSLog(@"处理后的图片Size:%@", NSStringFromCGSize(newImage.size)); //
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dealImageView.image = newImage;
        });
    
    [newData writeToFile:filePath atomically:YES];
        
    });
}



- (NSString *)formatSizeWithSize:(float)size{
    NSString *formatString = @"0.00B";
    if (size > 1024 * 1024) {
        formatString = [NSString stringWithFormat:@"%.2fM",size / 1024.00f /1024.00f];
    } else if (size > 1000) {
        formatString = [NSString stringWithFormat:@"%.2fKB",size / 1024.00f ];
    } else {
        formatString = [NSString stringWithFormat:@"%.2fB",size / 1.00f];
    }
    return formatString;
}

// 使用压缩比例
// 主要是通过 drawInRect方法重新绘制图片
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    CGFloat imageW = image.size.width * scaleSize;
    CGFloat imageH = image.size.height * scaleSize;
    UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
    [image drawInRect:CGRectMake(0, 0, imageW, imageH)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

// 给定尺寸的压缩
// 这种适合，需求就是要固定的尺寸，这种做法可以做到一步到位，小图拉伸，大图缩小。
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize {
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

// 给定图片质量大小进行压缩
- (UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength {
    UIImage *resultImage = image;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    return resultImage;
}

// 压缩质量  指定大小压缩
- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length <= size) {
        return data;
    }
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < size) {
            min = compression;
        } else if (data.length > size * 0.9) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}

// 压缩图片和压缩尺寸结合
- (NSData *)compressWithOriginalImage:(UIImage *)image maxLength:(NSUInteger)maxLength{
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length <= maxLength) {
        return data;
    }
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        
        UIImage *resultImage = [UIImage imageWithData:data];
        CGFloat ratio = (CGFloat)maxLength / data.length;
        NSLog(@"ratio:%f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)), (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        data = UIImageJPEGRepresentation(resultImage, 1);
        compression = (max + min) / 2;
        
        if (data.length <= maxLength) {
            return data;
        }
        if (data.length < maxLength) {
            min = compression;
        } else if (data.length > maxLength * 0.9) {
            max = compression;
        } else {
            break;
        }
        
        data = UIImageJPEGRepresentation(resultImage, compression);
        if (data.length <= maxLength) {
            return data;
        }
    }
    return data;
}


- (NSData *)myCompressWithData:(NSData *)originData{
    NSData *tpData = originData;
    NSInteger dxLengh = [tpData length]/1024;
    NSInteger num = 0;
    
    while (dxLengh >= 32) {
        if (num > 30) {
            break;
        }
        UIImage *tpImg = [UIImage imageWithData:tpData];
        CGSize tpSize = tpImg.size;
        UIImage *newImg = [self scaleToSize:tpImg size:CGSizeMake(tpSize.width*0.8, tpSize.height*0.8)];
        tpData = UIImageJPEGRepresentation(newImg, 1);
        dxLengh = [tpData length]/1024;
        num = num + 1;
    }
    return tpData;
}

- (UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size {
    // 创建一个基于位图的上下文（context）,并将其设置为当前上下文(context)
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 保存图片
    // UIImageWriteToSavedPhotosAlbum(scaledImage, nil, nil, nil);
    return scaledImage;
}







- (NSData *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize
{
    
    NSData *imageData = nil;
    
    
    
    if (maxSize <= 0.0) maxSize = 1024.0;
    if (maxImageSize <= 0.0) maxImageSize = 1024.0;
    
    //先调整分辨率
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    //比例压缩
    CGFloat tempHeight = newSize.height / maxImageSize;
    CGFloat tempWidth = newSize.width / maxImageSize;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    } else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    //等比缩放
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    imageData = UIImageJPEGRepresentation(newImage,1.0);
    CGFloat sizeOriginKB = imageData.length / 1024.0;
    //压缩质量
    CGFloat resizeRate = 0.9;
    while (sizeOriginKB > maxSize && resizeRate > 0.1) {
        
        imageData = UIImageJPEGRepresentation(newImage,resizeRate);
        sizeOriginKB = imageData.length / 1024.0;
        resizeRate -= 0.1;
        
    }
    
    
    return imageData;
}

@end
