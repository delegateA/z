//
//  ZHLbView.m
//  ZHLabelView
//
//  Created by zzh_iPhone on 16/4/12.
//  Copyright © 2016年 zzh_iPhone. All rights reserved.
//

#import "ZHLbView.h"

@implementation ZHLbView
{
    NSArray *disposeAry;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = YES;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        int r = arc4random() % 255;
        int g = arc4random() % 255;
        int b = arc4random() % 255;
        _tagSpace = 9.0;
        _tagHeight = 32.0;
        _tagOriginX = 10.0;
        _tagOriginY = 40.0;
        _tagHorizontalSpace = 10.0;
        _tagVerticalSpace = 10.0;
        _borderColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        _borderWidth = 0.5f;
        _masksToBounds = YES;
        _cornerRadius = 2.0;
        _titleSize = 14;
        _titleColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];;
        _normalBackgroundImage = [self imageWithColor:[UIColor whiteColor] size:CGSizeMake(1.0, 1.0)];
        _highlightedBackgroundImage = [self imageWithColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0] size:CGSizeMake(1.0, 1.0)];
    }
    return self;
}

-(void)setTagAryName:(NSArray *)tagAryName aryCount:(NSArray *)aryCount delegate:(id)delegate{
    _tagDelegate=delegate;
    [self disposeTags:tagAryName aryCount:aryCount];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(_tagOriginX, 0, 200, 30)];
    label.text=@"事件类别统计：";
    label.textColor=_titleColor;
    label.textAlignment=NSTextAlignmentLeft;
    label.adjustsFontSizeToFitWidth=YES;
    [self addSubview:label];
    //遍历标签数组,将标签显示在界面上,并给每个标签打上tag加以区分
    for (NSArray *iTags in disposeAry) {
        NSUInteger i = [disposeAry indexOfObject:iTags];
        
        for (NSDictionary *tagDic in iTags) {
            NSUInteger j = [iTags indexOfObject:tagDic];
            
            NSString *tagTitle = tagDic[@"tagTitle"];
            float originX = [tagDic[@"originX"] floatValue];
            float viewWith = [tagDic[@"viewWith"] floatValue];
            NSString *count = tagDic[@"tagCount"];
            UIView *NCView=[[UIView alloc]initWithFrame:CGRectMake(originX, _tagOriginY+i*(_tagHeight+_tagVerticalSpace), viewWith, _tagHeight)];
            [self addSubview:NCView];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(0, 0, viewWith-30, _tagHeight);
            button.layer.borderColor = _borderColor.CGColor;
            button.layer.borderWidth = _borderWidth;
            button.layer.masksToBounds = _masksToBounds;
            button.layer.cornerRadius = _cornerRadius;
            button.titleLabel.font = [UIFont systemFontOfSize:_titleSize];
            [button setTitle:tagTitle forState:UIControlStateNormal];
            [button setTitleColor:_titleColor forState:UIControlStateNormal];
            [button setBackgroundImage:_normalBackgroundImage forState:UIControlStateNormal];
            [button setBackgroundImage:_highlightedBackgroundImage forState:UIControlStateHighlighted];
            button.tag = i*iTags.count+j;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(viewWith-30, 0, 30, _tagHeight)];
            label.text=[NSString stringWithFormat:@"X%@",count];
            label.textAlignment=NSTextAlignmentCenter;
            label.adjustsFontSizeToFitWidth=YES;
            label.textColor=_titleColor;
            [NCView addSubview:button];
            [NCView addSubview:label];
        }
    }
    self.countLabel=[[UILabel alloc]initWithFrame:CGRectMake(_tagOriginX, [self getDisposeTagsViewHeight:disposeAry], 100, 30)];
    self.countLabel.text=[NSString stringWithFormat:@"总计：%ld次",_times];
    self.countLabel.textAlignment=NSTextAlignmentLeft;
    self.countLabel.adjustsFontSizeToFitWidth=YES;
    self.countLabel.textColor=_titleColor;
    [self addSubview:self.countLabel];
    if (disposeAry.count > 0) {
            float contentSizeHeight = _tagOriginY+disposeAry.count*(_tagHeight+_tagVerticalSpace);
            self.contentSize = CGSizeMake(self.frame.size.width,contentSizeHeight);
    }
    
    if (self.frame.size.height <= 0) {
        self.frame = CGRectMake(CGRectGetMinX([self frame]), CGRectGetMinY([self frame]), CGRectGetWidth([self frame]), [self getDisposeTagsViewHeight:disposeAry]+30);
    }


}
//将标签数组根据type以及其他参数进行分组装入数组
- (void)disposeTags:(NSArray *)aryName aryCount:(NSArray *)aryCount{
    NSMutableArray *tags = [NSMutableArray new];//纵向数组
    NSMutableArray *subTags = [NSMutableArray new];//横向数组
    
    float originX = _tagOriginX;
    for (NSString *tagTitle in aryName) {
        NSUInteger index = [aryName indexOfObject:tagTitle];
        
        //计算每个tag的宽度
        CGSize contentSize = [tagTitle fdd_sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.frame.size.width-_tagOriginX*2, MAXFLOAT)];
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        dict[@"tagTitle"] = tagTitle;//标签标题
        dict[@"tagCount"] =aryCount[index];
        dict[@"viewWith"] = [NSString stringWithFormat:@"%f",contentSize.width+_tagSpace+30];//标签的宽度
        
        if (index == 0) {
            dict[@"originX"] = [NSString stringWithFormat:@"%f",originX];//标签的X坐标
            [subTags addObject:dict];
        } else {
                if (originX + contentSize.width > self.frame.size.width-_tagOriginX*2) {
                    //当前标签的X坐标+当前标签的长度>屏幕的横向总长度则换行
                    [tags addObject:subTags];
                    //换行标签的起点坐标初始化
                    originX = _tagOriginX;
                    dict[@"originX"] = [NSString stringWithFormat:@"%f",originX];//标签的X坐标
                    subTags = [NSMutableArray new];
                    [subTags addObject:dict];
                } else {
                    //如果没有超过屏幕则继续加在前一个数组里
                    dict[@"originX"] = [NSString stringWithFormat:@"%f",originX];//标签的X坐标
                    [subTags addObject:dict];
                }
            }
        
        if (index +1 == aryName.count) {
            //最后一个标签加完将横向数组加到纵向数组中
            [tags addObject:subTags];
            disposeAry = tags;
        }
        
        //标签的X坐标每次都是前一个标签的宽度+标签左右空隙+标签距下个标签的距离
        originX += contentSize.width+_tagHorizontalSpace+_tagSpace+30;
    }
}


