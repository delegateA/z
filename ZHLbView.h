//
//  ZHLbView.h
//  ZHLabelView
//
//  Created by zzh_iPhone on 16/4/12.
//  Copyright © 2016年 zzh_iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZHLbView;

@protocol ZHLbViewDelegate <NSObject>

@optional
- (void)tagsViewButtonAction:(ZHLbView *)tagsView button:(UIButton *)sender;

@end


@interface ZHLbView : UIScrollView


@property (nonatomic,assign) id<ZHLbViewDelegate> tagDelegate;

#pragma mark 必须设置
@property (nonatomic,assign) NSInteger times;
#pragma mark 可不设置,不设置则用默认值
@property (nonatomic,assign) float tagSpace;//标签内部左右间距(标题距离边框2边的距离和)
@property (nonatomic,assign) float tagHeight;//所有标签高度
@property (nonatomic,assign) float tagOriginX;//第一个标签起点X坐标
@property (nonatomic,assign) float tagOriginY;//第一个标签起点Y坐标
@property (nonatomic,assign) float tagHorizontalSpace;//标签间横向间距
@property (nonatomic,assign) float tagVerticalSpace;//标签间纵向间距
@property (nonatomic,strong) UIColor *borderColor;//标签边框颜色
@property (nonatomic,assign) float borderWidth;//标签边框宽度
@property (nonatomic,assign) BOOL masksToBounds;//标签是否有圆角
@property (nonatomic,assign) float cornerRadius;//标签圆角大小
@property (nonatomic,assign) float titleSize;//标签字体大小
@property (nonatomic,strong) UIColor *titleColor;//标签字体颜色
@property (nonatomic,strong) UIImage *normalBackgroundImage;//标签默认背景颜色
@property (nonatomic,strong) UIImage *highlightedBackgroundImage;//标签高亮背景颜色
@property (nonatomic,strong) UILabel *countLabel;

/**
 *  设置标签数据和代理
 *
 *  @param tagAry   标签数组,只支持字符串数组
 *  @param delegate 代理
 */
- (void)setTagAryName:(NSArray *)tagAryName  aryCount:(NSArray *)aryCount delegate:(id)delegate;

@end


#pragma mark - 扩展方法

@interface NSString (FDDExtention)
- (CGSize)fdd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
@end
