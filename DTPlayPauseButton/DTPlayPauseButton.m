//
//  DTPlayPauseButton.m
//
//  Created by Darktt on 15/11/13.
//  Copyright © 2015年 Darktt. All rights reserved.
//

#import "DTPlayPauseButton.h"

@import UIKit.UIControl;

@interface DTPlayPauseButton ()
{
    CAShapeLayer *_shapeLayer;
    BOOL _playing;
}

@end

@implementation DTPlayPauseButton

+ (instancetype)playPauseButtonWithFrame:(CGRect)frame
{
    DTPlayPauseButton *button = [[DTPlayPauseButton alloc] initWithFrame:frame];
    
    return [button autorelease];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _playing = NO;
    
    [self setupKVO];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self == nil) return nil;
    
    _playing = NO;
    
    [self initialColors];
    [self setupKVO];
    
    return self;
}

- (void)dealloc
{
    [self removeKVO];
    
    [super dealloc];
}

- (BOOL)canBecomeFocused
{
    return YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutLayer];
}

#pragma mark - Private Methods -

- (void)initialColors
{
    UIColor *backgroundColor = [UIColor blackColor];
    UIColor *tintColor = [UIColor whiteColor];
    
    [self setBackgroundColor:backgroundColor];
    [self setTintColor:tintColor];
}

- (void)layoutLayer
{
    if (_shapeLayer == nil) {
        _shapeLayer = [CAShapeLayer layer];
        
        [self.layer addSublayer:_shapeLayer];
    }
    
    CGPathRef shapPath = nil;
    
    if (_playing) {
        shapPath = [self playPath];
    } else {
        shapPath = [self pausePath];
    }
    
    [_shapeLayer setPath:shapPath];
    [_shapeLayer setFrame:self.bounds];
    [_shapeLayer setFillColor:self.tintColor.CGColor];
    [_shapeLayer setBackgroundColor:self.backgroundColor.CGColor];
}

- (CGPathRef)pausePath
{
    CGRect bounds = self.bounds;
    
    CGPoint center = (CGPoint) {
        .x = floor(CGRectGetMaxX(bounds) / 3.0f) - 5.0f,
        .y = floor(CGRectGetMaxY(bounds) / 2.0f)
    };
    
    CGSize shapeSize = (CGSize) {
        .width = floor(CGRectGetWidth(bounds) / 4.0f),
        .height = floor(CGRectGetHeight(bounds) - 20.0f)
    };
    
    UIBezierPath *pausePath = [UIBezierPath bezierPath];
    
    {
        CGRect leftShapeFrame = (CGRect) {
            .origin = (CGPoint) {
                .x = center.x - (shapeSize.width / 2.0f),
                .y = center.y - (shapeSize.height / 2.0f)
            },
            .size = shapeSize
        };
        
        UIBezierPath *leftShape = [UIBezierPath bezierPathWithRect:leftShapeFrame];
        [pausePath appendPath:leftShape];
        
        center.x += center.x + 15.0f;
    }
    
    {
        CGRect rightShapeFrame = (CGRect) {
            .origin = (CGPoint) {
                .x = center.x - (shapeSize.width / 2.0f),
                .y = center.y - (shapeSize.height / 2.0f)
            },
            .size = shapeSize
        };
        
        UIBezierPath *rightShape = [UIBezierPath bezierPathWithRect:rightShapeFrame];
        [pausePath appendPath:rightShape];
    }
    
    
    return pausePath.CGPath;
}

- (CGPathRef)playPath
{
    CGRect bounds = self.bounds;
    
    CGPoint trianglePoint1 = (CGPoint) {
        .x = floor(CGRectGetMaxX(bounds) / 3.0f)/* 1/3 of width */ - (CGRectGetMaxX(bounds) / 8.0f)/* 1/8 of width */ - 5.0f,
        .y = 10.0f
    };
    
    CGPoint trianglePoint2 = (CGPoint) {
        .x = CGRectGetMaxX(bounds) - trianglePoint1.x,
        .y = CGRectGetMidY(bounds)
    };
    
    CGPoint trianglePoint3 = (CGPoint) {
        .x = trianglePoint1.x,
        .y = CGRectGetMaxY(bounds) - 10.0f
    };
    
    CGPoint midPoint1 = (CGPoint) {
        .x = (trianglePoint1.x + trianglePoint2.x) / 2.0f,
        .y = (trianglePoint1.y + trianglePoint2.y) / 2.0f
    };
    
    CGPoint midPoint2 = (CGPoint) {
        .x = (trianglePoint3.x + trianglePoint2.x) / 2.0f,
        .y = (trianglePoint3.y + trianglePoint2.y) / 2.0f
    };
    
    UIBezierPath *playPath = [UIBezierPath bezierPath];
    
    // Left Shape Path
    {
        UIBezierPath *leftPath = [UIBezierPath bezierPath];
        [leftPath moveToPoint:trianglePoint1];
        [leftPath addLineToPoint:midPoint1];
        [leftPath addLineToPoint:midPoint2];
        [leftPath addLineToPoint:trianglePoint3];
        [leftPath closePath];
        
        [playPath appendPath:leftPath];
    }
    
    // Right Shape Path
    {
        UIBezierPath *rightPath = [UIBezierPath bezierPath];
        [rightPath moveToPoint:midPoint1];
        [rightPath addLineToPoint:trianglePoint2];
        [rightPath addLineToPoint:trianglePoint2]; /**< Add duplicate point for maintain four points shape. */
        [rightPath addLineToPoint:midPoint2];
        [rightPath closePath];
        
        [playPath appendPath:rightPath];
    }
    
    return playPath.CGPath;
}

