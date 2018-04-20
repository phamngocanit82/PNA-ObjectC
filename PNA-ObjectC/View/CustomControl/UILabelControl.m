@implementation UILabelControl
#pragma mark - Initializer
-(void)awakeFromNib{
    if(self.keyLang!=nil){
        if ([self.keyLang length]>0)
            self.text = [LanguageService language:self.keyLang Text:self.text];
    }
    if(self.drawBorder==YES){
        self.clipsToBounds = YES;
        if(self.borderWidth>0)
            self.layer.borderWidth = self.borderWidth;
        if (!CGColorEqualToColor(self.borderColor.CGColor, [UIColor clearColor].CGColor))
            self.layer.borderColor = self.borderColor.CGColor;
        if(self.cornerRadius>0)
            self.layer.cornerRadius = self.cornerRadius;
    }
    [super awakeFromNib];
}
-(void)drawTextInRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    [super drawTextInRect:rect];
    CGImageRef alphaMask = NULL;
    if (self.drawGradient == TRUE) {
        // Create a mask from the text
        alphaMask = CGBitmapContextCreateImage(context);
        // clear the image
        CGContextClearRect(context, rect);
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0, rect.size.height);
        // invert everything because CoreGraphics works with an inverted coordinate system
        CGContextScaleCTM(context, 1.0, -1.0);
        // Clip the current context to our alphaMask
        CGContextClipToMask(context, rect, alphaMask);
        // Create the gradient with these colors
        CGFloat colors [] = {
            22.0f/255.0f, 107.0f/255.0f, 168.0f/255.0f, 1.0,
            71.0f/255.0f, 160.0f/255.0f, 220.0f/255.0f, 1.0
        };
        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
        CGColorSpaceRelease(baseSpace), baseSpace = NULL;
        
        CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
        CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        // Draw the gradient
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        CGGradientRelease(gradient), gradient = NULL;
        CGContextRestoreGState(context);
        // Clean up because ARC doesnt handle CG
        CGImageRelease(alphaMask);
    }
    if (self.drawOutline == TRUE) {
        // Create a mask from the text (with the gradient)
        alphaMask = CGBitmapContextCreateImage(context);
        // Outline width
        CGContextSetLineWidth(context, 4);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        // Set the drawing method to stroke
        CGContextSetTextDrawingMode(context, kCGTextStroke);
        // Outline color
        self.textColor = [UIColor whiteColor];
        // notice the +1 for the y-coordinate. this is to account for the face that the outline appears to be thicker on top
        [super drawTextInRect:CGRectMake(rect.origin.x, rect.origin.y+1, rect.size.width, rect.size.height)];
        
        // Draw the saved image over the outline
        // and invert everything because CoreGraphics works with an inverted coordinate system
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, rect, alphaMask);
        // Clean up because ARC doesnt handle CG
        CGImageRelease(alphaMask);
    }
}
@end
