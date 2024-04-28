# NiceHoverView

![macOS 13.0](https://img.shields.io/badge/macOS-13.0-brightgreen.svg)

NiceHoverView is an elegant, customizable NSView subclass for macOS that adds smooth hover effects to enhance the interactivity of user interfaces in macOS applications.

## Introduction

https://github.com/WillSuo-Github/NiceHoverView/assets/15070906/b13122c0-2f01-4f6d-b636-c3fa5d7f430b


## Features

- **Customizable Appearance**: Easily adjust colors, radii, and more.
- **Smooth Animations**: Smooth and responsive hover animations.
- **Easy to Integrate**: Minimal setup required to add to your project.

## Installation

Use SMP To integrate NiceHoverView into your macOS project

## Usage

To use NiceHoverView in your application, follow these simple steps:

```swift
import NiceHoverView

class YourCustomView: NiceHoverView {
    override func hoverColor() -> NSColor {
        return NSColor(white: 0, alpha: 0.1)
    }
    
    override func xRadius() -> CGFloat {
        return 20
    }
    
    override func yRadius() -> CGFloat {
        return 20
    }
    
    override func hoverRect() -> NSRect {
        return bounds
    }
}

// Initialize your view and add it to your window or view hierarchy
let customView = YourCustomView()
yourParentView.addSubview(customView)

```

## License

This workflow is open-source and available under the [MIT License](https://rem.mit-license.org/).

## Support and Issues

If you encounter any issues or have questions, please open an issues on this GitHub repository, and we'll be happy to assist you.
