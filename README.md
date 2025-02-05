# TMDA - The Movie Database App

An iOS application that showcases movies using The Movie Database (TMDB) API.

## Features

- Browse popular movies
- Search for movies
- View movie details
- Watch movie trailers
- View full-screen movie posters

## Technical Stack

- Swift
- UIKit
- Combine
- SnapKit for layout
- Kingfisher for image loading
- SKPhotoBrowser for full-screen images

## Requirements

- iOS 15.0+
- Xcode 15.3+
- Swift Package Manager

## Installation

1. Clone the repository:
2. Open `tmda.xcodeproj` and run the project.
2. Update API configuration:
   - Get your API key from [TMDB](https://www.themoviedb.org/settings/api)
   - Open `APIConfig.swift`
   - Replace `YOUR_API_KEY` with your actual API key

## Architecture

- MVVM architecture
- Protocol-oriented design
- Combine for reactive programming
- Dependency injection
