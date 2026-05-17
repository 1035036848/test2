# Godot Jump Game

A simple 3D jumping game created with Godot 4.2.

## How to Play

- **Click/Tap**: Jump when on the ground
- **Keyboard**: WASD or Arrow keys to move in the air
- **Touch**: Drag on screen to control direction

## Game Mechanics

- Player is a cube that can jump and control direction mid-air
- Random platforms spawn every 4 seconds
- Screen scrolls down at 3 units per second
- Jump height is approximately 10 units
- Screen width is 30 units

## Project Structure

```
jump_game/
├── project.godot          # Godot project configuration
├── icon.svg              # Project icon
├── scenes/
│   └── main.tscn         # Main game scene
└── scripts/
    ├── main.gd           # Game manager (screen scrolling)
    ├── player.gd         # Player controls and physics
    └── platform_manager.gd # Platform spawning system
```

## Running the Game

1. Open Godot 4.2 or later
2. Import the project folder
3. Click "Run Project" or press F5

## Controls

- **Mouse Click / Touch**: Jump (only when on ground)
- **WASD / Arrow Keys**: Move in XZ plane
- **Screen Drag**: Control movement direction

## Game Over

The game restarts when the player falls below y = -10.
