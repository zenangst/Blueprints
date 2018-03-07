![Blueprints logo](https://github.com/zenangst/Blueprints/blob/master/Images/Blueprints-header.png?raw=true)

<div align="center">

[![CI Status](https://travis-ci.org/zenangst/Blueprints.svg?branch=master)](https://travis-ci.org/zenangst/Blueprints)
[![Version](https://img.shields.io/cocoapods/v/Blueprints.svg?style=flat)](http://cocoadocs.org/docsets/Blueprints)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Code Coverage](https://codecov.io/github/zenangst/Blueprints/coverage.svg?branch=master)
[![License](https://img.shields.io/cocoapods/l/Blueprints.svg?style=flat)](http://cocoadocs.org/docsets/Blueprints)
[![Platform](https://img.shields.io/cocoapods/p/Blueprints.svg?style=flat)](http://cocoadocs.org/docsets/Blueprints)
![Swift](https://img.shields.io/badge/%20in-swift%204.0-orange.svg)

</div>

## Description

<img src="https://github.com/zenangst/Blueprints/blob/master/Images/Blueprints-icon.png?raw=true" alt="Blueprints Icon" align="right" />

Blueprints is a collection of Blueprints layouts that is meant to make your life easier when working with collection view Blueprints layouts. It comes with two built-in layouts that are highly flexible and easy to configure at the call-site. They support properties like items per row and items per column; this will calculate the layout attributes needed for fitting the number of views that you want to appear on the screen.

The framework also provides a good base for your custom implementations. By extending the core Blueprints layout, you get built-in support for animations and layout attribute caching. The bundled default animator supports animations that look very similar to what you get from a vanilla table view. If you want to provide your collection view animator, no problem; you can inject an animator of your choosing when initializing the layout.

## Features

- [x] 🍭Animation support.
- [x] 🤳🏻Optimized for performance
- [x] 📏Built-in vertical and horizontal layouts.
- [x] 📱iOS support.
- [x] 💻macOS support.
- [x] 📺tvOS support.


## How do items per row work?

If you specify how many items per row that you want to appear in a vertical layout, the width of the layout attribute will be calculated for you taking the section inset, item spacing into account to make sure that all views fit your design. For example, if you set that you want two items per row, then two views will appear on the same row side by side. If you want to create a table view layout, you would simply set the items per row value to be one. You can use this variable for horizontal layouts as well, but instead of creating a new row, the value is used to create a width to cover the desired area. If you want the width to span across the entire container then simply set it to one, if you want to create a carousel layout with hinting, setting a value like 1.1 will render at least one complete item and give a visual hint to the user that another view is available if the scroll horizontally.

## How do items per column work?

Items per column are explicitly for horizontal layouts and are used to decide how many items that should be shown on screen but using a vertical axis. If you set it to two, it will display two views, one above and one below and then continue to build the rest of the views horizontally, following the same pattern.

## How does item sizes work?

It works just like a regular Blueprints layout, but with a twist. If you want to provide a static size using the regular item size, you are free to do so. As mentioned above, you can also provide the number of views that you want visible on the screen based on the container views width.
To provide dynamic sizing, you can make your collection view delegate conform to UICollectionViewDelegateBlueprintsLayout or NSCollectionViewDelegateBlueprintsLayout. That way to can compute the values based on the data coming from the data source etc. Worth noting is that using itemsPerRow takes precedence over the other alternatives.

## Usage

### Vertical layout
```swift
let blueprintLayout = VerticalBlueprintLayout(
  itemsPerRow: 1.0,
  itemSize: CGSize(width: 200, height: 60),
  minimumInteritemSpacing: 10,
  sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
)
let collectionView = UICollectionView(frame: .zero,
                                      collectionViewLayout: blueprintLayout)
```

### Horizontal layout
```swift
let blueprintLayout = HorizontalBlueprintLayout(
  itemsPerRow: 1.0,
  itemsPerColumn: 2,
  itemSize: CGSize(width: 200, height: 200),
  minimumInteritemSpacing: 10,
  sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
)
let collectionView = UICollectionView(frame: .zero,
                                      collectionViewLayout: blueprintLayout)
```

## Installation

**Blueprints** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Blueprints'
```

**Blueprints** is also available through [Carthage](https://github.com/Carthage/Carthage).
To install just write into your Cartfile:

```ruby
github "zenangst/Blueprints"
```

**Blueprints** can also be installed manually. Just download and drop `Sources` folders in your project.

## Author

Christoffer Winterkvist, christoffer@winterkvist.com

## Contributing

We would love you to contribute to **Blueprints**, check the [CONTRIBUTING](https://github.com/zenangst/Blueprints/blob/master/CONTRIBUTING.md) file for more info.

## License

**Blueprints** is available under the MIT license. See the [LICENSE](https://github.com/zenangst/Blueprints/blob/master/LICENSE.md) file for more info.
