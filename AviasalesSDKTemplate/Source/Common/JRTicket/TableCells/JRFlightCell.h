//
//  JRFlightCell.h
//  AviasalesSDKTemplate
//

#import <UIKit/UIKit.h>
#import "JRTicketCellProtocol.h"

@interface JRFlightCell : UITableViewCell <JRTicketCellProtocol>

@property (nonatomic, weak) IBOutlet UILabel *durationLabel;
@property (nonatomic, weak) IBOutlet UIImageView *logoIcon;

@property (nonatomic, weak) IBOutlet UILabel *flightNumberLabel;

@property (nonatomic, weak) IBOutlet UILabel *departureTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *arrivalTimeLabel;

@property (nonatomic, weak) IBOutlet UILabel *departureDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *arrivalDateLabel;

@property (nonatomic, weak) IBOutlet UILabel *originLabel;
@property (nonatomic, weak) IBOutlet UILabel *destinationLabel;

@end
