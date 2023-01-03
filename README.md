# NFK 0.62b

Latest available source code of original Need For Kill game.

Game preview: http://www.youtube.com/watch?v=FgvgVttl0zE

More about Need For Kill: http://info.needforkill.ru

## HOWTO COMPILE NFK !? // NFK - FIRST BREAK, The Third Coming (January 18, 2009)
(post from http://needforkill.ru/forum/2-399-1)

So, here's a brief description of how to install and compile the sorts of the NFC.
Helped me to understand all this, to be exact, described the whole process to exile, many thanks to him !

To begin with the requirements:
1. Delphi 7 - the most usual

2. 062B source code itself.

3. PowerDraw package

4. dclsockets70.bpl

5. FastNet.v5.6.3.D5-7.FS shit

6. Delphix D7 Direct X attachments

7. A brain (recommended) and a lot of free time

Well, I guess you already have Delphi 7, it's time to DOWNLOAD THE NFK SOURCES (NFK)

Download NFK.SDK.Lite 62B~64 light version from here: https://github.com/NeedForKillTheGame/nfk062b/releases/download/062b/NFK-SDK-062B.rar
Or just contact me on ICQ and ask for the 40 Megabyte original Pover. (The archive is password protected, not everyone can get the password from the archive)

In general, one way or another, let's assume that somehow you got the password to the archive
and wildly striving to code something in the NFC, but all in good time.

Now download a bunch of PowerDraws, osuday https://github.com/NeedForKillTheGame/nfk062b/releases/download/062b/PowerDraw.zip.

Well, one little dream has come true, we've ALREADY got the sources
and almost ready to start the programming process, but first let's download one more
for our mega brutal project (FastNet.v5.6.3.D5-7.FS): https://github.com/NeedForKillTheGame/nfk062b/releases/download/062b/Hrenovina.rar

And for it, there's also this fudge, no less important than the previous ones: https://github.com/NeedForKillTheGame/nfk062b/releases/download/062b/Delphix_d7.zip

Now it's time for those who smoke, and those who don't smoke, drink tea and bagels

Now that we have everything we need on the screwdriver, let's install it:

1) Open Delphi 7 Menu: Components -> Install Packages -> ADD button
   -> C:\Program Files\Borland\Delphi7\Bin\dclsockets70.bpl

2) Unpack PowerDraw, open PowerDraw24pwr\Source\PowerGrafixD6.dpk, click Install, click Save ALL
   Now, from this PowerDraw24pwr folder, copy all the contents to:
   C:\Program Files\Borland\Delphi7\Lib\

3) Now we unpack that crap Hrenovina.rar, open FastNet.v5.6.3.D5-7.FS\Fastnet\lib\DCLNMF70.dpk,
   Click Install, again click Save ALL, now copy all content of FastNet.v5.6.3.D5-7.FS\Fastnet\lib\ again:
   C:\Program Files\Borland\Delphi7\Lib\

4) And lastly attach DelphiX d7, unzip Dephix_d7.zip,
   In the folder Source run Delphix_for7.dpk, click Install, Save All, the contents of this folder also dumped into
   C:\Program Files\Borland\Delphi7\Lib\

Now everything is fine, you can compile!


And who has already made everything can try their luck in fixing the first bug - the right mouse button and the wheel button
mouse nfc doesn't perceive it... everything else is fine... Experts say the truth is somewhere in DXINPUT...
I have this bug for some reason, maybe others are fine ... TEST !