//获取处理后的tagsView的高度根据标签的数组
- (float)getDisposeTagsViewHeight:(NSArray *)ary {
    
    float height = 0;
    if (disposeAry.count > 0) {
            height = _tagOriginY+disposeAry.count*(_tagHeight+_tagVerticalSpace);
    }
    return height;
}

- (void)buttonAction:(UIButton *)sender {
    if (_tagDelegate && [_tagDelegate respondsToSelector:@selector(tagsViewButtonAction:button:)]) {
        [_tagDelegate tagsViewButtonAction:self button:sender];
    }
}
//颜色生成图片方法
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,
                                   
                                   color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end

#pragma mark - 扩展方法

@implementation NSString (FDDExtention)

- (CGSize)fdd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    CGSize resultSize;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        NSStringDrawingContext *context;
        [invocation setArgument:&size atIndex:2];
        [invocation setArgument:&options atIndex:3];
        [invocation setArgument:&attributes atIndex:4];
        [invocation setArgument:&context atIndex:5];
        [invocation invoke];
        CGRect rect;
        [invocation getReturnValue:&rect];
        resultSize = rect.size;
    } else {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(sizeWithFont:constrainedToSize:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(sizeWithFont:constrainedToSize:)];
        [invocation setArgument:&font atIndex:2];
        [invocation setArgument:&size atIndex:3];
        [invocation invoke];
        [invocation getReturnValue:&resultSize];
    }
    return resultSize;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
