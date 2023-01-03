# NFK[R2] - development based on NFK 0.62b available sources

Sources taken from this forum thread: http://needforkill.ru/forum/26-424-1

Last release 2011-10-02: https://github.com/NeedForKillTheGame/NFK-R2/releases/download/070dR2/NFK-R2-070d.rar

## Original post dated 2009-08-28, 15:29, by connect

So, the R2 project is moving forward! It's still not 075, but it's far from 062B either. In the first post of this discussion thread, I'll try to gather some basic useful information on the project.

### How R2 differs from 062B (37)
- [+] At the start of the match, the server automatically reads the game type config: (ffa.cfg, team.cfg, ctf.cfg, rail.cfg, trix.cfg, tren.cfg, dom.cfg)
- [+] Added sounds in CTF mode: "red scores", "blue scores", "you has the flag", "your team has the flag", "the enemy has your flag", "red flag returned", "blue flag returned"
- [+] Bans system introduced: banlist, banip, banclient, banuser, unbanip, unbanid, loadbans, savebans
- [+] Added raylight types from 075. r_railstyle 5,6,7
- [+] Added smoke cloud when firing shotgun
- [+] Removed demos from DEMOS menu with ctrl+del key combination
- [+] Added messagemode and messagemode2 modes, as well as messagemode_pos_x and messagemode_pos_y setting commands
- [+] Added direct damage to rockets, grenades, plasma and bfg
- [+] Added spots on walls from plasma, grenades, rockets, bullets, rails. cg_marks 1/0 (in debugging)
- [+] Added swinging items on the map - cg_floatingitems 1/0
- [+] Added sound when teleporting
- [+] Added right and middle mouse buttons
- [+] Added jumping (in debugging)
- [+] Added splash for plasmagun (debugging)
- [+] Added spinning maсhinegun
- [+] Smoothing added
- [+] Music player now understands relative and full paths in playlist
- [+] Added s_print_song command to display music theme name
- [+] Added startup parameter +fs_game and 'fs_game' console command
- [+] Added command 'cg_swapskins' (in debugging)
- [+] Added 'unbind' command
- [+] Added 'mouselook 2' mode for mouse turning
- [v] Teleporter does not decrease player's speed
- [v] Fixed shuffle bug when opening console
- [v] Fixed 'slowed down' consumption of shaft ammo
- [v] Fixed grenade bounce
- [v] Removed splash damage when wearing battlesuit
- [v] Fixed map command bug in autoexec.cfg
- [v] Fixed server crash bug on 6th player login
- [>] Improved autocomplete commands in console
- [>] Improved aiming accuracy
- [>] Renamed mp3volume command to s_musicvolume
- [>] Renamed volume command to s_volume
- [>] Changed main game menu
- [>] Changed console
- [>] Moved ropes to animated ropes from 075
- [>] Shaft ray changed to 075

### Bug list (2)
- Crooked item respawn
- The Excelents are given out for the killed mixed in both friendly and alien.


Translated with www.DeepL.com/Translator (free version)
### Wish List (10+)
- It would be good to make downloading maps from the server.
- A brighter spark from the glove
- Speed up rewind of demos
- Change the nickname spelling from snowflakes to five-pointed stars
- Dedicates server for *nix systems
- Improved network code
- Tracer Bullet
- Mods support
- Packs support (zipped file sets)
- Dynamic loading/unloading of testtours as needed

### Wishlist for balance from Rh
1. Glove - leave it as is.
2. Machinegun:
   2.1. in TDM and other team modes (hereinafter - TDM) damage 3px (1 - in health, 2 - in armor). I think it should just make a MUST, especially with the emergence of the possibility of playing 3na3 and 4na4 and new maps. With mashinganom as it is now it will be stupid meat. This is also when playing 2na2 often happens.
   2.2. in TDM to make the starting amount of ammo 50 (instead of 100) or even less;
   2.3. in DM to take 4xp damage (1 to health, 3 to armor);
   2.4. in all modes remove push from mashgun (at all);
   2.5. Leave the rest of the parameters as they are (rate of fire, etc.).
3. Shotgun - leave it as is.
4. Grenade launcher - in question: ? Reduce splash with his grenade by 10-20%? While leaving the ability of the grenadejumpers at the same level.
5. Rocket - make the damage at direct hit consistently 100px (not 80-100px and especially not 67px - see above in the posts).
   Questionable: ?Reduce HIS splash from enemy and walls by 10 - 20%? While leaving rocketjump capabilities at the same level.
6. Shaft - leave it as is.
7. Rail - leave it as is.
8. Plasma - leave as is (075).
9. In TDM the respawns of all weapons are 30 sec;
10. In DM the respawn of all weapons (except the rail) 20 sec, the rail - 30 sec.
    (Now in all modes, all weapons (except shaft and rail) - 20 sec, the rail - 30 sec, shaft - 40!!! sec.
11. new weapons are not needed (I imagine what Beatnik will say). At least not the NFC (Ku3) classic. Maybe (maybe) in some mod.

### Wishful thinking from coolant^.
1. In tdm damage from machyngan 3hp and in dm 4hp - supported.
2. Push still need to leave in all modes.
3. RL to make 80-100 hp, but do not count from the center and the head - in the head 100hp, 80 in the legs. And Splash still do not touch.
   4 The rest of the same as in 075.
5. Respawn rails and shaft can do for 30 sec (shaft was 40 for a reason, so that 20 sec little), the rest 20.

## ver 070aR2
(2009-11-18 http://pff.clan.su/forum/26-424-34#9132)
- [+] nfk integrated with nfkLive, planet code cut out.
- [+] bot_minplayers 0-8 Makes sure that there is always at least the specified number of players on the server. If less - adds bots.
- [+] Match stats are now sent along with overall stats of each player. (coolant)
- [+] Showick 2
- [>] During warmup in CTF it is now allowed to raise and relocate flags.

## ver 070dR2
(2011-10-02 http://pff.clan.su/forum/26-424-41#10983)
- [>] Reworked fog of war, fixed related bugs
- [+] Added ability to turn on fog of war, dev_fog 1 command
- [+] Added command r_railwidth [0..5], works only with r_railstyle 5-7
- [v] Fixed duplicate chat messages on the client

**Known bugs**
- Hotsite has higher gravity acceleration than multiplayer
- Sometimes rayla beam is not correctly displayed on the client 

