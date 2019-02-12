#import <XCTest/XCTest.h>
@import Blueprints;

@interface iOStvOSOSObjectiveCSupportTests : XCTestCase

@end

@implementation iOStvOSOSObjectiveCSupportTests


- (void)testVerticalBluePrintLayout {
  VerticalBlueprintLayout *layout = [[VerticalBlueprintLayout alloc] initWithItemsPerRow:1.0
                                                                                height:50
                                                                 minimumInteritemSpacing:20.0
                                                                      minimumLineSpacing:50.0
                                                                            sectionInset:UIEdgeInsetsMake(20, 20, 20, 20)
                                                                           stickyHeaders:true
                                                                           stickyFooters:true
                                                                                animator:nil];
  XCTAssertEqual(layout.minimumInteritemSpacing, 20);
  XCTAssertEqual(layout.minimumLineSpacing, 50);
}

- (void)testHorizontalBluePrintLayout {
  HorizontalBlueprintLayout *layout = [[HorizontalBlueprintLayout alloc] initWithItemsPerRow:1.0
                                                                              itemsPerColumn:1.0
                                                                                    height:50
                                                                     minimumInteritemSpacing:20.0
                                                                          minimumLineSpacing:50.0
                                                                                sectionInset:UIEdgeInsetsMake(20, 20, 20, 20)
                                                                               stickyHeaders:true
                                                                               stickyFooters:true
                                                                                    animator:nil];
  XCTAssertEqual(layout.minimumInteritemSpacing, 20);
  XCTAssertEqual(layout.minimumLineSpacing, 50);
}

- (void)testMosaicBluePrintLayout {
  VerticalMosaicBlueprintLayout *layout = [[VerticalMosaicBlueprintLayout alloc] initWithPatternHeight:50
                                                                               minimumInteritemSpacing:20.0
                                                                                    minimumLineSpacing:50.0
                                                                                          sectionInset:UIEdgeInsetsMake(20, 20, 20, 20)
                                                                                         stickyHeaders:true
                                                                                         stickyFooters:true
                                                                                              animator:nil
                                                                                              patterns:@[]];
  XCTAssertEqual(layout.minimumInteritemSpacing, 20);
  XCTAssertEqual(layout.minimumLineSpacing, 50);
}

@end
