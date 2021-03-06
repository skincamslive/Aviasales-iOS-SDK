//
//  JRInfoPanelView.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRInfoPanelView.h"

#import "JRTicketUtils.h"


static const CGFloat kBuyButtonMaxTopConstraint = 75.0;
static const CGFloat kBuyButtonMinTopConstraint = 25.0;

static const CGFloat kShowOtherAgenciesButtonMaxTopConstraint = 15.0;
static const CGFloat kShowOtherAgenciesButtonMinTopConstraint = -25.0;

static const CGFloat kBuyButtonMinRightConstraint = 30.0;

static const CGFloat kAgencyInfoLabelMinCenterConstraint = 0.0;
static const CGFloat kAgencyInfoLabelMaxCenterConstraint = 15.0;


@interface JRInfoPanelView()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buyButtonTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buyButtonLeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *showOtherAgenciesButtonTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *agencyInfoLabelCenterConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *agencyInfoLabelLeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *agencyInfoLabelLeftContainerConstraint;

@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *agencyInfoLabel;
@property (nonatomic, weak) IBOutlet UIButton *buyButton;

@end


@implementation JRInfoPanelView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.showOtherAgenciesButton setTitle:AVIASALES_(@"JR_TICKET_OTHER_BUTTON") forState:UIControlStateNormal];
    self.showOtherAgenciesButton.layer.borderWidth = 1.0;
    self.showOtherAgenciesButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.showOtherAgenciesButton.layer.cornerRadius = 4.0;

    self.priceLabel.textColor = [UIColor whiteColor];
    self.agencyInfoLabel.textColor = [UIColor whiteColor];

    [self.showOtherAgenciesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self updateContent];
}

#pragma mark Public methods

- (void)setTicket:(JRSDKTicket *)ticket {
    _ticket = ticket;
    
    [self updateContent];
}

- (void)expand {
    [self.layer removeAllAnimations];
    
    self.buyButtonTopConstraint.constant = kBuyButtonMaxTopConstraint;
    self.showOtherAgenciesButtonTopConstraint.constant = kShowOtherAgenciesButtonMaxTopConstraint;
    self.buyButtonLeftConstraint.constant = kBuyButtonMinRightConstraint;
    
    if (self.showOtherAgenciesButton.hidden) {
        [self moveUpAgencyInfoLabel];
    }
    
    self.showOtherAgenciesButton.alpha = 1.0;
    
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self setNeedsLayout];
                         [self layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)collapse {
    [self.layer removeAllAnimations];
    
    self.buyButtonTopConstraint.constant = kBuyButtonMinTopConstraint;
    self.showOtherAgenciesButtonTopConstraint.constant = kShowOtherAgenciesButtonMinTopConstraint;
    self.buyButtonLeftConstraint.constant = kBuyButtonMinRightConstraint + 0.5 * self.bounds.size.width;
    
    if (self.showOtherAgenciesButton.hidden) {
        [self moveDownAgencyInfoLabel];
    }
    
    self.showOtherAgenciesButton.alpha = 0.0;
    
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self setNeedsLayout];
                         [self layoutIfNeeded];
                     }
                     completion:nil];
}

#pragma mark Private methods

- (void)moveUpAgencyInfoLabel {
    self.agencyInfoLabelCenterConstraint.constant = kAgencyInfoLabelMinCenterConstraint;
    self.agencyInfoLabelLeftConstraint.priority = UILayoutPriorityDefaultHigh;
    self.agencyInfoLabelLeftContainerConstraint.priority = UILayoutPriorityDefaultLow;
}

- (void)moveDownAgencyInfoLabel {
    self.agencyInfoLabelCenterConstraint.constant = kAgencyInfoLabelMaxCenterConstraint;
    self.agencyInfoLabelLeftConstraint.priority = UILayoutPriorityDefaultLow;
    self.agencyInfoLabelLeftContainerConstraint.priority = UILayoutPriorityDefaultHigh;
}

- (void)updateContent {
    JRSDKGate *const gate = self.ticket.proposals.firstObject.gate;
    if (gate) {
        self.agencyInfoLabel.text = [NSString stringWithFormat:@"%@ %@", AVIASALES_(@"JR_SEARCH_RESULTS_TICKET_IN_THE"), gate.label];
    } else {
        self.agencyInfoLabel.text = @"";
    }

    self.priceLabel.text = [JRTicketUtils formattedTicketMinPriceInUserCurrency:self.ticket];
    
    NSUInteger proposalsCount = self.ticket.proposals.count;
    BOOL showOtherButton =  proposalsCount > 1;
    
    self.showOtherAgenciesButton.hidden = !showOtherButton;
    
    if (showOtherButton) {
        [self moveDownAgencyInfoLabel];
    } else {
        [self moveUpAgencyInfoLabel];
    }

    [self.buyButton setTitle:AVIASALES_(@"JR_TICKET_BUY_BUTTON").uppercaseString forState:UIControlStateNormal];
}

#pragma mark IBAction methods

- (IBAction)buyBest:(id)sender {
    self.buyHandler();
}

- (IBAction)showOtherAgencies:(id)sender {
    self.showOtherAgencyHandler();
}

@end
