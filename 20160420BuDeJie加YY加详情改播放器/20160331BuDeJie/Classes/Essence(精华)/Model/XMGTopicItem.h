//
//  XMGTopicItem.h
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/12.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef enum {
//    XMGTopicTypeAll = 1,
//} XMGTopicType;

typedef NS_ENUM(NSUInteger, XMGTopicType) {
    XMGTopicTypeAll = 1,
    XMGTopicTypePicture = 10,
    XMGTopicTypeVideo = 41,
    XMGTopicTypeVoice = 31,
    XMGTopicTypeWord = 29,
};

@interface XMGTopicItem : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *passtime;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *profile_image;

//@property (nonatomic, assign) NSInteger ding;
//@property (nonatomic, assign) NSInteger cai;
//@property (nonatomic, assign) NSInteger repost;
//@property (nonatomic, assign) NSInteger comment;

@property (nonatomic, strong) NSString *ding;
@property (nonatomic, strong) NSString *cai;
@property (nonatomic, strong) NSString *repost;
@property (nonatomic, strong) NSString *comment;


@property (nonatomic, assign) NSUInteger type;
@property (nonatomic, strong) NSArray *top_cmt;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSString *image0;
@property (nonatomic, strong) NSString *image1;
@property (nonatomic, strong) NSString *image2;

@property (nonatomic, assign) NSInteger playcount;
@property (nonatomic, assign) NSInteger voicetime;
@property (nonatomic, assign) NSInteger videotime;

@property (nonatomic, assign) BOOL is_gif;
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;

@property (nonatomic, strong) NSString *videouri;

@property (nonatomic, strong) NSString *ID;

/** 分享网页 */
@property (nonatomic, strong) NSString *weixin_url;

@property (nonatomic, strong) NSString *voiceuri;

// 非网络数据
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGRect middleFrame;

@end
