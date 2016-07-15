//
//  ASTResultsTicketPriceCell.m
//  AviasalesSDKTemplate
//
//  Created by Denis Chaschin on 26.05.16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import <AviasalesSDK/AviasalesSDK.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "ASTResultsTicketPriceCell.h"

static const CGFloat kCellHeight = 43;
static const CGSize kAirlineLogoSize = (CGSize){85, 25};

@interface ASTResultsTicketPriceCell()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (assign, nonatomic) CGSize airlineLogoSize;
@property (strong, nonatomic) NSURL *airlineLogoURL;
@end

@implementation ASTResultsTicketPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    const CGFloat scale = [UIScreen mainScreen].scale;
    self.airlineLogoSize = (CGSize){
        kAirlineLogoSize.width * scale,
        kAirlineLogoSize.height *scale
    };
}

#pragma mark - Getters
+ (NSString *)nibFileName {
    return @"ASTResultsTicketPriceCell";
}

+ (CGFloat)height {
    return kCellHeight;
}

#pragma mark - Setters

- (void)setPrice:(id<JRSDKPrice>)price {
    _price = price;
    self.priceLabel.text = [AviasalesNumberUtil formatPrice:[JRSDKModelUtils priceInUserCurrency:price]];
}

- (void)setAirline:(id<JRSDKAirline>)airline {
    _airline = airline;
    self.airlineLogoURL = [NSURL URLWithString:[JRSDKModelUtils airlineLogoUrlWithIATA:airline.iata size:self.airlineLogoSize]];
}

- (void)setAirlineLogoURL:(NSURL *)airlineLogoURL {
    if ([airlineLogoURL isEqual:_airlineLogoURL]) {
        return;
    }

    _airlineLogoURL = airlineLogoURL;

    if (airlineLogoURL == nil) {
        self.logoView.image = nil;
        return;
    }

    [self.logoView setImage:nil];
    [self.logoView setHidden:YES];

    __weak typeof(self) bself = self;

    [self.logoView sd_setImageWithURL:airlineLogoURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        typeof(self) sSelf = bself;
        if (sSelf == nil) {
            return;
        }
        if (error) {
            if (error.code == 404) {
                MLOG(@"image with url %@ not found", airlineLogoURL.absoluteString);
            } else {
                MLOG(@"unable to load image with url %@ (code %i)", airlineLogoURL.absoluteString, (int)error.code);
            }
        } else if ([sSelf.airlineLogoURL isEqual:airlineLogoURL]) {
            [sSelf.logoView setHidden:NO];
        }
    }];
}
@end
