## KA1N3D GiveUniformScript

**KA1N3D GiveUniformScript** is a straightforward FiveM script that allows players to share their EUP (Emergency Uniform Pack) uniforms with each other. Players can easily send their uniform details to another player, who can then accept and apply the uniform to their character. This feature enhances roleplay by facilitating realistic uniform exchanges among players.

## Features:
- Easily share your character’s EUP uniform with other players.
- Recipients can accept the uniform via a simple command.
- Lightweight and optimized for server performance.
- Supports both clothing and prop sharing for a complete uniform experience.

## Installation Instructions:
1. **Download the GiveUniformScript.**
2. **Drag and drop** the `GiveUniformScript` folder into your FiveM server's `resources` directory.
   - Example: `server-data/resources/GiveUniformScript`
3. Open your `server.cfg` file.
4. Add the following line to ensure the script starts with your server:
   ```
   ensure GiveUniformScript
   ```
5. Restart your server or run the command `refresh` and then `start GiveUniformScript` in the server console.

## Usage:
- Use the command `/giveUniform [Player ID]` to send your uniform to another player.
- The recipient can accept the uniform by using `/acceptUniform`.
- If the recipient decides not to accept, they can use `/denyUniform`.
