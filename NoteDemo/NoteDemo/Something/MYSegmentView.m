//
//  MYSegmentView.m
//  NoteDemo
//
//  Created by byw on 2018/12/20.
//  Copyright © 2018 byw. All rights reserved.
//

#import "MYSegmentView.h"

@interface MYSegmentView ()

@property (nonatomic, strong) UIScrollView *titleSc;
@property (nonatomic, strong) NSMutableArray<UILabel *> *titleLabs;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *highlightLab;
@end

@implementation MYSegmentView{
    
    NSInteger _selectedIndex;
    CGFloat _totalWidth;
}

- (void)setTitles:(NSArray<NSString *> *)titles selectedIndex:(NSUInteger)index{
    
    __block CGFloat labX = self.contentInset.left;
    CGFloat labY = self.contentInset.top;
    CGFloat labH = self.titleSc.bounds.size.height - self.contentInset.bottom - self.contentInset.top;
    
    [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *titleLab = [self createTitleLabWithText:title];
        CGFloat labW = 0;
        if (self.titleWidth == -1) {
            CGFloat fitW = [titleLab sizeThatFits:CGSizeMake(MAXFLOAT, labH)].width;
            fitW += self.extendWidth;
            fitW = MAX(fitW, self.titleWidthMin);
            labW = fitW;
        }else{
            labW = self.titleWidth;
        }
        titleLab.frame = CGRectMake(labX, labY, labW, labH);
        [self.titleSc addSubview:titleLab];
        [self.titleLabs addObject:titleLab];
        
        if (index == idx) {
            titleLab.font = self.titleHighlightFont;
            titleLab.textColor = self.titleHighlightColor;
            self.highlightLab = titleLab;
            [self moveLineWidthWithTitleLab:titleLab animated:NO];
        }
        
        labX = labX + labW + self.space;
    }];
    
    labX = labX - self.space + self.contentInset.right;
    
    _totalWidth = labX;
    self.titleSc.contentSize = CGSizeMake(labX, self.bounds.size.height);
    self.titleSc.scrollEnabled = labX > self.bounds.size.width;
}
- (CGFloat)completeTitleTotalWidth{
    return _totalWidth;
}
- (CGRect)getTitleLabFrameWithIdx:(NSInteger)idx{
    
    if (idx >= self.titleLabs.count) {
        return CGRectZero;
    }
    UILabel *lab = self.titleLabs[idx];
    return lab.frame;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    //    CGFloat width = MAX(_totalWidth, self.titleSc.bounds.size.width);
    //    self.titleSc.contentSize = CGSizeMake(width, self.titleSc.height);
    self.titleSc.scrollEnabled = _totalWidth > self.titleSc.bounds.size.width;
}

- (UILabel *)createTitleLabWithText:(NSString *)text{
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.userInteractionEnabled = YES;
    titleLab.font = _titleFont;
    titleLab.textColor = _titleColor;
    titleLab.textAlignment = _titleAlignment;
    titleLab.text = text;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedTitleLab:)];
    [titleLab addGestureRecognizer:tap];
    return titleLab;
}

- (void)selectedTitleLab:(UITapGestureRecognizer *)tap{
    
    UILabel *lab = (UILabel *)tap.view;
    NSInteger index = [self.titleLabs indexOfObject:lab];
    if (_selectedIndex == index) {
        return;
    }
    //    [self.scrollView scrollToItemAtIndex:index animated:YES];
    if (self.scrollView) {
        BOOL animated = labs(_selectedIndex-index) <= 1;
        [self.scrollView setContentOffset:CGPointMake(index*self.scrollView.bounds.size.width, 0) animated:animated];
    }
    [self highlightSegmentUIAtIndex:index];
    _selectedIndex = index;
}

- (void)highlightSegmentUIAtIndex:(NSUInteger)index{
    
    if (index >= self.titleLabs.count) return;
    
    UILabel *titleLab = [self.titleLabs objectAtIndex:index];
    self.highlightLab.textColor = self.titleColor;
    self.highlightLab.font = self.titleFont;
    titleLab.textColor = self.titleHighlightColor;
    titleLab.font = self.titleHighlightFont;
    self.highlightLab = titleLab;
    [self moveLineWidthWithTitleLab:titleLab animated:YES];
    !self.selectedIndexBlock ? : self.selectedIndexBlock(index,titleLab.text);
}

- (void)moveLineWidthWithTitleLab:(UILabel *)lab animated:(BOOL)animated{
    
    CGFloat lineW = _lineWidth==-1 ? lab.bounds.size.width - _extendWidth : _lineWidth;
    CGPoint center = CGPointMake(lab.center.x, self.bounds.size.height-_lineHeight-_contentInset.bottom);
    CGRect newRect = _lineView.frame;
    self.lineView.backgroundColor = self.lineColor;
    newRect.size.width = lineW;
    if (animated) {
        [UIView animateWithDuration:0.25f animations:^{
            self.lineView.frame = newRect;
            self.lineView.center = center;
        }];
    }else{
        self.lineView.frame = newRect;
        self.lineView.center = center;
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder   {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    
    _selectedIndex = 0;
    _totalWidth = 0;
    
    _contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    _titleColor = UIColor.lightGrayColor;
    _titleFont = [UIFont systemFontOfSize:16];
    _titleHighlightColor = UIColor.blackColor;
    _titleHighlightFont = nil;
    
    _titleAlignment = NSTextAlignmentCenter;
    _titleWidth = -1;
    _extendWidth = 10;
    _titleWidthMin = 0;
    
    _lineColor = UIColor.blackColor;
    _lineWidth = -1;
    _lineHeight = 2;
    
    _space = 10;
    
    [self addSubview:self.titleSc];
    [self.titleSc addSubview:self.lineView];
    self.titleLabs = [[NSMutableArray alloc] init];
}

- (UIFont *)titleHighlightFont{
    if (!_titleHighlightFont) {
        return _titleFont;
    }
    return _titleHighlightFont;
}
- (UIColor *)titleHighlightColor{
    if (!_titleHighlightColor) {
        return _titleColor;
    }
    return _titleHighlightColor;
}

- (UIScrollView *)titleSc{
    if (!_titleSc) {
        _titleSc = [[UIScrollView alloc] initWithFrame:self.bounds];
        _titleSc.showsVerticalScrollIndicator = NO;
        _titleSc.showsHorizontalScrollIndicator = NO;
        _titleSc.pagingEnabled = NO;
        _titleSc.scrollEnabled = NO;
        _titleSc.backgroundColor = UIColor.clearColor;
        _titleSc.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _titleSc;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-_lineHeight-_contentInset.bottom, _lineWidth, _lineHeight)];
        _lineView.backgroundColor = _lineColor;
    }
    return _lineView;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(MIN(_totalWidth, self.bounds.size.width) ,UIViewNoIntrinsicMetric);
}

- (void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
}



@end
