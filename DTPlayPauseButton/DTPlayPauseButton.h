//
//  DTPlayPauseButton.h
//
//  Created by Darktt on 15/11/13.
//  Copyright © 2015年 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE
/**
 *  Animating the transition the Playing and Pause state,
 *  Like the Youtube play/pause button.
 */
NS_CLASS_AVAILABLE_IOS(7_0) @interface DTPlayPauseButton : UIControl

/**
 *  A Boolean value that determines the playing/pause state of the state.
 */
@property (assign, getter=isPlaying) IBInspectable BOOL playing;

/**
 *  Initals new DTPlayPauseButton instance.
 *
 *  @param frame The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This method uses the frame rectangle to set the center and bounds properties accordingly.
 *
 *  @return The instance of DTPlayPauseButton.
 */
+ (instancetype)playPauseButtonWithFrame:(CGRect)frame;

/**
 *  Change the state of switch Playing or Pause, optionally animating the transition.
 *  If the state is already in the designated position, nothing happens.
 *
 *  @param playing  'YES' shows Playing indicate, 'NO' shows Pause indicate.
 *  @param animated 'YES' to animating the transition two indicate; otherwise 'NO'.
 */
- (void)setPlaying:(BOOL)playing animated:(BOOL)animated;

/**
 *  Adds a target and action for a particular event (or events) to an internal dispatch table.
 *
 *  @param target        The target object—that is, the object to which the action message is sent. If this is nil, the responder chain is searched for an object willing to respond to the action message.
 *  @param action        A selector identifying an action message. It cannot be NULL.
 *  @param controlEvents A bitmask specifying the control events for which the action message is sent. Like UIButton, you can use UIControlEventTouchDown, UIControlEventTouchUpInside, UIControlEventTouchUpOutside and UIControlEventTouchCancel events.
 */
- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
NS_ASSUME_NONNULL_END