- (void)setupKVO
{
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"tintColor" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeKVO
{
    [self removeObserver:self forKeyPath:@"frame" context:nil];
    [self removeObserver:self forKeyPath:@"tintColor" context:nil];
}

- (void)tintColorDidChange
{
    [self setNeedsLayout];
}

#pragma mark - Update Focus for tvOS

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
{
    if (context.previouslyFocusedView == self) {
        
        void (^animations) (void) = ^{
            CATransform3D transfrom = CATransform3DIdentity;
            
            [_shapeLayer setTransform:transfrom];
        };
        
        [coordinator addCoordinatedAnimations:animations completion:nil];
        
        return;
    }
    
    void (^animations) (void) = ^{
        CATransform3D transfrom = CATransform3DMakeScale(1.5f, 1.5f, 1.5f);
        
        [_shapeLayer setTransform:transfrom];
    };
    
    [coordinator addCoordinatedAnimations:animations completion:nil];
}

#pragma mark - Override Property -

- (void)setPlaying:(BOOL)playing
{
    [self setPlaying:playing animated:NO];
}

- (BOOL)isPlaying
{
    return _playing;
}

#pragma mark - Public Method -

- (void)setPlaying:(BOOL)playing animated:(BOOL)animated
{
    if (_playing == playing) {
        return;
    }
    
    _playing = playing;
    
    if (!animated) {
        [self layoutLayer];
        
        return;
    }
    
    CGPathRef shapPath = nil;
    
    if (_playing) {
        shapPath = [self playPath];
    } else {
        shapPath = [self pausePath];
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    [animation setFromValue:(id)_shapeLayer.path];
    [animation setToValue:(id)shapPath];
    [animation setByValue:(id)shapPath];
    [animation setDuration:0.15f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setRemovedOnCompletion:NO];
    [animation setDelegate:self];
    
    [_shapeLayer addAnimation:animation forKey:@"Animations"];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [super addTarget:target action:action forControlEvents:controlEvents];
}

#pragma mark - Touch Methods -

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
    
#ifdef TARGET_OS_TV
    
    return YES;
    
#else
    
    CGPoint point = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, point)) {
        [self sendActionsForControlEvents:UIControlEventTouchDown];
    }
    
    return self.enabled;
    
#endif
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    
#ifndef TARGET_OS_TV
    
    CGPoint point = [touch locationInView:self];
    
    if (!CGRectContainsPoint(self.bounds, point)) {
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
        
        return;
    }
    
    [self setPlaying:!_playing animated:YES];
    
#endif
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [super cancelTrackingWithEvent:event];
    
#ifndef TARGET_OS_TV
    
    [self sendActionsForControlEvents:UIControlEventTouchCancel];
    
#endif
}

#pragma mark - Press Method -

- (void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event
{
    [super pressesBegan:presses withEvent:event];
}

- (void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event
{
    [super pressesEnded:presses withEvent:event];
    
    UIPress *press = [presses anyObject];
    
    if (press.type == UIPressTypePlayPause || press.type == UIPressTypeSelect) {
        [self setPlaying:!_playing animated:YES];
        
        [self sendActionsForControlEvents:UIControlEventPrimaryActionTriggered];
    }
}

#pragma mark - KVO Method -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsLayout];
}

#pragma mark - Delegate Methods -

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (!flag) {
        return;
    }
    
    CABasicAnimation *animation = (CABasicAnimation *)anim;
    CGPathRef path = (CGPathRef)animation.toValue;
    
    [_shapeLayer setPath:path];
    [_shapeLayer removeAllAnimations];
}

@end
