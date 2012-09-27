//
//  HugoCommentsView.m
//  HugoClient
//
//  Created by Ryan Waliany on 9/23/12.
//  Copyright (c) 2012 Hugo, Inc. All rights reserved.
//

#import "HugoCommentsView.h"
#import <QuartzCore/QuartzCore.h>

@implementation HugoCommentsView
@synthesize _comments;

- (id)initWithComments:(NSArray*)comments andPadding:(int)padding andWidth:(int)width
{
    self = [super init];
    if (self) {
        // Initialization code
    }
    
    self._comments = [comments mutableCopy];

    _width = width;
    _padding = padding;
    _offset = _padding;
    
    for (int i = 0; i < comments.count; i++)
    {
        UIView *bubble = [self getBubbleForContext:[comments objectAtIndex:i]];
        CGRect frame = bubble.frame;
        frame.origin.y = _offset;
        bubble.frame = frame;
        
        _offset = _offset + _padding + frame.size.height;
        [self addSubview:bubble];
    }
    _offset += 10.0f;
    
    self.frame = CGRectMake(0, 0, 320, _offset);
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIView*)getBubbleForContext:(NSDictionary*)item
{
    UIView *messageView = [UIView new];
    messageView.layer.cornerRadius = 5.0f;
    
    if ([[item objectForKey:@"comment_type"] isEqual:@"comment"])
    {
        messageView.backgroundColor = [UIColor colorWithRed:238/255.0 green:246/255.0 blue:250/255.0 alpha:1.0];
    }
    else if ([[item objectForKey:@"comment_type"] isEqual:@"center"])
    {
        messageView.backgroundColor = [UIColor colorWithWhite:0.94f alpha:1.0f];
    }
    else
    {
        messageView.backgroundColor = [UIColor whiteColor];
    }
    
    messageView.layer.masksToBounds = YES;
    
    
    
    UILabel *labelView = [UILabel new];
    
    if ([item objectForKey:@"name"])
    {
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(25.0f,7.f,_width-20.0f,30.f)];
        NSString *name = [item objectForKey:@"name"];
        
        if ([[item objectForKey:@"comment_type"] isEqual:@"chat"])
        {
            [labelName setText:[NSString stringWithFormat:@"%@: ",name]];
        }
        else
        {
            [labelName setText:[NSString stringWithFormat:@"%@ ",name]];
        }
        
        labelName.backgroundColor = [UIColor clearColor];
        [labelName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0f]];
        [labelName setTextColor:[UIColor colorWithWhite:0.2f alpha:1.0]];
        [labelName sizeToFit];
        [messageView addSubview:labelName];
        
        [labelView setFrame:CGRectMake(25.0f,7, _width-20.0f, 30.0f)];
        NSString *tmp = @"";
        
        while ([tmp sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13.0f]].width < [labelName frame].size.width)
        {
            tmp = [tmp stringByAppendingString:@" "];
        }
        
        if ([[item objectForKey:@"comment_type"] isEqual:@"like"])
            [labelView setText:[NSString stringWithFormat:@"%@%@", tmp, @"likes this."]];
        else
            [labelView setText:[NSString stringWithFormat:@"%@%@", tmp, [item objectForKey:@"comment_message"]]];
    }
    else
    {
        [labelView setFrame:CGRectMake(7.5f,7, _width-20.0f, 15.0f)];
        [labelView setText:[item objectForKey:@"comment_message"]];
        
    }
    
    labelView.backgroundColor = [UIColor clearColor];
    labelView.textColor = [UIColor blackColor];
    labelView.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
    labelView.lineBreakMode = UILineBreakModeWordWrap;
    labelView.numberOfLines = 0;
    if ([[item objectForKey:@"comment_type"] isEqual:@"center"])
    {
        labelView.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0f];
        [labelView setTextAlignment:NSTextAlignmentCenter];
    }
    else
    {
        [labelView sizeToFit];
    }
    [messageView addSubview:labelView];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(5.f, 7.5f, 15.f, 15.f)];
    if ([[item objectForKey:@"comment_type"] isEqual:@"chat"])
        [img setImage:[UIImage imageNamed:@"assets/newsfeed/commentBlurb.png"]];
    else if ([[item objectForKey:@"comment_type"] isEqual:@"want"])
        [img setImage:[UIImage imageNamed:@"assets/newsfeed/commentGo.png"]];
    else if ([[item objectForKey:@"comment_type"] isEqual:@"like"])
        [img setImage:[UIImage imageNamed:@"assets/newsfeed/commentLike.png"]];
    else if ([[item objectForKey:@"comment_type"] isEqual:@"been"])
        [img setImage:[UIImage imageNamed:@"assets/newsfeed/commentBeen.png"]];
    else if ([[item objectForKey:@"comment_type"] isEqual:@"here"])
        [img setImage:[UIImage imageNamed:@"assets/newsfeed/commentHere.png"]];
    [messageView addSubview:img];
    
    CGSize sz = [labelView sizeThatFits:CGSizeMake(_width-20.0f, 1024.0f)];
    [messageView setFrame:CGRectMake(10.0f, 0.0f, _width, 14.0f+sz.height)];
    
    
    return messageView;
}

- (void)addComment:(NSString*)text
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"name"];
    
    if (_comments == nil)
    {
        self._comments = [NSMutableArray array];
    }
    
    NSLog(@"s: %@", _comments);

    [_comments addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"chat", @"comment_type", name, @"name", text,@"comment_message",  nil]];
    
    UIView *bubble = [self getBubbleForContext:[_comments objectAtIndex:[_comments count]-1]];
    CGRect frame = bubble.frame;
    frame.origin.y = _offset;
    bubble.frame = frame;
    _offset = _offset + _padding + frame.size.height;
    [self addSubview:bubble];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _offset);
}


@end