# Hand Cricket Game - Flutter + Rive

Remember the golden childhood days when we used to play 'Hand Cricket' ?
This is a simple and interactive Hand Cricket game built using Flutter and Rive animations!

### Gameplay Overview

- Player bats first for up to 6 balls or until OUT.
- Computer bats second under the same rules.
- Real-time 10-second timer per move — fail to act, and you're OUT!
- Smooth animated overlays for events (Sixer, Out, Winning, Defending).
- Fully responsive design — works across all screen sizes.
- Built using Flutter + Rive for stunning animations!

---

https://github.com/user-attachments/assets/2caa321e-7e74-4a09-b9df-bdbdb8002813



### Built With

- Flutter (3.x)
- Rive (hand animation)
- Dart

---

### Project Structure

assets/ ├── images/ │ └── one.png, two.png, three.png, ... six.png ├── overlays/ │ └── batting.png, game_bowl.png, sixer.png, out.png, you_won.png, computer_won.png, draw.png ├── riv/ │ └── hand.riv lib/ └── hand_cricket_game_screen.dart (Main game logic)

---

### Features

- 10-second countdown timer per ball
- Responsive layouts for phones and tablets
- Sixer, OUT, and Game Status overlay animations
- Smooth fade-in and fade-out overlay transitions
- Flutter `Stack` + `LayoutBuilder` based dynamic design
- Rive-based interactive hand animations

---

### Tested Devices

Responsiveness and gameplay tested on:

- Android:
- Pixel 7
- Pixel 3a
- Samsung Galaxy S8+
- Samsung Galaxy S20 Ultra
- Oppo F15
- OnePlus Nord CE4

iOS:

- iPhone XR

- iPhone 12 Pro

- iPhone 14 Pro Max

❗ iPad and larger tablets responsiveness not tested yet.

### Screenshots

|             Batting Screen              |            Sixer Overlay            |                 Game Over                 |
| :-------------------------------------: | :---------------------------------: | :---------------------------------------: |
| ![Batting](assets/overlays/batting.png) | ![Sixer](assets/overlays/sixer.png) | ![Game Over](assets/overlays/you_won.png) |

---

### How to Run and build .apk file

1. Clone this repository
   ```bash
   git clone https://github.com/arpitpathak16/hand_cricket_game
   ```
2. Navigate into the project folder
   ```bash
   cd hand-cricket-game
   ```
3. Install dependencies
   ```bash
   flutter pub get
   ```
4. Run the app
   ```bash
   flutter run
   ```
5. Generate .apk file
   ```bash
   flutter build apk --release
   ```

---

### Build .apk file

1. Install dependencies
   ```bash
   flutter pub get
   ```
2. Run the app
   ```bash
   flutter run
   ```
3. Generate .apk file
   ```bash
   flutter build apk --release
   ```

---

### TODO (Optional Enhancements)

- Add sound effects (bat hit, out, sixer)
- Add leaderboard for high scores
- Add multiple innings support (2 innings per side)

---

### Author

- **Arpit Pathak** – [arpitpathak16](https://github.com/arpitpathak16)

---
