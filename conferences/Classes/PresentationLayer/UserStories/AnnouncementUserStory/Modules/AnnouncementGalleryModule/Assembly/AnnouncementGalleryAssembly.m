// Copyright (c) 2015 RAMBLER&Co
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AnnouncementGalleryAssembly.h"

#import "ServiceComponents.h"
#import "PonsomizerAssembly.h"
#import "PresentationLayerHelpersAssembly.h"

#import "AnnouncementGalleryViewController.h"
#import "AnnouncementGalleryInteractor.h"
#import "AnnouncementGalleryPresenter.h"
#import "AnnouncementGalleryRouter.h"
#import "FutureEventFilter.h"
#import "AnnouncementGalleryDataDisplayManager.h"
#import "AnnouncementGalleryCellObjectFactory.h"
#import "AnnouncementGalleryPageSizeCalculator.h"
#import "AnnouncementGalleryBackgroundColorAnimator.h"
#import "AnnouncementGalleryCollectionViewFlowLayout.h"

#import <ViperMcFlurry/ViperMcFlurry.h>

@implementation AnnouncementGalleryAssembly

- (AnnouncementGalleryViewController *)viewAnnouncementGalleryModule {
    return [TyphoonDefinition withClass:[AnnouncementGalleryViewController class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterAnnouncementGalleryModule]];
                              [definition injectProperty:@selector(moduleInput)
                                                    with:[self presenterAnnouncementGalleryModule]];
                              [definition injectProperty:@selector(dataDisplayManager)
                                                    with:[self dataDisplayManagerAnnouncementGalleryModule]];
                              [definition injectProperty:@selector(backgroundColorAnimator)
                                                    with:[self announcementGalleryBackgroundColorAnimator]];
                              [definition injectProperty:@selector(collectionViewFlowLayout)
                                                    with:[self flowLayoutAnnouncementGalleryModule]];
                          }];
}

- (AnnouncementGalleryInteractor *)interactorAnnouncementGalleryModule {
    return [TyphoonDefinition withClass:[AnnouncementGalleryInteractor class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterAnnouncementGalleryModule]];
                              [definition injectProperty:@selector(eventService)
                                                    with:[self.serviceComponents eventService]];
                              [definition injectProperty:@selector(ponsomizer)
                                                    with:[self.ponsomizerAssembly ponsomizer]];
                              [definition injectProperty:@selector(futureEventFilter)
                                                    with:[self futureEventFilter]];
                          }];
}

- (AnnouncementGalleryPresenter *)presenterAnnouncementGalleryModule {
    return [TyphoonDefinition withClass:[AnnouncementGalleryPresenter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(view)
                                                    with:[self viewAnnouncementGalleryModule]];
                              [definition injectProperty:@selector(interactor)
                                                    with:[self interactorAnnouncementGalleryModule]];
                              [definition injectProperty:@selector(router)
                                                    with:[self routerAnnouncementGalleryModule]];
                          }];
}

- (AnnouncementGalleryRouter *)routerAnnouncementGalleryModule {
    return [TyphoonDefinition withClass:[AnnouncementGalleryRouter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(transitionHandler)
                                                    with:[self viewAnnouncementGalleryModule]];
                          }];
}

- (FutureEventFilter *)futureEventFilter {
    return [TyphoonDefinition withClass:[FutureEventFilter class]];
}

- (AnnouncementGalleryDataDisplayManager *)dataDisplayManagerAnnouncementGalleryModule {
    return [TyphoonDefinition withClass:[AnnouncementGalleryDataDisplayManager class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(initWithCellObjectFactory:animator:delegate:)
                                              parameters:^(TyphoonMethod *initializer) {
                                                  [initializer injectParameterWith:[self cellObjectFactoryAnnouncementGalleryModule]];
                                                  [initializer injectParameterWith:[self announcementGalleryBackgroundColorAnimator]];
                                                  [initializer injectParameterWith:[self viewAnnouncementGalleryModule]];
                                              }];
                          }];
}

- (AnnouncementGalleryCellObjectFactory *)cellObjectFactoryAnnouncementGalleryModule {
    return [TyphoonDefinition withClass:[AnnouncementGalleryCellObjectFactory class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(dateFormatter)
                                                    with:[self.presentationLayerHelpersAssembly dateFormatter]];
                          }];
}

- (AnnouncementGalleryCollectionViewFlowLayout *)flowLayoutAnnouncementGalleryModule {
    return [TyphoonDefinition withClass:[AnnouncementGalleryCollectionViewFlowLayout class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(calculator)
                                                    with:[self announcementGalleryPageSizeCalculator]];
                          }];
}

- (AnnouncementGalleryBackgroundColorAnimator *)announcementGalleryBackgroundColorAnimator {
    return [TyphoonDefinition withClass:[AnnouncementGalleryBackgroundColorAnimator class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(dataSource)
                                                    with:[self dataDisplayManagerAnnouncementGalleryModule]];
                              [definition injectProperty:@selector(calculator)
                                                    with:[self announcementGalleryPageSizeCalculator]];
                          }];
}

- (AnnouncementGalleryPageSizeCalculator *)announcementGalleryPageSizeCalculator {
    return [TyphoonDefinition withClass:[AnnouncementGalleryPageSizeCalculator class]];
}

@end
