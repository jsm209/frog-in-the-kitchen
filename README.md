# frog-in-the-kitchen
A silly text based interactive story fiction game about being a frog surviving in a restaurant kitchen in Paris. 

## Technical Summary
- Uses Swift/SwiftUI, features custom UI components like buttons, modals, user input, and animations from scratch without third party libraries.
- Uses MVVM architecture, everything is separated into appropriate viewModels.
- Organized dependency injection with environmental variables for services, allowing them to be only instantiated once and reused.
- Has implementations for both short term caching and long term data persistence. Also takes input from the user so they can manage their game progress data.
- The story content is not hardcoded in the UI but rather stored in an organized JSON structure to be later decoded. In the future the story content can be remotely configured (for example for fixing typos, adding more content) without requiring a full new app version release and deployment.
- Organized all text constants into a constants file for future accessibility and language translation features.
