//
//  FSDebugURLOpenViewController.m
//  FinanceApp
//
//  Created by 叶帆 on 14/11/2016.
//  Copyright © 2016 com.hangzhoucaimi.finance. All rights reserved.
//

#import "FSDebugURLOpenViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <i-Finance-Library/FSSDKGotoUtility.h>


static NSString *const kDebugURLOpenHistory = @"debugURLOpenHistory";
static NSInteger const kPasteAlert = 0;
static NSInteger const kClearAlert = 1;

@interface FSDebugURLOpenViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate, AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic)UISegmentedControl *segment;
@property (strong, nonatomic)UITextField *URLField;
@property (strong, nonatomic)UITableView *URLHistoryTableView;
@property (strong, nonatomic)NSMutableArray *URLHistoryArray;
@property (strong, nonatomic, readonly)UIView *historyTablefooterView;
@property (strong, nonatomic)UIButton *clearHistoryButton;
@property (strong, nonatomic)AVCaptureSession *caputreSession;
@property (strong, nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

@end


@implementation FSDebugURLOpenViewController

@synthesize historyTablefooterView = _historyTablefooterView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadHistory];
    [self setupUI];
    if ([self shouldAskToPaste]) {
        [self askToPaste];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.URLHistoryTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveHistory];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.rightButton.hidden = NO;
    [self switchToHistoryViewFromQRCodeView];
    
    self.segment = ({
        NSArray *items = @[@"UIWebView", @"WKWebView"];
        UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:items];
        segment.selectedSegmentIndex = 0;
        segment;
    });
    [self.navgationView addSubview:self.segment];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navgationView);
        make.centerY.equalTo(self.navgationView).mas_offset(10);
    }];
    
    self.URLField = ({
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
        textField.delegate = self;
        textField.placeholder = @"Type URL Here (e.g., http://wacai.com)";
        textField.backgroundColor = [UIColor whiteColor];
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.returnKeyType = UIReturnKeyGo;
        textField.keyboardType = UIKeyboardTypeURL;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [textField becomeFirstResponder];
        textField;
    });
    [self.view addSubview:self.URLField];
    [self.URLField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    
    
    self.URLHistoryTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.tableFooterView = self.historyTablefooterView;
        tableView;
    });
    [self.view addSubview:self.URLHistoryTableView];
    [self.URLHistoryTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.URLField.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self updateClearHistoryButtonEnabledStatus];
}

- (void)updateClearHistoryButtonEnabledStatus {
    if ([self.URLHistoryArray count] > 0) {
        self.clearHistoryButton.enabled = YES;
    } else {
        self.clearHistoryButton.enabled = NO;
    }
}

#pragma mark - TableView Delegate & Datesource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UITableViewCellStyleDefault";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.URLHistoryArray[[self indexOfURLArrayFromTableViewRow:indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.URLHistoryArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.URLField.text = self.URLHistoryArray[[self indexOfURLArrayFromTableViewRow:indexPath.row]];
    [self.URLField becomeFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"History";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.URLHistoryArray removeObjectAtIndex:[self indexOfURLArrayFromTableViewRow:indexPath.row]];
        [tableView reloadData];
        [self updateClearHistoryButtonEnabledStatus];
    }
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self openURLInTextField];
    return NO;
}

#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == kPasteAlert) {
        if (buttonIndex == 1) {
            self.URLField.text = [self trimmedURLString];
        }
    } else if (alertView.tag == kClearAlert) {
        if (buttonIndex == 1) {
            [self clearAllHistory];
        }
    }
    
    
}

#pragma mark - History Load & Save
- (void)loadHistory {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *historyOnDisk = [userDefaults objectForKey:kDebugURLOpenHistory];
    if (historyOnDisk) {
        [self.URLHistoryArray addObjectsFromArray:historyOnDisk];
    }
}

- (void)saveHistory {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.URLHistoryArray forKey:kDebugURLOpenHistory];
}

#pragma mark - Pasteboard
- (NSString *)trimmedURLString {
    NSString *pasteboardString = [[UIPasteboard generalPasteboard] string];
    return TRIM(pasteboardString);
    
}

- (BOOL)isPasteboardURLVaild {
    if (![self trimmedURLString]) {
        return NO;
    }
    
    if ([[self trimmedURLString] CM_isContain:@"://"]) {
        return YES;
    } else {
        return NO;
    }
    
}

