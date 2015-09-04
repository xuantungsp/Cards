//
//  InteractiveTransitionUtilities.m
//  Cards
//
//  Created by Hanssen, Alfie on 3/28/14.
//  Copyright (c) 2014 Alfred Hanssen. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "TransitionUtilities.h"

static const CGFloat Gravity = 20.0f;

@implementation TransitionUtilities

#pragma mark - Frames

// These are necessary because containerView is always portrait orientation (doesn't respect rotation changes)
// http://stackoverflow.com/questions/20013929/workaround-for-custom-uiviewcontroller-animations-in-landscape
// http://www.brightec.co.uk/blog/ios-7-custom-view-controller-transitions-and-rotation-making-it-all-work

+ (CGRect)rectForDismissedState:(id<UIViewControllerContextTransitioning>)transitionContext forPresentation:(BOOL)isPresentation
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = nil;
    
    if (isPresentation)
    {
        fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    else
    {
        fromViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    
    CGRect frame = CGRectZero;
    
    switch (fromViewController.interfaceOrientation)
    {
        case UIInterfaceOrientationLandscapeRight:
            frame = CGRectMake(-containerView.bounds.size.width,
                               0,
                               containerView.bounds.size.width,
                               containerView.bounds.size.height);
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            frame = CGRectMake(containerView.bounds.size.width,
                               0,
                               containerView.bounds.size.width,
                               containerView.bounds.size.height);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            frame = CGRectMake(0,
                               -containerView.bounds.size.height,
                               containerView.bounds.size.width,
                               containerView.bounds.size.height);
            break;
            
        case UIInterfaceOrientationPortrait:
            frame = CGRectMake(0,
                               containerView.bounds.size.height,
                               containerView.bounds.size.width,
                               containerView.bounds.size.height);
            break;
            
        default:
            break;
    }
    
    return frame;
}

+ (CGRect)rectForPresentedState:(id<UIViewControllerContextTransitioning>)transitionContext forPresentation:(BOOL)isPresentation
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *viewController = nil;
    
    if (isPresentation)
    {
        viewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    else
    {
        viewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    
    CGRect frame = [self rectForDismissedState:transitionContext forPresentation:isPresentation];
    
    switch (viewController.interfaceOrientation)
    {
        case UIInterfaceOrientationLandscapeRight:
            frame = CGRectOffset(frame, containerView.bounds.size.width, 0);
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            frame = CGRectOffset(frame, -1.0f * containerView.bounds.size.width, 0);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            frame = CGRectOffset(frame, 0, containerView.bounds.size.height);
            break;
            
        case UIInterfaceOrientationPortrait:
            frame = CGRectOffset(frame, 0, -1.0f * containerView.bounds.size.height);
            break;
            
        default:
            break;
    }
    
    return frame;
}

+ (CGRect)rectForPresentedState:(id<UIViewControllerContextTransitioning>)transitionContext percentComplete:(CGFloat)percentComplete forPresentation:(BOOL)isPresentation
{
    UIViewController *viewController = nil;
    if (isPresentation)
    {
        viewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    else
    {
        viewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    
    CGRect frame = [self rectForPresentedState:transitionContext forPresentation:isPresentation];
    
    switch (viewController.interfaceOrientation)
    {
        case UIInterfaceOrientationLandscapeRight:
            frame = CGRectOffset(frame, -1.0f * CGRectGetWidth(frame) * percentComplete, 0.0f);
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            frame = CGRectOffset(frame, CGRectGetWidth(frame) * percentComplete, 0.0f);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            frame = CGRectOffset(frame, 0.0f, -1.0f * CGRectGetHeight(frame) * percentComplete);
            break;
            
        case UIInterfaceOrientationPortrait:
            frame = CGRectOffset(frame, 0.0f, CGRectGetHeight(frame) * percentComplete);
            break;
            
        default:
            break;
    }
    
    return frame;
}

#pragma mark - Dynamics

+ (UIEdgeInsets)collisionInsets:(id<UIViewControllerContextTransitioning>)transitionContext forPresentation:(BOOL)isPresentation
{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if (isPresentation)
    {
        insets = [self collisionInsetsForPresentation:transitionContext];
    }
    else
    {
        insets = [self collisionInsetsForDismissal:transitionContext];
    }
    
    return insets;
}

+ (UIEdgeInsets)collisionInsetsForPresentation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    UIViewController *viewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    switch (viewController.interfaceOrientation)
    {
        case UIInterfaceOrientationLandscapeRight:
            insets = UIEdgeInsetsMake(0, -1.0f * CGRectGetWidth(transitionContext.containerView.bounds), 0, 0);
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            insets = UIEdgeInsetsMake(0, 0, 0, -1.0f * CGRectGetWidth(transitionContext.containerView.bounds));
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            insets = UIEdgeInsetsMake(-1.0f * CGRectGetHeight(transitionContext.containerView.bounds), 0, 0, 0);
            break;
            
        case UIInterfaceOrientationPortrait:
            insets = UIEdgeInsetsMake(0, 0, -1.0f * CGRectGetHeight(transitionContext.containerView.bounds), 0);
            break;
            
        default:
            break;
    }
    
    return insets;
}

+ (UIEdgeInsets)collisionInsetsForDismissal:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    UIViewController *viewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    switch (viewController.interfaceOrientation)
    {
        case UIInterfaceOrientationLandscapeRight:
            insets = UIEdgeInsetsMake(0, -1.0f * CGRectGetWidth(transitionContext.containerView.bounds), 0, 0);
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            insets = UIEdgeInsetsMake(0, 0, 0, -1.0f * CGRectGetWidth(transitionContext.containerView.bounds));
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            insets = UIEdgeInsetsMake(-1.0f * CGRectGetHeight(transitionContext.containerView.bounds), 0, 0, 0);
            break;
            
        case UIInterfaceOrientationPortrait:
            insets = UIEdgeInsetsMake(0, 0, -1.0f * CGRectGetHeight(transitionContext.containerView.bounds), 0);
            break;
            
        default:
            break;
    }
    
    return insets;
}

+ (CGVector)gravityVector:(id<UIViewControllerContextTransitioning>)transitionContext forPresentation:(BOOL)isPresentation
{
    CGVector vector = CGVectorMake(0.0f, 0.0f);
    
    if (isPresentation)
    {
        vector = [self gravityVectorForPresentation:transitionContext];
    }
    else
    {
        vector = [self gravityVectorForDismissal:transitionContext];
    }
    
    return vector;
}

+ (CGVector)gravityVectorForPresentation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    CGVector vector = CGVectorMake(0.0f, 0.0f);
    UIViewController *viewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    switch (viewController.interfaceOrientation)
    {
        case UIInterfaceOrientationLandscapeRight:
            vector = CGVectorMake(Gravity, 0.0f);
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            vector = CGVectorMake(-Gravity, 0.0f);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            vector = CGVectorMake(0.0f, Gravity);
            break;
            
        case UIInterfaceOrientationPortrait:
            vector = CGVectorMake(0.0f, -Gravity);
            break;
            
        default:
            break;
    }
    
    return vector;
}

+ (CGVector)gravityVectorForDismissal:(id<UIViewControllerContextTransitioning>)transitionContext
{
    CGVector vector = CGVectorMake(0.0f, 0.0f);
    UIViewController *viewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    switch (viewController.interfaceOrientation)
    {
        case UIInterfaceOrientationLandscapeRight:
            vector = CGVectorMake(-Gravity, 0.0f);
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            vector = CGVectorMake(Gravity, 0.0f);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            vector = CGVectorMake(0.0f, -Gravity);
            break;
            
        case UIInterfaceOrientationPortrait:
            vector = CGVectorMake(0.0f, Gravity);
            break;
            
        default:
            break;
    }
    
    return vector;
}

@end
