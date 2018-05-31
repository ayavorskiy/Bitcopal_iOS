//
//  GamesViewController.m
//  Bitcopal
//
//  Created by Костюкевич Илья on 27.05.2018.
//  Copyright © 2018 Open Whisper Systems. All rights reserved.
//

#import "GamesViewController.h"
#import "OWSNavigationController.h"
#import "GameWebViewController.h"
#import "AppSettingsViewController.h"

@interface GamesViewController ()

@end

@implementation GamesViewController

/**
 * We always present the settings controller modally, from within an OWSNavigationController
 */
+ (OWSNavigationController *)inModalNavigationController
{
    GamesViewController *viewController = [GamesViewController new];
    OWSNavigationController *navController = [[OWSNavigationController alloc] initWithRootViewController:viewController];
    
    return navController;
}

- (void)loadView
{
    self.tableViewStyle = UITableViewStylePlain;
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    
    OWSAssert([self.navigationController isKindOfClass:[OWSNavigationController class]]);
    
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                  target:self
                                                  action:@selector(dismissWasPressed:)];
    
    self.title = NSLocalizedString(@"SETTINGS_NAV_BAR_TITLE", @"Title for settings activity");
    
    [self updateTableContents];
}

- (void)updateTableContents
{
    OWSTableContents *contents = [OWSTableContents new];
    
    __weak GamesViewController *weakSelf = self;
    
    OWSTableSection *section = [OWSTableSection new];
    section.headerTitle = @"GAMES";
    
    NSDictionary *dictionary = @{@"Movie Slots" : @"https://www.jetbull.com/Casino/Hall/Index/movie-slots",
                                 @"Video Slots" : @"https://www.jetbull.com/Casino/Hall/Index/video-slots",
                                 @"Table Games" : @"https://www.jetbull.com/Casino/Hall/Index/table-games",
                                 @"Classic Slots" : @"https://www.jetbull.com/Casino/Hall/Index/classic-slots",
                                 @"Video Pokers" : @"https://www.jetbull.com/Casino/Hall/Index/video-poker",
                                 @"Scratch Cards" : @"https://www.jetbull.com/Casino/Hall/Index/scratch-cards",
                                 @"Multi-Player" : @"https://www.jetbull.com/Casino/Hall/Index/multi-player",
                                 @"Other Games" : @"https://www.jetbull.com/Casino/Hall/Index/other-games",
                                 @"Video Bingos" : @"https://www.jetbull.com/Casino/Hall/Index/video-bingos",
                                 @"Jackpot Games" : @"https://www.jetbull.com/Casino/Hall/Index/jackpot-games",
                                 @"Popular Games" : @"https://www.jetbull.com/Casino/Hall/Index/popular",
                                 @"Newest Games" : @"https://www.jetbull.com/Casino/Hall/Index/newest",
                                 @"All Games" : @"https://www.jetbull.com/Casino/"};
    
    for (NSString *string in dictionary.allKeys) {
        [section addItem:[OWSTableItem disclosureItemWithText:string
                                                  actionBlock:^{
                                                      GameWebViewController *vc = [GameWebViewController new];
                                                      vc.url = [NSURL URLWithString:[dictionary objectForKey:string]];
                                                      vc.title = string;
                                                      [[self navigationController] pushViewController:vc animated:true];
                                                  }]];
    }
    
    OWSTableSection *sectionSettings = [OWSTableSection new];
    sectionSettings.headerTitle = @"SETTINGS";
    [sectionSettings addItem:[OWSTableItem disclosureItemWithText:@"Profile settings"
                                              actionBlock:^{
                                                  AppSettingsViewController *settings = [AppSettingsViewController new];
                                                  settings.isModal = NO;
                                                  [[self navigationController] pushViewController:settings animated:true];
                                              }]];

    [contents addSection:section];
    [contents addSection:sectionSettings];
    
    self.contents = contents;
}

- (void)dismissWasPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