- (BOOL)shouldAskToPaste {
    if ([self isPasteboardURLVaild]) {
        if ([[self trimmedURLString] isEqualToString:TRIM(self.URLField.text)]) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

- (void)askToPaste {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Paste the Following URL?"
                                                        message:[self trimmedURLString]
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
    alertView.tag = kPasteAlert;
    [alertView show];
}

#pragma mark - Actions
- (void)openURLInTextField {
    NSString *URLString = TRIM(self.URLField.text);
    if ([self.URLHistoryArray containsObject:URLString]) {
        [self.URLHistoryArray removeObject:URLString];
    }
    [self.URLHistoryArray addObject:URLString];
    [self updateClearHistoryButtonEnabledStatus];
    
    NSUInteger webviewType = self.segment.selectedSegmentIndex;
    if (webviewType == 0) { // UIWebview
        [FSSDKGotoUtility openURL:URLString from:self];
    } else if (webviewType == 1) { // WKWebview
        // TODO: Open URL with PlanckX(based on WKWebview)
    }
}

- (void)askToClearHistory {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Clear All Browsing History?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
    alertView.tag = kClearAlert;
    [alertView show];
}

- (void)clearAllHistory {
    self.URLHistoryArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.URLHistoryTableView reloadData];
    [self updateClearHistoryButtonEnabledStatus];
}


#pragma mark - QRCode
- (void)onClickQRCodeButton {
    [self requestCameraAuth];
}

- (void)requestCameraAuth {
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authorizationStatus) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler: ^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self startCapture];
                    });
                } else {
                    NSLog(@"%@", @"访问受限");
                }
            }];
            break;
        }
            
        case AVAuthorizationStatusAuthorized: {
            [self startCapture];
            break;
        }
            
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied: {
            NSLog(@"%@", @"访问受限");
            break;
        }
            
        default: {
            break;
        }
    }
}

- (void)startCapture {
    [self switchToQRCodeViewFromHistoryView];
    
    self.caputreSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (deviceInput) {
        [self.caputreSession addInput:deviceInput];
        
        AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [self.caputreSession addOutput:metadataOutput]; // 这行代码要在设置 metadataObjectTypes 前
        metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.caputreSession];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.previewLayer.frame = self.view.frame;
        [self.view.layer insertSublayer:self.previewLayer atIndex:0];
        
        [self.caputreSession startRunning];
    } else {
        self.URLHistoryTableView.hidden = NO;
        [self.URLField becomeFirstResponder];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
    if ([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode]) {
        NSLog(@"QRCode Result:%@", metadataObject.stringValue);
        self.URLField.text = metadataObject.stringValue;
        [self switchToHistoryViewFromQRCodeView];
    }
}

- (void)switchToHistoryViewFromQRCodeView {
    [self.rightButton setImage:[UIImage imageNamed:@"icon_QRCode"] forState:UIControlStateNormal];
    [self.rightButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(onClickQRCodeButton) forControlEvents:UIControlEventTouchUpInside];

    if (self.previewLayer) {
        [self.previewLayer removeFromSuperlayer];
        self.previewLayer = nil;
    }
    
    if (self.caputreSession) {
        [self.caputreSession stopRunning];
        self.caputreSession = nil;
    }
    
    self.URLHistoryTableView.hidden = NO;
    [self.URLField becomeFirstResponder];
}

- (void)switchToQRCodeViewFromHistoryView {
    [self.URLField resignFirstResponder];
    self.URLHistoryTableView.hidden = YES;
    self.URLField.text = @"";
    
    [self.rightButton setImage:[UIImage imageNamed:@"icon_URLList"] forState:UIControlStateNormal];
    [self.rightButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(switchToHistoryViewFromQRCodeView) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark - Getter & Setter
- (NSMutableArray *)URLHistoryArray {
    if (!_URLHistoryArray) {
        _URLHistoryArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _URLHistoryArray;
}

- (UIView *)historyTablefooterView {
    if (!_historyTablefooterView) {
        _historyTablefooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        self.clearHistoryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.clearHistoryButton setTitle:@"Clear All Browsing History" forState:UIControlStateNormal];
        [self.clearHistoryButton addTarget:self action:@selector(askToClearHistory) forControlEvents:UIControlEventTouchUpInside];
        [_historyTablefooterView addSubview:self.clearHistoryButton];
        [self.clearHistoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_historyTablefooterView);
        }];

    }
    return _historyTablefooterView;
}

- (NSUInteger)indexOfURLArrayFromTableViewRow:(NSUInteger)row {
    return self.URLHistoryArray.count - 1 - row;
}
@end
