# BO2 ZM Hitmarkers

# How to install
- To use only this mod, compile _**_scoreboard_source.gsc**_ as _**_scoreboard.gsc**_ and place it in the directory _**maps/mp/gametypes_zm/**_

To add this to your own script, copy all the scripts inside _**_scoreboard_source.gsc_**_ except for the _**init**_ function.
Then, paste the scripts into your own _**.gsc**_ file, then add _**thread init_player_hitmarkers();**_ into your _**init**_ function.

## Red Hitmarkers (optional)
To enable Red Hitmarkers on zombie death, simply put this in your dedicated config:
```
set redHitmarkers 1
```

By **mikzy** & **Cahz** for this.
Extra help by **JezuzLizard**.
