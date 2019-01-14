#import <XCTest/XCTest.h>
@import Blueprints;

@interface macOSObjectiveCSupportTests : XCTestCase

@end

@implementation macOSObjectiveCSupportTests


- (void)testVerticalBluePrintLayout {
  VerticalBlueprintLayout *layout = [[VerticalBlueprintLayout alloc] initWithItemsPerRow:1.0
                                                                                height:50
                                                                 minimumInteritemSpacing:20.0
                                                                      minimumLineSpacing:50.0
                                                                            sectionInset:NSEdgeInsetsMake(20, 20, 20, 20)
                                                                           stickyHeaders:true
                                                                           stickyFooters:true
                                                                                  animator:[[DefaultLayoutAnimator alloc] initWithAnimation:BlueprintLayoutAnimationAutomatic]];
  XCTAssertEqual(layout.minimumInteritemSpacing, 20);
  XCTAssertEqual(layout.minimumLineSpacing, 50);
}

- (void)testHorizontalBluePrintLayout {
  HorizontalBlueprintLayout *layout = [[HorizontalBlueprintLayout alloc] initWithItemsPerRow:1.0
                                                                              itemsPerColumn:1.0
                                                                                    height:50
                                                                     minimumInteritemSpacing:20.0
                                                                          minimumLineSpacing:50.0
                                                                                sectionInset:NSEdgeInsetsMake(20, 20, 20, 20)
                                                                               stickyHeaders:true
                                                                               stickyFooters:true
                                                                                    animator:[[DefaultLayoutAnimator alloc] initWithAnimation:BlueprintLayoutAnimationAutomatic] ];
  XCTAssertEqual(layout.minimumInteritemSpacing, 20);
  XCTAssertEqual(layout.minimumLineSpacing, 50);
}

@end
