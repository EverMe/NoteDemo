//
//  MYSegmentView.h
//  NoteDemo
//
//  Created by byw on 2018/12/20.
//  Copyright © 2018 byw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYSegmentView : UIView

@property (nonatomic, assign) UIEdgeInsets contentInset;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont  *titleFont;
@property (nonatomic, strong) UIColor *titleHighlightColor;
@property (nonatomic, strong) UIFont  *titleHighlightFont;          //default is titleFont

@property (nonatomic, assign) NSTextAlignment titleAlignment;       //default center
@property (nonatomic, assign) CGFloat titleWidthMin;                //default 0
@property (nonatomic, assign) CGFloat titleWidth;                   //default = -1  AutoWidth
@property (nonatomic, assign) CGFloat extendWidth;                  //当titleWidth自动计算出后 额外增加的宽度

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineHeight;                   //defaulte = 2
@property (nonatomic, assign) CGFloat lineWidth;                    //默认-1 和titleLab的text保持同宽

@property (nonatomic, assign) CGFloat space;                        //default = 10

@property (nonatomic, strong ,readonly) UIScrollView *titleSc;      //titleLab的父view
@property (nonatomic, weak) IBInspectable UIScrollView *scrollView; //关联的scrollView 赋值后 选中item会滑动到对应idx的offset

/** 选中item的回调 */
@property (nonatomic, copy) void (^selectedIndexBlock)(NSInteger index ,NSString *text);

/** 设置items的title 并开始创建控件 */
- (void)setTitles:(NSArray<NSString *> *)titles selectedIndex:(NSUInteger)index;

/** 返回titleLab布局后的总宽度  使用titleSc.contentSize.width 代替*/
//- (CGFloat)completeTitleTotalWidth;

/** 返回指定idx的titleLab的Frame */
- (CGRect)getTitleLabFrameWithIdx:(NSInteger)idx;

/** 高亮指定indxx的titleLab */
- (void)highlightSegmentUIAtIndex:(NSUInteger)index;
@end
NS_ASSUME_NONNULL_END
