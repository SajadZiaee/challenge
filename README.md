# Chat Challenge README

## Overview

he project focuses on implementing a single feature—**chatting**—with local data storage. It follows a structured approach with the use of providers for managing the current user and messages. There are two types of messages: **disappearing** and **regular**.
---

## Key Requirements

### 1. **Message Tail for Grouping**
   - **Tail Logic**: Messages at the end of a group (based on the sender and timestamp) display a "tail" to indicate they are the final message of the group.

### 2. **Timestamps**
   - Timestamps are shown for messages, and the time is displayed in a "time ago" format using a helper function.

### 3. **Read Status**
   - Messages from the other user will automatically have their `readTime` updated when the current user switches. This allows the app to keep track of when a message has been read.

### 4. **Animations for Disappearing Messages**
   - Disappearing messages blink for the last 5 seconds before disappearing, with the bubble color toggling between its original color and red.

### 5. **Swipe-to-Delete Gesture**
   - Users can swipe to delete only their own messages. This is achieved using a swipe-to-dismiss gesture recognizer.

### 6. **Scroll Down on New Message**
   - When a new message is sent, the list scrolls down automatically to show the new message at the bottom, ensuring a smooth chat experience.

### 7. **User Switching**
   - Users can toggle between two predefined users, **Sajad** and **Kristen**, and the chat updates accordingly. This feature ensures that the app can handle multiple users efficiently.

### 8. **Scalable Code**
   - **Constants**: Colors, assets, and text styles are all defined in separate files for easy management and scalability.
   - **Clean Architecture**: The project follows Clean Architecture principles, with clear separation of concerns between the UI, domain, and data layers. The logic is decoupled into providers, ensuring a maintainable and testable structure.

### 9. **Memory Safety**
   - The `ListView` widget, by default, performs garbage cleaning and deletes widgets that are far from the current scroll position, ensuring efficient memory usage and preventing UI stuttering.

---

## Some Libraries Used

### 1. **`flutter_riverpod`**
   - A state management library used for managing the state of the current user and messages. It provides a simple and efficient way to manage state without relying on complex patterns.
   
### 2. **`chat_bubbles`**
   - A Flutter package used for displaying message bubbles. It provides a simple way to create customizable chat bubbles with various styles, such as `BubbleSpecialThree`, which was used in this project.

### 3. **`time_ago_helper.dart`**
   - A utility that converts `DateTime` objects into a human-readable "time ago" format, making it easier to display timestamps in a user-friendly way.

---

## Architecture

### Clean Architecture

The project follows **Clean Architecture**, which emphasizes separation of concerns and maintainability. Here’s how the project is structured:

1. **Domain Layer**: Contains the core entities and business logic (e.g., `ChatMessage` and `User`).
2. **Data Layer**: Handles data-related operations (e.g., local storage for messages and users).
3. **Presentation Layer**: Contains the UI code, including screens like the `ChatScreen`, and widgets like `MessageBubbleWidget`.

The data flow is managed by **Riverpod providers**:
- `currentUserProvider` tracks the current user.
- `messageProvider` manages the state of chat messages and handles adding, updating, and deleting messages.

---

## Memory Safety

The **`ListView`** widget is responsible for managing a large number of messages efficiently. It only keeps the messages that are visible on the screen, and it disposes of those that are not in view to conserve memory. This is automatically handled by Flutter’s **viewport-based rendering** and **lazy loading**.

---

## Testing

For running test, you can use
 ``` flutter test test/time_ago_helper_test.dart ```