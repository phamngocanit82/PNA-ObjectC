@implementation CustomButton
#pragma mark - Initializer
-(instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(touchDownButton) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(touchDragOutside) forControlEvents:UIControlEventTouchDragOutside];
    }
    return self;
}
-(void)awakeFromNib{
    [self reDrawing];
    [super awakeFromNib];
}
-(void)clearDrawing{
    self.layer.borderWidth = 0;
    self.layer.cornerRadius = 0;
    self.backgroundColor = [UIColor clearColor];
}
-(void)reDrawing{
    if(self.keyLang!=nil){
        if ([self.keyLang length] > 0)
            [self setTitle:[LanguageService language:self.keyLang Text:self.titleLabel.text] forState:UIControlStateNormal];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = self.cornerRadius;
        if (self.underline == TRUE){
            NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:[LanguageService language:self.keyLang Text:self.titleLabel.text]];
            [tncString addAttribute:NSUnderlineStyleAttributeName
                              value:@(NSUnderlineStyleSingle)
                              range:(NSRange){0,1}];
            [tncString addAttribute:NSUnderlineColorAttributeName value:self.titleLabel.textColor range:NSMakeRange(0, 1)];
            [tncString addAttribute:NSUnderlineStyleAttributeName
                              value:@(NSUnderlineStyleSingle)
                              range:(NSRange){0,[tncString length]}];
            [self setAttributedTitle:tncString forState:UIControlStateNormal];
        }
    }
    if(self.drawBorder==YES){
        self.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        if(self.borderWidth>0)
            self.layer.borderWidth = self.borderWidth;
        if (!CGColorEqualToColor(self.borderColor.CGColor, [UIColor clearColor].CGColor))
            self.layer.borderColor = self.borderColor.CGColor;
        if(self.cornerRadius>0)
            self.layer.cornerRadius = self.cornerRadius;
    }
    if(self.redraw==YES){
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 6;
        self.layer.borderColor = [UIColor colorWithRed:0 green:149/255.f blue:46/255.f alpha:0.9].CGColor;
        self.backgroundColor = [UIColor colorWithRed:0 green:172/255.f blue:52/255.f alpha:0.9];
    }
    if(self.redrawSmall==YES){
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 4;
        self.layer.borderColor = [UIColor colorWithRed:1/255.f green:88/255.f blue:36/255.f alpha:0.9].CGColor;
        self.backgroundColor = [UIColor colorWithRed:3/255.f green:90/255.f blue:37/255.f alpha:0.9];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.titleLabel.frame;
    frame.size.height = self.bounds.size.height;
    frame.origin.y = self.titleEdgeInsets.top;
    self.titleLabel.frame = frame;
}
-(void)touchUpInside{
    [self.superview endEditing:YES];
    if(self.pushGTM){
        if([self.categoryGTM length] > 0 && [self.actionGTM length]>0 && [self.labelGTM length]>0){
            /*if(self.openScreenGTM!=nil)
                [MILUtils pushTA:@{@"event":@"openScreen", @"screenName": self.openScreenGTM}];
            [MILUtils pushTA:@{@"event":@"cta",@"category":self.categoryGTM,@"action":self.actionGTM,@"label":self.labelGTM,@"value":@1}];*/
        }
    }
    if(self.redraw==YES){
        self.layer.borderColor = [UIColor colorWithRed:0 green:149/255.f blue:46/255.f alpha:0.9].CGColor;
        self.backgroundColor = [UIColor colorWithRed:0 green:172/255.f blue:52/255.f alpha:0.9];
    }
    if(self.redrawSmall==YES){
        self.layer.borderColor = [UIColor colorWithRed:1/255.f green:88/255.f blue:36/255.f alpha:0.9].CGColor;
        self.backgroundColor = [UIColor colorWithRed:3/255.f green:90/255.f blue:37/255.f alpha:0.9];
    }
}
-(void)touchDownButton{
    if(self.redraw==YES){
        self.layer.borderColor = [UIColor colorWithRed:0 green:138/255.f blue:13/255.f alpha:0.9].CGColor;
        self.backgroundColor = [UIColor colorWithRed:0 green:145/255.f blue:43/255.f alpha:0.9];
    }
    if(self.redrawSmall==YES){
        self.layer.borderColor = [UIColor colorWithRed:0/255.f green:72/255.f blue:27/255.f alpha:0.9].CGColor;
        self.backgroundColor = [UIColor colorWithRed:1/255.f green:74/255.f blue:29/255.f alpha:0.9];
    }
}
-(void)touchDragOutside{
    if(self.redraw==YES){
        self.layer.borderColor = [UIColor colorWithRed:0 green:149/255.f blue:46/255.f alpha:0.9].CGColor;
        self.backgroundColor = [UIColor colorWithRed:0 green:172/255.f blue:52/255.f alpha:0.9];
    }
    if(self.redrawSmall==YES){
        self.layer.borderColor = [UIColor colorWithRed:1/255.f green:88/255.f blue:36/255.f alpha:0.9].CGColor;
        self.backgroundColor = [UIColor colorWithRed:3/255.f green:90/255.f blue:37/255.f alpha:0.9];
    }
}
-(void)imageWithPath:(NSString*)strPath{
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    //[MILImage imageWithPath:self Path:strPath];
}
-(void)backgroundWithPath:(NSString*)strPath{
    //[MILImage imageWithPath:self Path:strPath];
}
@end
