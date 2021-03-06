//
//  XTMarkdownParser+ImageUtil.m
//  Notebook
//
//  Created by teason23 on 2019/4/28.
//  Copyright © 2019 teason23. All rights reserved.
//

#import "XTMarkdownParser+ImageUtil.h"
#import "MDThemeConfiguration.h"
#import "MdInlineModel.h"
#import "MarkdownEditor.h"

@implementation XTMarkdownParser (ImageUtil)

- (NSTextAttachment *)attachmentStandardFromImage:(UIImage *)image {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init] ;
    attachment.image             = image ;
    CGFloat tvWidMax             = APP_WIDTH - 10 - kMDEditor_FlexValue * 2 ;
    CGFloat imgWid = image.size.width ;
    CGSize resultImgSize = imgWid > tvWidMax ?
    CGSizeMake(tvWidMax, tvWidMax / imgWid * image.size.height) :
    image.size ; // 判断是否超过最大宽度, 按比例显示 .
    
    CGRect rect                  = (CGRect){CGPointZero, resultImgSize};
    attachment.bounds            = rect;
    return attachment ;
}

- (NSAttributedString *)attrbuteStringWithInlineImageModel:(MdInlineModel *)model image:(UIImage *)image {
    NSTextAttachment *attach = [self attachmentStandardFromImage:image] ;
    NSMutableAttributedString *attrAttach = [[NSAttributedString attributedStringWithAttachment:attach] mutableCopy] ;
    NSMutableDictionary *jsonObj = [[model yy_modelToJSONObject] mutableCopy] ;
    [jsonObj setValue:@(model.location) forKey:@"location"] ;
    [jsonObj setValue:@(model.length) forKey:@"length"] ;
    
    [attrAttach addAttributes:@{kKey_MDInlineImageModel:[jsonObj yy_modelToJSONString]} range:NSMakeRange(0, attrAttach.length)] ;
    return attrAttach ;
}

// do when editor launch . (insert img placeholder)
- (NSMutableAttributedString *)readArticleFirstTimeAndInsertImagePHWhenEditorDidLaunching:(NSString *)text
                                                                                 textView:(UITextView *)textView {
    NSMutableArray *imageModelList = [@[] mutableCopy] ;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text] ;
    [str beginEditing] ;
    
    NSRegularExpression *expLink = regexp(MDIL_IMAGES, NSRegularExpressionAnchorsMatchLines) ;
    NSArray *matsLink = [expLink matchesInString:text options:0 range:NSMakeRange(0, text.length)] ;
    for (NSTextCheckingResult *result in matsLink) {
        MdInlineModel *resModel = [MdInlineModel modelWithType:MarkdownInlineImage range:result.range str:[text substringWithRange:result.range]] ;
        [imageModelList addObject:resModel] ;
    }
    
    [imageModelList enumerateObjectsUsingBlock:^(MdInlineModel * _Nonnull imgModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *imgUrl = [imgModel imageUrl] ;
        
        NSInteger loc = imgModel.range.location + imgModel.range.length + idx ;
                        
        [[SDWebImageManager sharedManager].imageCache queryImageForKey:imgUrl options:0 context:nil completion:^(UIImage * _Nullable imgResult, NSData * _Nullable data, SDImageCacheType cacheType) {
            
            if (!imgResult) {
                imgResult = self.imgManager.imagePlaceHolder ;
            }
            NSAttributedString *attrAttach = [self attrbuteStringWithInlineImageModel:imgModel image:imgResult] ;
            [str insertAttributedString:attrAttach atIndex:loc] ;

        }];        
        
    }] ;
    
    [str endEditing] ;
    [self updateAttributedText:str textView:textView] ;
    
    return str ;
}

// in parse time . update image or download image.
- (NSMutableAttributedString *)updateImages:(NSString *)text
                                   textView:(UITextView *)textView {
    
    NSMutableArray *imageModelList = [@[] mutableCopy] ;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text] ;
    [str beginEditing] ;
    
    NSRegularExpression *expLink = regexp(MDIL_IMAGES, NSRegularExpressionAnchorsMatchLines) ;
    NSArray *matsLink = [expLink matchesInString:text options:0 range:NSMakeRange(0, text.length)] ;
    for (NSTextCheckingResult *result in matsLink) {
        MdInlineModel *resModel = [MdInlineModel modelWithType:MarkdownInlineImage range:result.range str:[text substringWithRange:result.range]] ;
        [imageModelList addObject:resModel] ;
    }
    
    [imageModelList enumerateObjectsUsingBlock:^(MdInlineModel * _Nonnull imgModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *imgUrl = [imgModel imageUrl] ;
        
        NSInteger loc = imgModel.range.location + imgModel.range.length ;
        
        [[SDWebImageManager sharedManager].imageCache queryImageForKey:imgUrl options:0 context:nil completion:^(UIImage * _Nullable imgResult, NSData * _Nullable data, SDImageCacheType cacheType) {
            
            
            if (!imgResult) {
                imgResult = self.imgManager.imagePlaceHolder ;
                @weakify(self)
                [self.imgManager imageWithUrlStr:imgUrl complete:^(UIImage * _Nonnull image) {
                    @strongify(self)
                    
                    NSAttributedString *attrAttach = [self attrbuteStringWithInlineImageModel:imgModel image:imgResult] ;
                    [str replaceCharactersInRange:NSMakeRange(loc, 1) withAttributedString:attrAttach] ;
                    

                    [self parseTextAndGetModelsInCurrentCursor:str.string textView:textView] ;
                }] ;
            }
            
            NSAttributedString *attrAttach = [self attrbuteStringWithInlineImageModel:imgModel image:imgResult] ;
            [str replaceCharactersInRange:NSMakeRange(loc, 1) withAttributedString:attrAttach] ;

            
        }];
        
        
    }] ;
    [str endEditing] ;
    
    return str ;
}


@end











@interface MDImageManager ()

@end

@implementation MDImageManager

- (UIImage *)imagePlaceHolder {
    return [UIImage imageWithColor:XT_MD_THEME_COLOR_KEY_A(k_md_textColor, .04) size:CGSizeMake(680, 382.5)] ;
}

- (void)imageWithUrlStr:(NSString *)urlStr
               complete:(void(^)(UIImage *image))complete {
    
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:urlStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(image) ;
            }) ;
        }
    }] ;
}

/**
 headers: {
 Authorization: `Basic ${Base64.encode(userRecordName + ':' + '123456')}`
 Content-Type:image/jpeg
 }
 */
- (void)uploadImage:(UIImage *)image
           progress:(nullable void (^)(float progress))progressValueBlock
            success:(void (^)(NSURLResponse *response, id responseObject))success
            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))fail {
    
//    NSString *url = @"https://shimo.im/octopus-api/files?uploadType=media" ;
//    NSData *data = UIImageJPEGRepresentation(image, 1) ;
//    NSString *strToEnc = STR_FORMAT(@"%@:123456",[XTIcloudUser userInCacheSyncGet].userRecordName) ;
//    NSString *code = STR_FORMAT(@"Basic %@",[strToEnc base64EncodedString]) ;
//    NSDictionary *header = @{@"Authorization" : code,
//                             @"Content-Type":@"image/jpeg"
//                             } ;
//
//    [XTRequest uploadFileWithData:data urlStr:url header:header progress:^(float flt) {
//        progressValueBlock(flt) ;
//    } success:^(NSURLResponse *response, id responseObject) {
//        success(response, responseObject) ;
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        fail(task, error) ;
//    }] ;
}

@end
