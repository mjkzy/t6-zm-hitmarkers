# BO2 ZM Hitmarkers

# How to insall
- To use only this mod, compile _**_clientids_source.gsc**_ as _**_clientids.gsc**_ and place it in the directory _**maps/mp/gametypes_zm/_clientids.gsc**_

To add this to your own script, copy all the scripts inside _**_clientids_source.gsc_**_ except for the _**init**_ function.
Then, paste the scripts into your own _**.gsc**_ file, then add _**thread init_hitmarkers();**_ into your _**init**_ function.

## Red Hitmarkers (optional)
To enable Red Hitmarkers on zombie death, simply put this in your dedicated config:
```
set redHitmarkers 1
```

Thanks to **mikzy, JezuzLizard,** & **Cahz** for this.
