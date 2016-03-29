//
//  AnimationView.m
//  DragAnimationDeno
//
//  Created by 8kana on 16/3/21.
//  Copyright © 2016年 8kana. All rights reserved.
//

#import "AnimationView.h"

@interface AnimationView ()
//判断
@property (nonatomic,assign)bool isAtRect;
//圆心
@property (nonatomic,assign)CGPoint moveArcCenter;
@property (nonatomic,assign)CGPoint stayArcCenter;
//公切点
@property (nonatomic,assign)CGPoint moveArcPoint1;
@property (nonatomic,assign)CGPoint moveArcPoint2;
@property (nonatomic,assign)CGPoint stayArcPoint1;
@property (nonatomic,assign)CGPoint stayArcPoint2;
//半径
@property (nonatomic,assign)CGFloat moveArcRadius;
@property (nonatomic,assign)CGFloat stayArcRadius;
//bezier曲线参照点
@property (nonatomic,assign)CGPoint anchPiont;

//是否在原位置
@property (nonatomic,assign)BOOL isAtCenter;


@end

@implementation AnimationView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
//        初始化两个圆的圆心
        _moveArcCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _stayArcCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//        初始化两个圆的半径
        _moveArcRadius = 10;
        _stayArcRadius = 10;
        
        _isAtCenter = NO;
    }
    return self;
}


-(void)drawRect:(CGRect)rect{

    CGContextRef ref = UIGraphicsGetCurrentContext();

    [[UIColor redColor] set];
    
//    运动的圆
    CGContextAddArc(ref, _moveArcCenter.x, _moveArcCenter.y, _moveArcRadius, 0, M_PI * 2, NO);
    
    CGContextFillPath(ref);
    
//    待在中间不动的圆
    CGContextAddArc(ref, _stayArcCenter.x, _stayArcCenter.y, _stayArcRadius, 0, M_PI * 2, NO);
    
    CGContextFillPath(ref);
    
//    判断移动的圆是不是和中心的圆共圆心 ，如果共圆心不画曲边矩形
    
    if (!_isAtCenter) {
        
//        曲边矩形的四个点是两个圆的公切点，公切点计算运用的是三角函数，
       
//        先移动到起点到其中一个点
        CGContextMoveToPoint(ref, _moveArcPoint1.x , _moveArcPoint1.y);
//        画第一条弧线
        CGContextAddQuadCurveToPoint(ref, _anchPiont.x, _anchPiont.y, _stayArcPoint1.x, _stayArcPoint1.y);
//        画一条连接两条弧线的直线
        CGContextAddLineToPoint(ref, _stayArcPoint2.x, _stayArcPoint2.y);
        
//        画第二条弧线
        CGContextAddQuadCurveToPoint(ref, _anchPiont.x, _anchPiont.y, _moveArcPoint2.x, _moveArcPoint2.y);
//       红色填充之后就是一个实心的曲边的矩形
        [[UIColor redColor] set];
        CGContextFillPath(ref);
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    起始位置判断是不是在红点范围内，如果不在范围内，不做拉伸计算。也就是红点不能拉伸
    
    CGPoint p = [[touches anyObject] locationInView:self];
    
    CGRect rect = CGRectMake(_stayArcCenter.x - 15, _stayArcCenter.y - 15, 30, 30);
    
    _isAtRect = CGRectContainsPoint(rect, p);

 
   
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    判断开始触摸的点是否在红点上
    if (_isAtRect) {

//        把移动点是否在中心变为NO
        _isAtCenter = NO;
        
        CGPoint p = [[touches anyObject] locationInView:self];
         _moveArcCenter = p;
        
//        计算两个圆的圆心距
        CGFloat l = sqrt(pow((_moveArcCenter.x - _stayArcCenter.x), 2) + pow((_moveArcCenter.y - _stayArcCenter.y), 2));
        
//        根据圆心距改变不动圆的半径
        _stayArcRadius = 10 - l/15;
        
//        如果拉的太长，超出范围，让移动圆回到中心
        if (l > 100) {
            _moveArcCenter = _stayArcCenter;
            _isAtCenter = YES;
        }
        
//      计算
        [self calculation];

        [self setNeedsDisplay];
        
    }

}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  
//    结束时让移动圆回到中心位置
    _moveArcCenter = _stayArcCenter;
    [self calculation];
    _isAtCenter = YES;
    [self setNeedsDisplay];


}


-(void)calculation{
   
//    曲边矩形 ，曲边的Bezier曲线的参照点
    _anchPiont = CGPointMake(fabs(_moveArcCenter.x + _stayArcCenter.x)/2, fabs(_moveArcCenter.y + _stayArcCenter.y)/2);
    
//    角度的sin值和cos值
    CGFloat sin = (_moveArcCenter.x - _stayArcCenter.x)/sqrt(pow((_moveArcCenter.x - _stayArcCenter.x), 2) + pow((_moveArcCenter.y - _stayArcCenter.y), 2));
    
    CGFloat cos = (_moveArcCenter.y - _stayArcCenter.y)/sqrt(pow((_moveArcCenter.x - _stayArcCenter.x), 2) + pow((_moveArcCenter.y - _stayArcCenter.y), 2));
    
    
//    共切点的计算，初中数学
    _moveArcPoint1 = CGPointMake(_moveArcRadius * cos + _moveArcCenter.x, -_moveArcRadius * sin + _moveArcCenter.y);
    
    _moveArcPoint2 = CGPointMake(-_moveArcRadius * cos + _moveArcCenter.x, _moveArcRadius * sin + _moveArcCenter.y);
    
    
    _stayArcPoint1 = CGPointMake(_stayArcRadius * cos+ _stayArcCenter.x, -_stayArcRadius * sin +_stayArcCenter.y);
    
    _stayArcPoint2 = CGPointMake(-_stayArcRadius * cos+ _stayArcCenter.x, _stayArcRadius * sin +_stayArcCenter.y);
}


@end
