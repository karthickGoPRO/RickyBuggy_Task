# RickyBuggy_Task

This document provides an overview of the key changes and enhancements made to the project throughout its development cycle. Below, each commit has been summarized to detail the changes implemented, their purpose, and their impact on the project.

Commit Summaries

Commit 1: Compilation Issues
	•	Fixed compilation issues by ensuring files were included in the target:
	•	DiContainer: Added to the target.
	•	CharactersListView: Included in the appropriate target.
	•	Resolved a source mismatch issue:
	•	Corrected source type selection to ensure that the CharactersListItemView was using Swift instead of JavaScript.

Commit 2: API Error Fixes
	•	API Error Handling Improvements:
	•	Addressed the FIXME: 1 comment by refactoring the code to accept and display underlying errors properly.
	•	App Transport Security Issue:
	•	Fixed an API error where resources couldn’t be loaded due to App Transport Security policies requiring secure connections.
	•	Network Manager Enhancements:
	•	FIXME: 2 - Refactored to add support for different HTTP properties such as POST, httpBody, and adjustable timeouts.
	•	FIXME: 3 - Added a guard let url = components.url else... statement to ensure URL validation.

Commit 3: Initialization Fixes
	•	Refactoring Initialization:
	•	Fixed issues with initialization not aligning with the project’s specifications. Improved code structure for better readability and maintainability.

Commit 4: Sorting and Action Sheet Enhancements
	•	Sorting Logic:
	•	FIX: 5 - Corrected sorting logic to ensure that downloaded characters were sorted correctly.
	•	Action Sheet Bug Fix:
	•	FIX: 8 - Fixed an issue where the action sheet would only appear once, making it unresponsive after being opened and closed.

Commit 5: Link Tap Functionality
	•	Tapable Links:
	•	FIX: 6 - Made certain links tapable for better user interaction.

Commit 6: Toolbar and Network Request Fixes
	•	Toolbar Glitch Fix:
	•	FIX: 7 - Resolved an issue where the toolbar would glitch upon entering the details view.
	•	Network Request Optimization:
	•	FIX: 13 - Addressed an issue where network requests were being re-triggered when toggling the show/hide list, ensuring correct behavior when fetching data.

Commit 7: Additional UI Fixes
	•	Toolbar Glitch Fix Continued:
	•	FIX: 7 - Enhanced the fix for toolbar glitches in the details view.
	•	Image Cropping and Display Fixes:
	•	FIX: 10 - Adjusted the image display to prevent cropping and ensure a visually appealing layout.
	•	Character Name Display Fix:
	•	FIX: 9 - Fixed the character name display to appear at the top, just below the navigation bar.

Commit 8: Icon and Location Enhancements
	•	Share Icon Update:
	•	FIX: 12 - Changed the share icon to a filled version using SF Symbols and verified functionality.
	•	Location Handling:
	•	FIX: 11 - Fixed location fetching logic to work based on character location IDs.
	•	Main Thread Run Loops:
	•	Added main thread run loop handling to ensure smooth UI updates.

Commit 9: Code Investigation and Refactoring
	•	Capture List:
	•	Investigated and added capture lists to prevent strong reference cycles.
	•	Constants File:
	•	Created a Constants file and migrated all constant values to it for better code maintainability.
	•	Navigation Adjustment:
	•	Removed navigation from the home page and added it to the CharacterItemDetail page, making the link tapable and enabling the entire view to navigate.
	•	View Hierarchy Rearrangement:
	•	Rearranged the view hierarchy for improved stability and customization ease.
	•	Episode Count Addition:
	•	Added an episode count display to the main view for enhanced information presentation.

Commit 10: Disk Caching and Combine Integration
	•	Disk Caching Implementation:
	•	Implemented the storeImageData(_:forKey:) method to save image data to disk with metadata for the creation date.
	•	Caching Mechanism:
	•	Developed a caching mechanism to avoid redundant downloads, improving app performance.
	•	Combine Integration:
	•	Implemented fetchImageData(forKey:networkRequest:) to check cache first, using Combine publishers for reactive data handling.
	•	Expiration Handling:
	•	Added the isImageExpired(forKey:) method to check for cache expiration and automatically remove outdated images after 15 days.
	•	Thread Safety:
	•	Used DispatchQueue to ensure thread safety during concurrent reads and writes.
	•	Memory Efficiency:
	•	Employed disk storage for images to optimize memory usage and maintain high app responsiveness.

Commit 11: Dependency Injection with SwiftInject
	•	Integrated SwiftInject:
	•	Added SwiftInject for dependency injection to simplify and manage dependencies throughout the app.

Commit 12: Testing Improvements
	•	Enhanced Test Cases:
	•	Utilized both XCTest and ViewInspector to improve test coverage and verify the UI and logic more thoroughly.
    •	Increased Code Coverage to 74%
