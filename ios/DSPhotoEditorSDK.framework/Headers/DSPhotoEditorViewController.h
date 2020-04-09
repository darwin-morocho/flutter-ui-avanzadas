//
//  DSPhotoEditorViewController.h
//  DSPhotoEditorSDK
//
//  Copyright © 2017 DS Photo Editor. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const int TOOL_FILTER;
extern const int TOOL_FRAME;
extern const int TOOL_ROUND;
extern const int TOOL_EXPOSURE;
extern const int TOOL_CONTRAST;
extern const int TOOL_VIGNETTE;
extern const int TOOL_CROP;
extern const int TOOL_CIRCLE;
extern const int TOOL_ORIENTATION;
extern const int TOOL_SATURATION;
extern const int TOOL_SHARPNESS;
extern const int TOOL_WARMTH;
extern const int TOOL_PIXELATE;
extern const int TOOL_DRAW;
extern const int TOOL_STICKER;
extern const int TOOL_TEXT;

extern const NSString *DS_BACKGROUND_COLOR;
extern const NSString *DS_HEADER_COLOR;
extern const NSString *DS_TEXT_COLOR;

extern const NSString *DS_ICON_FILTER;
extern const NSString *DS_ICON_FRAME;
extern const NSString *DS_ICON_ROUND;
extern const NSString *DS_ICON_EXPOSURE;
extern const NSString *DS_ICON_CONTRAST;
extern const NSString *DS_ICON_VIGNETTE;
extern const NSString *DS_ICON_CROP;
extern const NSString *DS_ICON_CIRCLE;
extern const NSString *DS_ICON_ORIENTATION;
extern const NSString *DS_ICON_SATURATION;
extern const NSString *DS_ICON_SHARPNESS;
extern const NSString *DS_ICON_WARMTH;
extern const NSString *DS_ICON_PIXELATE;
extern const NSString *DS_ICON_DRAW;
extern const NSString *DS_ICON_STICKER;
extern const NSString *DS_ICON_TEXT;

extern const NSString *DS_ICON_APPLY;
extern const NSString *DS_ICON_CANCEL;
extern const NSString *DS_ICON_ORIENTATION_LEFT;
extern const NSString *DS_ICON_ORIENTATION_RIGHT;
extern const NSString *DS_ICON_ORIENTATION_HORIZONTAL;
extern const NSString *DS_ICON_ORIENTATION_VERTICAL;


@protocol DSPhotoEditorViewControllerDelegate;

@interface DSPhotoEditorViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *dsBottomScrollView;
@property (weak, nonatomic) IBOutlet UIView *dsBottomContentView;
@property (weak, nonatomic) IBOutlet UIImageView *dsPhotoEditorImageView;
@property (weak, nonatomic) IBOutlet UIStackView *dsTopStackView;
@property (weak, nonatomic) IBOutlet UILabel *dsTopTitleView;

@property NSDictionary *dsDataBundle;

@property (nonatomic, weak) id<DSPhotoEditorViewControllerDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)original
                  toolsToHide:(NSArray *)toolsToHide;

- (IBAction)dsPhotoEditorCancel:(UIButton *)sender;
- (IBAction)dsPhotoEditorApply:(id)sender;

- (IBAction)dsPhotoEditorFilter:(id)sender;
- (IBAction)dsPhotoEditorFrame:(id)sender;
- (IBAction)dsPhotoEditorRoundCorner:(id)sender;
- (IBAction)dsPhotoEditorExposure:(id)sender;
- (IBAction)dsPhotoEditorContrast:(id)sender;
- (IBAction)dsPhotoEditorVignette:(id)sender;
- (IBAction)dsPhotoEditorCrop:(id)sender;
- (IBAction)dsPhotoEditorCircleCrop:(id)sender;
- (IBAction)dsPhotoEditorOrientation:(id)sender;
- (IBAction)dsPhotoEditorSaturation:(id)sender;
- (IBAction)dsPhotoEditorSharpness:(id)sender;
- (IBAction)dsPhotoEditorWarmth:(id)sender;
- (IBAction)dsPhotoEditorPixelate:(id)sender;
- (IBAction)dsPhotoEditorDraw:(id)sender;
- (IBAction)dsPhotoEditorSticker:(id)sender;
- (IBAction)dsPhotoEditorStickerText:(id)sender;
- (void)initializeSDKSetting;
- (void)setCustomView: (UIView *)dsCustomView;
- (void)setCustomStickers: (NSArray *)dsCustomStickers
                 inBundle: (NSBundle *)bundle;

@end

/**
 Implement this protocol to be notified when the user is done using the editor.
 You are responsible for dismissing the editor when you (and/or your user) are
 finished with it.
 */
@protocol DSPhotoEditorViewControllerDelegate <NSObject>

@required

- (void)dsPhotoEditor:(DSPhotoEditorViewController *)editor finishedWithImage:(UIImage *)image;

- (void)dsPhotoEditorCanceled:(DSPhotoEditorViewController *)editor;

@end
