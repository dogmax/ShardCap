# ShardCap for WoW version 1.12
Automatically deletes soul shards above a certain amount (default 5).

Incredibly simple and lightweight addon that manages your soulshards for you.

Deletes excess soulshards AFTER you exit combat.

## Install
Unzip, move the "ShardCap" folder into the addons folder. 

# How do I change the shard cap?
Change the first line in "ShardCap.lua".
Relaunch game or type: /console reloadui

### What?? I don't understand:
No need to exit the game. After changes, type: /console reloadui

Open the "ShardCap.lua" in e.g. Notepad and change: 

    shardcap=5;

... To anything you want. 
For example: 

    shardcap=10;

or 

    shardcap=2;

Then save the file. 
Then reload the game or type this in the chat, in-game: /console reloadui
