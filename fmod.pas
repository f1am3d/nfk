{ =============================================================================================== }
{ FMOD Main header file. Copyright (c), FireLight Technologies Pty, Ltd. 1999-2002.               }
{ =============================================================================================== }

unit fmod;

interface

{$IFDEF WIN32}
uses
  Windows;
{$ENDIF}

{ =============================================================================================== }
{ DEFINITIONS                                                                                     }
{ =============================================================================================== }

{
  Force four-byte enums
}
{$Z4}

const
  FMOD_VERSION: Single = 3.6;

{
  FMOD defined types
}

type
  PFSoundSample = Pointer;
  PFSoundStream = Pointer;
  PFSoundDSPUnit = Pointer;
  PFMusicModule = Pointer;

  PFSoundVector = ^TFSoundVector;
  TFSoundVector = record
    x: Single;
    y: Single;
    z: Single;
  end;

  {
    Callback types
  }

  TFSoundStreamCallback   = function (Stream: PFSoundStream; Buff: Pointer; Length, Param: Integer): ByteBool; cdecl;
  TFSoundDSPCallback      = function (OriginalBuffer: Pointer; NewBuffer: Pointer; Length, Param: Integer): Pointer; cdecl;
  TFMusicCallback         = procedure (Module: PFMusicModule; Param: Byte); cdecl;

  TFSoundOpenCallback     = function (Name: PChar): Cardinal; cdecl;
  TFSoundCloseCallback    = procedure (Handle: Cardinal); cdecl;
  TFSoundReadCallback     = function (Buffer: Pointer; Size: Cardinal; Handle: Cardinal): Cardinal; cdecl;
  TFSoundSeekCallback     = procedure (Handle: Cardinal; Pos: Cardinal; Mode: Byte); cdecl;
  TFSoundTellCallback     = function (Handle: Cardinal): Cardinal; cdecl;

  TFSoundAllocCallback    = function(Size: Cardinal): Pointer; cdecl;
  TFSoundReallocCallback  = function(Ptr: Pointer; Size: Cardinal): Pointer; cdecl;
  TFSoundFreeCallback     = procedure(Ptr: Pointer); cdecl;

{
[ENUM]
[
  [DESCRIPTION]
  On failure of commands in FMOD, use FSOUND_GetError to attain what happened.

  [SEE_ALSO]
  FSOUND_GetError
]
}

type
  TFModErrors = (
    FMOD_ERR_NONE,              // No errors
    FMOD_ERR_BUSY,              // Cannot call this command after FSOUND_Init.  Call FSOUND_Close first.
    FMOD_ERR_UNINITIALIZED,     // This command failed because FSOUND_Init was not called
    FMOD_ERR_INIT,              // Error initializing output device.
    FMOD_ERR_ALLOCATED,         // Error initializing output device, but more specifically, the output device is already in use and cannot be reused.
    FMOD_ERR_PLAY,              // Playing the sound failed.
    FMOD_ERR_OUTPUT_FORMAT,     // Soundcard does not support the features needed for this soundsystem (16bit stereo output)
    FMOD_ERR_COOPERATIVELEVEL,  // Error setting cooperative level for hardware.
    FMOD_ERR_CREATEBUFFER,      // Error creating hardware sound buffer.
    FMOD_ERR_FILE_NOTFOUND,     // File not found
    FMOD_ERR_FILE_FORMAT,       // Unknown file format
    FMOD_ERR_FILE_BAD,          // Error loading file
    FMOD_ERR_MEMORY,            // Not enough memory or resources
    FMOD_ERR_VERSION,           // The version number of this file format is not supported
    FMOD_ERR_INVALID_PARAM,     // An invalid parameter was passed to this function
    FMOD_ERR_NO_EAX,            // Tried to use an EAX command on a non EAX enabled channel or output.
    FMOD_ERR_CHANNEL_ALLOC,     // Failed to allocate a new channel
    FMOD_ERR_RECORD,            // Recording is not supported on this machine
    FMOD_ERR_MEDIAPLAYER        // Required Mediaplayer codec is not installed
  );

{
[ENUM]
[
  [DESCRIPTION]
  These output types are used with FSOUND_SetOutput, to choose which output driver to use.

	FSOUND_OUTPUT_DSOUND will not support hardware 3d acceleration if the sound card driver
	does not support DirectX 6 Voice Manager Extensions.

  FSOUND_OUTPUT_WINMM is recommended for NT and CE.

  [SEE_ALSO]
  FSOUND_SetOutput
  FSOUND_GetOutput
]
}

type
  TFSoundOutputTypes = (
    FSOUND_OUTPUT_NOSOUND,  // NoSound driver, all calls to this succeed but do nothing.
    FSOUND_OUTPUT_WINMM,    // Windows Multimedia driver.
    FSOUND_OUTPUT_DSOUND,   // DirectSound driver.  You need this to get EAX2 or EAX3 support, or FX api support.
    FSOUND_OUTPUT_A3D,      // A3D driver.  not supported any more.

    FSOUND_OUTPUT_OSS,      // Linux/Unix OSS (Open Sound System) driver, i.e. the kernel sound drivers.
    FSOUND_OUTPUT_ESD,      // Linux/Unix ESD (Enlightment Sound Daemon) driver.
    FSOUND_OUTPUT_ALSA,     // Linux Alsa driver.

    FSOUND_OUTPUT_ASIO,     // Low latency ASIO driver
    FSOUND_OUTPUT_XBOX,     // Xbox driver
    FSOUND_OUTPUT_PS2,      // PlayStation 2 driver
    FSOUND_OUTPUT_MAC       // Mac SoundMager driver
  );

{
[ENUM]
[
  [DESCRIPTION]
  These mixer types are used with FSOUND_SetMixer, to choose which mixer to use, or to act
  upon for other reasons using FSOUND_GetMixer.
  It is not necessary to set the mixer.  FMOD will autodetect the best mixer for you.

  [SEE_ALSO]
  FSOUND_SetMixer
  FSOUND_GetMixer
]
}
type
  TFSoundMixerTypes = (
    FSOUND_MIXER_AUTODETECT,        // Enables autodetection of the fastest mixer based on your cpu.
    FSOUND_MIXER_BLENDMODE,         // Enables the standard non mmx, blendmode mixer.
    FSOUND_MIXER_MMXP5,             // Enables the mmx, pentium optimized blendmode mixer.
    FSOUND_MIXER_MMXP6,             // Enables the mmx, ppro/p2/p3 optimized mixer.

    FSOUND_MIXER_QUALITY_AUTODETECT,// Enables autodetection of the fastest quality mixer based on your cpu.
    FSOUND_MIXER_QUALITY_FPU,       // Enables the interpolating FPU mixer.
    FSOUND_MIXER_QUALITY_MMXP5,     // Enables the interpolating p5 MMX mixer.
    FSOUND_MIXER_QUALITY_MMXP6,     // Enables the interpolating ppro/p2/p3 MMX mixer.

    FSOUND_MIXER_MONO,              // Windows CE only - MONO non interpolating/low quality mixer. For speed
    FSOUND_MIXER_QUALITY_MONO       // Windows CE only - MONO Interpolating mixer.  For speed
  );

{
[ENUM]
[
  [DESCRIPTION]
  These definitions describe the type of song being played.

  [SEE_ALSO]
  FMUSIC_GetType
]
}
type
  TFMusicTypes = (
    FMUSIC_TYPE_NONE,
    FMUSIC_TYPE_MOD,  // Protracker / FastTracker
    FMUSIC_TYPE_S3M,  // ScreamTracker 3
    FMUSIC_TYPE_XM,   // FastTracker 2
    FMUSIC_TYPE_IT,   // Impulse Tracker
    FMUSIC_TYPE_MIDI  // MIDI file
  );

{
[DEFINE_START]
[
  [NAME]
  FSOUND_DSP_PRIORITIES

  [DESCRIPTION]
  These default priorities are used by FMOD internal system DSP units.  They describe the
  position of the DSP chain, and the order of how audio processing is executed.
  You can actually through the use of FSOUND_DSP_GetxxxUnit (where xxx is the name of the DSP
  unit), disable or even change the priority of a DSP unit.

  [SEE_ALSO]
  FSOUND_DSP_Create
  FSOUND_DSP_SetPriority
  FSOUND_DSP_GetSpectrum
]
}
const
  FSOUND_DSP_DEFAULTPRIORITY_CLEARUNIT        = 0;    // DSP CLEAR unit - done first
  FSOUND_DSP_DEFAULTPRIORITY_SFXUNIT          = 100;  // DSP SFX unit - done second
  FSOUND_DSP_DEFAULTPRIORITY_MUSICUNIT        = 200;  // DSP MUSIC unit - done third
  FSOUND_DSP_DEFAULTPRIORITY_USER             = 300;  // User priority, use this as reference
  FSOUND_DSP_DEFAULTPRIORITY_FFTUNIT          = 900;  // This reads data for FSOUND_DSP_GetSpectrum, so it comes after user units
  FSOUND_DSP_DEFAULTPRIORITY_CLIPANDCOPYUNIT  = 1000; // DSP CLIP AND COPY unit - last
// [DEFINE_END]


{
[DEFINE_START]
[
  [NAME]
  FSOUND_CAPS

  [DESCRIPTION]
  Driver description bitfields. Use FSOUND_Driver_GetCaps to determine if a driver enumerated
  has the settings you are after. The enumerated driver depends on the output mode, see
  FSOUND_OUTPUTTYPES

  [SEE_ALSO]
  FSOUND_GetDriverCaps
  FSOUND_OUTPUTTYPES
]
}
const
  FSOUND_CAPS_HARDWARE              = $1;  // This driver supports hardware accelerated 3d sound.
  FSOUND_CAPS_EAX2                  = $2;  // This driver supports EAX 2 reverb
  FSOUND_CAPS_EAX3                  = $10; // This driver supports EAX 3 reverb
// [DEFINE_END]


{
[DEFINE_START]
[
  [NAME]
  FSOUND_MODES

  [DESCRIPTION]
  Sample description bitfields, OR them together for loading and describing samples.
    NOTE.  If the file format being loaded already has a defined format, such as WAV or MP3, then
    trying to override the pre-defined format with a new set of format flags will not work.  For
    example, an 8 bit WAV file will not load as 16bit if you specify FSOUND_16BITS.  It will just
    ignore the flag and go ahead loading it as 8bits.  For these type of formats the only flags
    you can specify that will really alter the behaviour of how it is loaded, are the following.

    FSOUND_LOOP_OFF
    FSOUND_LOOP_NORMAL
    FSOUND_LOOP_BIDI
    FSOUND_HW3D
    FSOUND_2D
    FSOUND_STREAMABLE
    FSOUND_LOADMEMORY
    FSOUND_LOADRAW
    FSOUND_MPEGACCURATE

    See flag descriptions for what these do.
]
}
const
  FSOUND_LOOP_OFF     = $00000001;  // For non looping samples.
  FSOUND_LOOP_NORMAL  = $00000002;  // For forward looping samples.
  FSOUND_LOOP_BIDI    = $00000004;  // For bidirectional looping samples.  (no effect if in hardware).
  FSOUND_8BITS        = $00000008;  // For 8 bit samples.
  FSOUND_16BITS       = $00000010;  // For 16 bit samples.
  FSOUND_MONO         = $00000020;  // For mono samples.
  FSOUND_STEREO       = $00000040;  // For stereo samples.
  FSOUND_UNSIGNED     = $00000080;  // For user created source data containing unsigned samples.
  FSOUND_SIGNED       = $00000100;  // For user created source data containing signed data.
  FSOUND_DELTA        = $00000200;  // For user created source data stored as delta values.
  FSOUND_IT214        = $00000400;  // For user created source data stored using IT214 compression.
  FSOUND_IT215        = $00000800;  // For user created source data stored using IT215 compression.
  FSOUND_HW3D         = $00001000;  // Attempts to make samples use 3d hardware acceleration. (if the card supports it)
  FSOUND_2D           = $00002000;  // Ignores any 3d processing.  Overrides FSOUND_HW3D.  Located in software.
  FSOUND_STREAMABLE   = $00004000;  // For a streamomg sound where you feed the data to it.  If you dont supply this sound may come out corrupted.  (only affects a3d output)
  FSOUND_LOADMEMORY   = $00008000;  // "name" will be interpreted as a pointer to data for streaming and samples.
  FSOUND_LOADRAW      = $00010000;  // Will ignore file format and treat as raw pcm.
  FSOUND_MPEGACCURATE = $00020000;  // For FSOUND_Stream_OpenFile - for accurate FSOUND_Stream_GetLengthMs/FSOUND_Stream_SetTime.  WARNING, see FSOUND_Stream_OpenFile for inital opening time performance issues.
  FSOUND_FORCEMONO    = $00040000;  // For forcing stereo streams and samples to be mono - needed if using FSOUND_HW3D and stereo data - incurs a small speed hit for streams
  FSOUND_HW2D         = $00080000;  // 2D hardware sounds.  allows hardware specific effects
  FSOUND_ENABLEFX     = $00100000;  // Allows DX8 FX to be played back on a sound.  Requires DirectX 8 - Note these sounds cannot be played more than once, be 8 bit, be less than a certain size, or have a changing frequency
  FSOUND_MPEGHALFRATE = $00200000;  // For FMODCE only - decodes mpeg streams using a lower quality decode, but faster execution
  FSOUND_XADPCM       = $00400000;  // For XBOX only - Describes a user sample that its contents are compressed as XADPCM
  FSOUND_VAG          = $00800000;   // For PS2 only - Describes a user sample that its contents are compressed as Sony VAG format
  FSOUND_NONBLOCKING  = $01000000;   // For FSOUND_Stream_OpenFile - Causes stream to open in the background and not block the foreground app - stream plays only when ready.

const
  FSOUND_NORMAL = (FSOUND_16BITS or FSOUND_SIGNED or FSOUND_MONO);
// [DEFINE_END]


{
[DEFINE_START]
[
  [NAME]
  FSOUND_CDPLAYMODES

  [DESCRIPTION]
  Playback method for a CD Audio track, using FSOUND_CD_Play

  [SEE_ALSO]
  FSOUND_CD_Play
]
}
const
  FSOUND_CD_PLAYCONTINUOUS = 0;   // Starts from the current track and plays to end of CD.
  FSOUND_CD_PLAYONCE = 1;         // Plays the specified track then stops.
  FSOUND_CD_PLAYLOOPED = 2;       // Plays the specified track looped, forever until stopped manually.
  FSOUND_CD_PLAYRANDOM = 3;       // Plays tracks in random order
// [DEFINE_END]


{
[DEFINE_START]
[
  [NAME]
  FSOUND_CHANNELSAMPLEMODE

  [DESCRIPTION]
  Miscellaneous values for FMOD functions.

  [SEE_ALSO]
  FSOUND_PlaySound
  FSOUND_PlaySoundEx
  FSOUND_Sample_Alloc
  FSOUND_Sample_Load
  FSOUND_SetPan
]
}
const
  FSOUND_FREE           = -1;     // value to play on any free channel, or to allocate a sample in a free sample slot.
  FSOUND_UNMANAGED      = -2;     // value to allocate a sample that is NOT managed by FSOUND or placed in a sample slot.
  FSOUND_ALL            = -3;     // for a channel index , this flag will affect ALL channels available! Not supported by every function.
  FSOUND_STEREOPAN      = -1;     // value for FSOUND_SetPan so that stereo sounds are not played at half volume. See FSOUND_SetPan for more on this.
  FSOUND_SYSTEM_CHANNEL = -1000;  // special 'channel' ID for all channel based functions that want to alter the global FSOUND software mixing output
  FSOUND_SYSTEMSAMPLE   = -1000;  // special 'sample' ID for all sample based functions that want to alter the global FSOUND software mixing output sample
// [DEFINE_END]


{
[STRUCT_START]
[
    [NAME]
    FSOUND_REVERB_PROPERTIES

    [DESCRIPTION]
    Structure defining a reverb environment.

    [REMARKS]
    For more indepth descriptions of the reverb properties under win32, please see the EAX2/EAX3
    documentation at http://developer.creative.com/ under the 'downloads' section.
    If they do not have the EAX3 documentation, then most information can be attained from
    the EAX2 documentation, as EAX3 only adds some more parameters and functionality on top of
    EAX2.
    Note the default reverb properties are the same as the FSOUND_PRESET_GENERIC preset.
    Note that integer values that typically range from -10,000 to 1000 are represented in 
    decibels, and are of a logarithmic scale, not linear, wheras float values are typically linear.
    PORTABILITY: Each member has the platform it supports in braces ie (win32/xbox).  
    Some reverb parameters are only supported in win32 and some only on xbox. If all parameters are set then
    the reverb should product a similar effect on either platform.
    Linux and FMODCE do not support the reverb api.

    [SEE_ALSO]
    FSOUND_Reverb_SetProperties
    FSOUND_Reverb_GetProperties
    FSOUND_REVERB_PROPERTYFLAGS
]
}
type
  TFSoundReverbProperties = record          // MIN     MAX    DEFAULT DESCRIPTION
    Environment: Cardinal;                  // 0       25     0       sets all listener properties (win32 only)
    EnvSize: Single;                        // 1.0     100.0  7.5     environment size in meters (win32 only)
    EnvDiffusion: Single;                   // 0.0     1.0    1.0     environment diffusion (win32/xbox)
    Room: Integer;                          // -10000  0      -1000   room effect level (at mid frequencies) (win32/xbox)
    RoomHF: Integer;                        // -10000  0      -100    relative room effect level at high frequencies (win32/xbox)
    RoomLF: Integer;                        // -10000  0      0       relative room effect level at low frequencies (win32 only)
    DecayTime: Single;                      // 0.1     20.0   1.49    reverberation decay time at mid frequencies (win32/xbox)
    DecayHFRatio: Single;                   // 0.1     2.0    0.83    high-frequency to mid-frequency decay time ratio (win32/xbox)
    DecayLFRatio: Single;                   // 0.1     2.0    1.0     low-frequency to mid-frequency decay time ratio (win32 only)
    Reflections: Integer;                   // -10000  1000   -2602   early reflections level relative to room effect (win32/xbox)
    ReflectionsDelay: Single;               // 0.0     0.3    0.007   initial reflection delay time (win32/xbox)
    ReflectionsPan: array [0..2] of Single; //                0,0,0   early reflections panning vector (win32 only)
    Reverb: Integer;                        // -10000  2000   200     late reverberation level relative to room effect (win32/xbox)
    ReverbDelay: Single;                    // 0.0     0.1    0.011   late reverberation delay time relative to initial reflection (win32/xbox)
    ReverbPan: array [0..2] of Single;      //                0,0,0   late reverberation panning vector (win32 only)
    EchoTime: Single;                       // .075    0.25   0.25    echo time (win32 only)
    EchoDepth: Single;                      // 0.0     1.0    0.0     echo depth (win32 only)
    ModulationTime: Single;                 // 0.04    4.0    0.25    modulation time (win32 only)
    ModulationDepth: Single;                // 0.0     1.0    0.0     modulation depth (win32 only)
    AirAbsorptionHF: Single;                // -100    0.0    -5.0    change in level per meter at high frequencies (win32 only)
    HFReference: Single;                    // 1000.0  20000  5000.0  reference high frequency (hz) (win32/xbox)
    LFReference: Single;                    // 20.0    1000.0 250.0   reference low frequency (hz) (win32 only)
    RoomRolloffFactor: Single;              // 0.0     10.0   0.0     like FSOUND_3D_Listener_SetRolloffFactor but for room effect (win32/xbox)
    Diffusion: Single;                      // 0.0     100.0  100.0   Value that controls the echo density in the late reverberation decay. (xbox only)
    Density: Single;                        // 0.0     100.0  100.0   Value that controls the modal density in the late reverberation decay (xbox only)
    Flags: Cardinal;                        // FSOUND_REVERB_PROPERTYFLAGS - modifies the behavior of above properties (win32 only)
  end;
// [STRUCT_END]


{
[DEFINE_START]
[
    [NAME]
    FSOUND_REVERB_FLAGS

    [DESCRIPTION]
    Values for the Flags member of the FSOUND_REVERB_PROPERTIES structure.

    [SEE_ALSO]
    FSOUND_REVERB_PROPERTIES
]
}
const
  FSOUND_REVERBFLAGS_DECAYTIMESCALE         = $00000001;  // EnvironmentSize affects reverberation decay time
  FSOUND_REVERBFLAGS_REFLECTIONSSCALE       = $00000002;  // EnvironmentSize affects reflection level
  FSOUND_REVERBFLAGS_REFLECTIONSDELAYSCALE  = $00000004;  // EnvironmentSize affects initial reflection delay time
  FSOUND_REVERBFLAGS_REVERBSCALE            = $00000008;  // EnvironmentSize affects reflections level
  FSOUND_REVERBFLAGS_REVERBDELAYSCALE       = $00000010;  // EnvironmentSize affects late reverberation delay time
  FSOUND_REVERBFLAGS_DECAYHFLIMIT           = $00000020;  // AirAbsorptionHF affects DecayHFRatio
  FSOUND_REVERBFLAGS_ECHOTIMESCALE          = $00000040;  // EnvironmentSize affects echo time
  FSOUND_REVERBFLAGS_MODULATIONTIMESCALE    = $00000080;  // EnvironmentSize affects modulation time
  FSOUND_REVERB_FLAGS_CORE0                 = $00000100;  // PS2 Only - Reverb is applied to CORE0 (hw voices 0-23)
  FSOUND_REVERB_FLAGS_CORE1                 = $00000200;  // PS2 Only - Reverb is applied to CORE1 (hw voices 24-47)
  FSOUND_REVERBFLAGS_DEFAULT                = FSOUND_REVERBFLAGS_DECAYTIMESCALE or FSOUND_REVERBFLAGS_REFLECTIONSSCALE or
                                              FSOUND_REVERBFLAGS_REFLECTIONSDELAYSCALE or FSOUND_REVERBFLAGS_REVERBSCALE or
                                              FSOUND_REVERBFLAGS_REVERBDELAYSCALE or FSOUND_REVERBFLAGS_DECAYHFLIMIT or
                                              FSOUND_REVERB_FLAGS_CORE0 or FSOUND_REVERB_FLAGS_CORE1;
// [DEFINE_END]


{
[DEFINE_START]
[
    [NAME]
    FSOUND_REVERB_PRESETS

    [DESCRIPTION]
    A set of predefined environment PARAMETERS, created by Creative Labs
    These are used to initialize an FSOUND_REVERB_PROPERTIES structure statically.
    ie 
    FSOUND_REVERB_PROPERTIES prop = FSOUND_PRESET_GENERIC;

    [SEE_ALSO]
    FSOUND_Reverb_SetProperties
]
}
{
const
//                                 Env  Size    Diffus  Room   RoomHF  RmLF DecTm   DecHF  DecLF   Refl  RefDel  RefPan           Revb  RevDel  ReverbPan       EchoTm  EchDp  ModTm  ModDp  AirAbs  HFRef    LFRef  RRlOff Diffus  Densty  FLAGS 
  FSOUND_PRESET_OFF              = 0,	7.5f,	1.00f, -10000, -10000, 0,   1.00f,  1.00f, 1.0f,  -2602, 0.007f, 0.0f,0.0f,0.0f,   200, 0.011f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f,   0.0f,   0.0f, 0x3f ;
  FSOUND_PRESET_GENERIC          = 0,	7.5f,	1.00f, -1000,  -100,   0,   1.49f,  0.83f, 1.0f,  -2602, 0.007f, 0.0f,0.0f,0.0f,   200, 0.011f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f ;
  FSOUND_PRESET_PADDEDCELL       = 1,	1.4f,	1.00f, -1000,  -6000,  0,   0.17f,  0.10f, 1.0f,  -1204, 0.001f, 0.0f,0.0f,0.0f,   207, 0.002f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f ;
  FSOUND_PRESET_ROOM             = 2,	1.9f,	1.00f, -1000,  -454,   0,   0.40f,  0.83f, 1.0f,  -1646, 0.002f, 0.0f,0.0f,0.0f,    53, 0.003f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f ;
  FSOUND_PRESET_BATHROOM         = 3,	1.4f,	1.00f, -1000,  -1200,  0,   1.49f,  0.54f, 1.0f,   -370, 0.007f, 0.0f,0.0f,0.0f,  1030, 0.011f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f,  60.0f, 0x3f ;
  FSOUND_PRESET_LIVINGROOM       = 4,	2.5f,	1.00f, -1000,  -6000,  0,   0.50f,  0.10f, 1.0f,  -1376, 0.003f, 0.0f,0.0f,0.0f, -1104, 0.004f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f ;
  FSOUND_PRESET_STONEROOM        = 5,	11.6f,	1.00f, -1000,  -300,   0,   2.31f,  0.64f, 1.0f,   -711, 0.012f, 0.0f,0.0f,0.0f,    83, 0.017f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f ;
  FSOUND_PRESET_AUDITORIUM       = 6,	21.6f,	1.00f, -1000,  -476,   0,   4.32f,  0.59f, 1.0f,   -789, 0.020f, 0.0f,0.0f,0.0f,  -289, 0.030f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f ;
  FSOUND_PRESET_CONCERTHALL      = 7,	19.6f,	1.00f, -1000,  -500,   0,   3.92f,  0.70f, 1.0f,  -1230, 0.020f, 0.0f,0.0f,0.0f,    -2, 0.029f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f ;
  FSOUND_PRESET_CAVE             = 8,	14.6f,	1.00f, -1000,  0,      0,   2.91f,  1.30f, 1.0f,   -602, 0.015f, 0.0f,0.0f,0.0f,  -302, 0.022f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x1f ;
  FSOUND_PRESET_ARENA            = 9,	36.2f,	1.00f, -1000,  -698,   0,   7.24f,  0.33f, 1.0f,  -1166, 0.020f, 0.0f,0.0f,0.0f,    16, 0.030f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f ;
  FSOUND_PRESET_HANGAR           = 10,	50.3f,	1.00f, -1000,  -1000,  0,   10.05f, 0.23f, 1.0f,   -602, 0.020f, 0.0f,0.0f,0.0f,   198, 0.030f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f ;
  FSOUND_PRESET_CARPETTEDHALLWAY = 11,	1.9f,	1.00f, -1000,  -4000,  0,   0.30f,  0.10f, 1.0f,  -1831, 0.002f, 0.0f,0.0f,0.0f, -1630, 0.030f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f ;
  FSOUND_PRESET_HALLWAY          = 12,	1.8f,	1.00f, -1000,  -300,   0,   1.49f,  0.59f, 1.0f,  -1219, 0.007f, 0.0f,0.0f,0.0f,   441, 0.011f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f ;
  FSOUND_PRESET_STONECORRIDOR    = 13,	13.5f,	1.00f, -1000,  -237,   0,   2.70f,  0.79f, 1.0f,  -1214, 0.013f, 0.0f,0.0f,0.0f,   395, 0.020f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f ;
  FSOUND_PRESET_ALLEY 	         = 14,	7.5f,	0.30f, -1000,  -270,   0,   1.49f,  0.86f, 1.0f,  -1204, 0.007f, 0.0f,0.0f,0.0f,    -4, 0.011f, 0.0f,0.0f,0.0f, 0.125f, 0.95f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f ;
  FSOUND_PRESET_FOREST 	         = 15,	38.0f,	0.30f, -1000,  -3300,  0,   1.49f,  0.54f, 1.0f,  -2560, 0.162f, 0.0f,0.0f,0.0f,  -229, 0.088f, 0.0f,0.0f,0.0f, 0.125f, 1.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f,  79.0f, 100.0f, 0x3f ;
  FSOUND_PRESET_CITY             = 16,	7.5f,	0.50f, -1000,  -800,   0,   1.49f,  0.67f, 1.0f,  -2273, 0.007f, 0.0f,0.0f,0.0f, -1691, 0.011f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f,  50.0f, 100.0f, 0x3f ;
  FSOUND_PRESET_MOUNTAINS        = 17,	100.0f, 0.27f, -1000,  -2500,  0,   1.49f,  0.21f, 1.0f,  -2780, 0.300f, 0.0f,0.0f,0.0f, -1434, 0.100f, 0.0f,0.0f,0.0f, 0.250f, 1.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f,  27.0f, 100.0f, 0x1f ;
  FSOUND_PRESET_QUARRY           = 18,	17.5f,	1.00f, -1000,  -1000,  0,   1.49f,  0.83f, 1.0f, -10000, 0.061f, 0.0f,0.0f,0.0f,   500, 0.025f, 0.0f,0.0f,0.0f, 0.125f, 0.70f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f ;
  FSOUND_PRESET_PLAIN            = 19,	42.5f,	0.21f, -1000,  -2000,  0,   1.49f,  0.50f, 1.0f,  -2466, 0.179f, 0.0f,0.0f,0.0f, -1926, 0.100f, 0.0f,0.0f,0.0f, 0.250f, 1.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f,  21.0f, 100.0f, 0x3f ;
  FSOUND_PRESET_PARKINGLOT       = 20,	8.3f,	1.00f, -1000,  0,      0,   1.65f,  1.50f, 1.0f,  -1363, 0.008f, 0.0f,0.0f,0.0f, -1153, 0.012f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x1f ;
  FSOUND_PRESET_SEWERPIPE        = 21,	1.7f,	0.80f, -1000,  -1000,  0,   2.81f,  0.14f, 1.0f,    429, 0.014f, 0.0f,0.0f,0.0f,  1023, 0.021f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 0.25f, 0.000f, -5.0f, 5000.0f, 250.0f, 0.0f,  80.0f,  60.0f, 0x3f ;
  FSOUND_PRESET_UNDERWATER       = 22,	1.8f,	1.00f, -1000,  -4000,  0,   1.49f,  0.10f, 1.0f,   -449, 0.007f, 0.0f,0.0f,0.0f,  1700, 0.011f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 1.18f, 0.348f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x3f ;

// Non I3DL2 presets 

  FSOUND_PRESET_DRUGGED          = 23,	1.9f,	0.50f, -1000,  0,      0,   8.39f,  1.39f, 1.0f,  -115,  0.002f, 0.0f,0.0f,0.0f,   985, 0.030f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 0.25f, 1.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x1f ;
  FSOUND_PRESET_DIZZY            = 24,	1.8f,	0.60f, -1000,  -400,   0,   17.23f, 0.56f, 1.0f,  -1713, 0.020f, 0.0f,0.0f,0.0f,  -613, 0.030f, 0.0f,0.0f,0.0f, 0.250f, 1.00f, 0.81f, 0.310f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x1f ;
  FSOUND_PRESET_PSYCHOTIC        = 25,	1.0f,	0.50f, -1000,  -151,   0,   7.56f,  0.91f, 1.0f,  -626,  0.020f, 0.0f,0.0f,0.0f,   774, 0.030f, 0.0f,0.0f,0.0f, 0.250f, 0.00f, 4.00f, 1.000f, -5.0f, 5000.0f, 250.0f, 0.0f, 100.0f, 100.0f, 0x1f ;
}
// [DEFINE_END]


{
[STRUCT_START]
[
    [NAME]
    FSOUND_REVERB_CHANNELPROPERTIES

    [DESCRIPTION]
    Structure defining the properties for a reverb source, related to a FSOUND channel.

    [REMARKS]
    For more indepth descriptions of the reverb properties under win32, please see the EAX3
    documentation at http://developer.creative.com/ under the 'downloads' section.
    If they do not have the EAX3 documentation, then most information can be attained from
    the EAX2 documentation, as EAX3 only adds some more parameters and functionality on top of
    EAX2.
    Note the default reverb properties are the same as the FSOUND_PRESET_GENERIC preset.
    Note that integer values that typically range from -10,000 to 1000 are represented in 
    decibels, and are of a logarithmic scale, not linear, wheras float values are typically linear.
    PORTABILITY: Each member has the platform it supports in braces ie (win32/xbox).  
    Some reverb parameters are only supported in win32 and some only on xbox. If all parameters are set then
    the reverb should product a similar effect on either platform.
    Linux and FMODCE do not support the reverb api.

    [SEE_ALSO]
    FSOUND_Reverb_SetChannelProperties
    FSOUND_Reverb_GetChannelProperties
    FSOUND_REVERB_PROPERTYFLAGS
]
}
type
  TFSoundReverbChannelProperties = record   // MIN     MAX    DEFAULT
    Direct: Integer;                        // -10000  1000   0       direct path level (at low and mid frequencies) (win32/xbox)
    DirectHF: Integer;                      // -10000  0      0       relative direct path level at high frequencies (win32/xbox)
    Room: Integer;                          // -10000  1000   0       room effect level (at low and mid frequencies) (win32/xbox)
    RoomHF: Integer;                        // -10000  0      0       relative room effect level at high frequencies (win32/xbox)
    Obstruction: Integer;                   // -10000  0      0       main obstruction control (attenuation at high frequencies)  (win32/xbox)
    ObstructionLFRatio: Single;             // 0.0     1.0    0.0     obstruction low-frequency level re. main control (win32/xbox)
    Occlusion: Integer;                     // -10000  0      0       main occlusion control (attenuation at high frequencies) (win32/xbox)
    OcclusionLFRatio: Single;               // 0.0     1.0    0.25    occlusion low-frequency level re. main control (win32/xbox)
    OcclusionRoomRatio: Single;             // 0.0     10.0   1.5     relative occlusion control for room effect (win32)
    OcclusionDirectRatio: Single;           // 0.0     10.0   1.0     relative occlusion control for direct path (win32)
    Exclusion: Integer;                     // -10000  0      0       main exlusion control (attenuation at high frequencies) (win32)
    ExclusionLFRatio: Single;               // 0.0     1.0    1.0     exclusion low-frequency level re. main control (win32)
    OutsideVolumeHF: Integer;               // -10000  0      0       outside sound cone level at high frequencies (win32)
    DopplerFactor: Single;                  // 0.0     10.0   0.0     like DS3D flDopplerFactor but per source (win32)
    RolloffFactor: Single;                  // 0.0     10.0   0.0     like DS3D flRolloffFactor but per source (win32)
    RoomRolloffFactor: Single;              // 0.0     10.0   0.0     like DS3D flRolloffFactor but for room effect (win32/xbox)
    AirAbsorptionFactor: Single;            // 0.0     10.0   1.0     multiplies AirAbsorptionHF member of FSOUND_REVERB_PROPERTIES (win32)
    Flags: Integer;                         // FSOUND_REVERB_CHANNELFLAGS - modifies the behavior of properties (win32)
  end;
// [STRUCT_END]

{
[DEFINE_START] 
[
    [NAME] 
    FSOUND_REVERB_CHANNELFLAGS
    
    [DESCRIPTION]
    Values for the Flags member of the FSOUND_REVERB_CHANNELPROPERTIES structure.

    [SEE_ALSO]
    FSOUND_REVERB_PROPERTIES
]
}
const
  FSOUND_REVERB_CHANNELFLAGS_DIRECTHFAUTO  = $01;  // Automatic setting of 'Direct'  due to distance from listener
  FSOUND_REVERB_CHANNELFLAGS_ROOMAUTO      = $02;  // Automatic setting of 'Room'  due to distance from listener
  FSOUND_REVERB_CHANNELFLAGS_ROOMHFAUTO    = $04;  // Automatic setting of 'RoomHF' due to distance from listener
  FSOUND_REVERB_CHANNELFLAGS_DEFAULT       = FSOUND_REVERB_CHANNELFLAGS_DIRECTHFAUTO or 
                                             FSOUND_REVERB_CHANNELFLAGS_ROOMAUTO or
                                             FSOUND_REVERB_CHANNELFLAGS_ROOMHFAUTO;
// [DEFINE_END]


{
[DEFINE_START]
[
[ENUM] 
[
	[DESCRIPTION]
    These values are used with FSOUND_FX_Enable to enable DirectX 8 FX for a channel.

	[SEE_ALSO]
    FSOUND_FX_Enable
    FSOUND_FX_SetChorus
    FSOUND_FX_SetCompressor
    FSOUND_FX_SetDistortion
    FSOUND_FX_SetEcho
    FSOUND_FX_SetFlanger
    FSOUND_FX_SetGargle
    FSOUND_FX_SetI3DL2Reverb
    FSOUND_FX_SetParamEQ
    FSOUND_FX_SetWavesReverb
]
}

type
  TFSoundFXModes = (
    FSOUND_FX_CHORUS,
    FSOUND_FX_COMPRESSOR,
    FSOUND_FX_DISTORTION,
    FSOUND_FX_ECHO,
    FSOUND_FX_FLANGER,
    FSOUND_FX_GARGLE,
    FSOUND_FX_I3DL2REVERB,
    FSOUND_FX_PARAMEQ,
    FSOUND_FX_WAVES_REVERB
  );
// [DEFINE_END]


{
[ENUM]
[
	[DESCRIPTION]
	These are speaker types defined for use with the FSOUND_SetSpeakerMode command.

	[SEE_ALSO]
    FSOUND_SetSpeakerMode

    [REMARKS]
    Note - Only reliably works with FSOUND_OUTPUT_DSOUND or FSOUND_OUTPUT_XBOX output modes.  Other output modes will only 
    interpret FSOUND_SPEAKERMODE_MONO and set everything else to be stereo.

    Using either DolbyDigital or DTS will use whatever 5.1 digital mode is available if destination hardware is unsure.
]
}
type
  TFSoundSpeakerModes =
  (
    FSOUND_SPEAKERMODE_DOLBYDIGITAL,  // The audio is played through a speaker arrangement of surround speakers with a subwoofer.
    FSOUND_SPEAKERMODE_HEADPHONES,    // The speakers are headphones.
    FSOUND_SPEAKERMODE_MONO,          // The speakers are monaural.
    FSOUND_SPEAKERMODE_QUAD,          // The speakers are quadraphonic.
    FSOUND_SPEAKERMODE_STEREO,        // The speakers are stereo (default value).
    FSOUND_SPEAKERMODE_SURROUND,      // The speakers are surround sound.
    FSOUND_SPEAKERMODE_DTS            // The audio is played through a speaker arrangement of surround speakers with a subwoofer.
  );
  FSOUND_SPEAKERMODES = TFSoundSpeakerModes;


{
[DEFINE_START]
[
    [NAME] 
    FSOUND_INIT_FLAGS
    
    [DESCRIPTION]   
    Initialization flags.  Use them with FSOUND_Init in the flags parameter to change various behaviour.
    
    FSOUND_INIT_ENABLEOUTPUTFX Is an init mode which enables the FSOUND mixer buffer to be affected by DirectX 8 effects.
    Note that due to limitations of DirectSound, FSOUND_Init may fail if this is enabled because the buffersize is too small.
    This can be fixed with FSOUND_SetBufferSize.  Increase the BufferSize until it works.
    When it is enabled you can use the FSOUND_FX api, and use FSOUND_SYSTEMCHANNEL as the channel id when setting parameters.

    [SEE_ALSO]
    FSOUND_Init
]
}
const
  FSOUND_INIT_USEDEFAULTMIDISYNTH  = $01;  // Causes MIDI playback to force software decoding.
  FSOUND_INIT_GLOBALFOCUS          = $02;  // For DirectSound output - sound is not muted when window is out of focus.
  FSOUND_INIT_ENABLEOUTPUTFX       = $04;  // For DirectSound output - Allows FSOUND_FX api to be used on global software mixer output!
  FSOUND_INIT_ACCURATEVULEVELS     = $08;  // This latency adjusts FSOUND_GetCurrentLevels, but incurs a small cpu and memory hit
  FSOUND_INIT_DISABLE_CORE0_REVERB = $10;  // PS2 only - Disable reverb on CORE 0 to regain SRAM
  FSOUND_INIT_DISABLE_CORE1_REVERB = $20;  // PS2 only - Disable reverb on CORE 1 to regain SRAM

// [DEFINE_END]

//===============================================================================================
// FUNCTION PROTOTYPES
//===============================================================================================

{ ================================== }
{ Initialization / Global functions. }
{ ================================== }

{
  Pre FSOUND_Init functions. These can't be called after FSOUND_Init is
  called (they will fail). They set up FMOD system functionality.
}

function FSOUND_SetOutput(OutputType: TFSoundOutputTypes): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_SetDriver(Driver: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_SetMixer(Mixer: TFSoundMixerTypes): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_SetBufferSize(LenMs: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_SetHWND(Hwnd: THandle): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_SetMinHardwareChannels(Min: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_SetMaxHardwareChannels(Max: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_SetMemorySystem(Pool: Pointer; PoolLen: Integer;
        UserAlloc: TFSoundAllocCallback;
        UserRealloc: TFSoundReallocCallback;
        UserFree: TFSoundFreeCallback): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
{
    Main initialization / closedown functions.
    Note : Use FSOUND_INIT_USEDEFAULTMIDISYNTH with FSOUND_Init for software override 
           with MIDI playback.
         : Use FSOUND_INIT_GLOBALFOCUS with FSOUND_Init to make sound audible no matter 
           which window is in focus. (FSOUND_OUTPUT_DSOUND only)
}

function FSOUND_Init(MixRate: Integer; MaxSoftwareChannels: Integer; Flags: Cardinal): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
procedure FSOUND_Close; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

{
  Runtime system level functions
}

procedure FSOUND_SetSpeakerMode(SpeakerMode: Cardinal); {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
procedure FSOUND_SetSFXMasterVolume(Volume: Integer); {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
procedure FSOUND_SetPanSeperation(PanSep: Single); {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
procedure FSOUND_File_SetCallbacks(
        OpenCallback: TFSoundOpenCallback;
        CloseCallback: TFSoundCloseCallback;
        ReadCallback: TFSoundReadCallback;
        SeekCallback: TFSoundSeekCallback;
        TellCallback: TFSoundTellCallback); {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

{
  System information functions
}

function FSOUND_GetError: TFModErrors; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetVersion: Single; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetOutput: TFSoundOutputTypes; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetOutputHandle: Pointer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetDriver: Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetMixer: TFSoundMixerTypes; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetNumDrivers: Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetDriverName(Id: Integer): PChar; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetDriverCaps(Id: Integer; var Caps: Cardinal): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

function FSOUND_GetOutputRate: Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetMaxChannels: Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetMaxSamples: Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetSFXMasterVolume: Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetNumHardwareChannels: Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetChannelsPlaying: Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetCPUUsage: Single; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
procedure FSOUND_GetMemoryStats(var CurrentAlloced: Cardinal; var MaxAlloced: Cardinal); {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

{ =================================== }
{ Sample management / load functions. }
{ =================================== }

{
  Sample creation and management functions
  Note : Use FSOUND_LOADMEMORY   flag with FSOUND_Sample_Load to load from memory.
         Use FSOUND_LOADRAW      flag with FSOUND_Sample_Load to treat as as raw pcm data.
}

function FSOUND_Sample_Load(Index: Integer; const NameOrData: PChar; Mode: Cardinal; MemLength: Integer): PFSoundSample; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Sample_Alloc(Index: Integer;
  Length: Integer;
  Mode: Cardinal;
  DefFreq: Integer;
  DefVol: Integer;
  DefPan: Integer;
  DefPri: Integer): PFSoundSample; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
procedure FSOUND_Sample_Free(Sptr: PFSoundSample); {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Sample_Upload(Sptr: PFSoundSample; SrcData: Pointer; Mode: Cardinal): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Sample_Lock(Sptr: PFSoundSample;
  Offset: Integer;
  Length: Integer;
  var Ptr1: Pointer;
  var Ptr2: Pointer;
  var Len1: Cardinal;
  var Len2: Cardinal): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Sample_Unlock(Sptr: PFSoundSample;
  Ptr1: Pointer;
  Ptr2: Pointer;
  Len1: Cardinal;
  Len2: Cardinal): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

{
  Sample control functions
}

function FSOUND_Sample_SetMode(Sptr: PFSoundSample; Mode: Cardinal): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Sample_SetLoopPoints(Sptr: PFSoundSample; LoopStart, LoopEnd: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Sample_SetDefaults(Sptr: PFSoundSample; DefFreq, DefVol, DefPan, DefPri: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Sample_SetMinMaxDistance(Sptr: PFSoundSample; Min, Max: Single): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

{
  Sample information functions
}

function FSOUND_Sample_Get(SampNo: Integer): PFSoundSample; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Sample_GetName(Sptr: PFSoundSample): PCHAR; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Sample_GetLength(Sptr: PFSoundSample): Cardinal; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Sample_GetLoopPoints(Sptr: PFSoundSample;
  var LoopStart: Integer; var LoopEnd: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Sample_GetDefaults(Sptr: PFSoundSample;
  var DefFreq: Integer;
  var DefVol: Integer;
  var DefPan: Integer;
  var DefPri: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Sample_GetMode(Sptr: PFSoundSample): Cardinal; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

{ ============================ }
{ Channel control functions.   }
{ ============================ }

{
  Playing and stopping sounds.
  Note : Use FSOUND_FREE as the 'channel' variable, to let FMOD pick a free channel for you.
         Use FSOUND_ALL as the 'channel' variable to control ALL channels with one function call!
}

function FSOUND_PlaySound(Channel: Integer; Sptr: PFSoundSample): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_PlaySoundEx(Channel: Integer; Sptr: PFSoundSample; Dsp: PFSoundDSPUnit; StartPaused: ByteBool): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_StopSound(Channel: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

{
    Functions to control playback of a channel.
    Note : FSOUND_ALL can be used on most of these functions as a channel value.
}

function FSOUND_SetFrequency(Channel: Integer; Freq: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_SetVolume(Channel: Integer; Vol: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_SetVolumeAbsolute(Channel: Integer; Vol: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_SetPan(Channel: Integer; Pan: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_SetSurround(Channel: Integer; Surround: ByteBool): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_SetMute(Channel: Integer; Mute: ByteBool): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_SetPriority(Channel: Integer; Priority: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_SetReserved(Channel: Integer; Reserved: ByteBool): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_SetPaused(Channel: Integer; Paused: ByteBool): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_SetLoopMode(Channel: Integer; LoopMode: Cardinal): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_SetCurrentPosition(Channel: Integer; Offset: Cardinal): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

{
  Channel information functions
}

function FSOUND_IsPlaying(Channel: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetFrequency(Channel: Integer): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetVolume(Channel: Integer): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetPan(Channel: Integer): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetSurround(Channel: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetMute(Channel: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetPriority(Channel: Integer): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetReserved(Channel: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetPaused(Channel: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetLoopMode(Channel: Integer): Cardinal; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetCurrentPosition(Channel: Integer): Cardinal; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetCurrentSample(Channel: Integer): PFSoundSample; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_GetCurrentLevels(Channel: Integer; l, r: PSingle): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};


{
    Functions to control DX8 only effects processing.

    - FX enabled samples can only be played once at a time, not multiple times at once.
    - Sounds have to be created with FSOUND_HW2D or FSOUND_HW3D for this to work.
    - FSOUND_INIT_ENABLEOUTPUTFX can be used to apply hardware effect processing to the
      global mixed output of FMOD's software channels.
    - FSOUND_FX_Enable returns an FX handle that you can use to alter fx parameters.
    - FSOUND_FX_Enable can be called multiple times in a row, even on the same FX type,
      it will return a unique handle for each FX.
    - FSOUND_FX_Enable cannot be called if the sound is playing or locked.
    - FSOUND_FX_Disable must be called to reset/clear the FX from a channel.
}

function FSOUND_FX_Enable(Channel: Integer; Fx: Cardinal): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_FX_Disable(Channel: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};    

function FSOUND_FX_SetChorus(FXId: Integer; WetDryMix, Depth, Feedback, Frequency: Single; Waveform: Integer; Delay: Single; Phase: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_FX_SetCompressor(FXId: Integer; Gain, Attack, Release, Threshold, Ratio, Predelay: Single): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_FX_SetDistortion(FXId: Integer; Gain, Edge, PostEQCenterFrequency, PostEQBandwidth, PreLowpassCutoff: Single): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_FX_SetEcho(FXId: Integer; WetDryMix, Feedback, LeftDelay, RightDelay: Single; PanDelay: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_FX_SetFlanger(FXId: Integer; WetDryMix, Depth, Feedback, Frequency: Single; Waveform: Integer; Delay: Single; Phase: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_FX_SetGargle(FXId, RateHz, WaveShape: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_FX_SetI3DL2Reverb(FXId, Room, RoomHF: Integer; RoomRolloffFactor, DecayTime, DecayHFRatio: Single; Reflections: Integer; ReflectionsDelay: Single; Reverb: Integer; ReverbDelay, Diffusion, Density, HFReference: Single): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_FX_SetParamEQ(FXId: Integer; Center, Bandwidth, Gain: Single): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_FX_SetWavesReverb(FXId: Integer; InGain, ReverbMix, ReverbTime, HighFreqRTRatio: Single): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

{ =================== }
{ 3D sound functions. }
{ =================== }

{
  See also FSOUND_Sample_SetMinMaxDistance (above)
}

procedure FSOUND_3D_Update; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};  // You must call this once a frame
function FSOUND_3D_SetAttributes(Channel: Integer;
  Pos: PFSoundVector;
  Vel: PFSoundVector): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_3D_GetAttributes(Channel: Integer;
  Pos: PFSoundVector;
  Vel: PFSoundVector): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
procedure FSOUND_3D_Listener_SetAttributes(Pos: PFSoundVector;
  Vel: PFSoundVector;
  fx: Single;
  fy: Single;
  fz: Single;
  tx: Single;
  ty: Single;
  tz: Single); {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
procedure FSOUND_3D_Listener_GetAttributes(Pos: PFSoundVector;
  Vel: PFSoundVector;
  fx: PSingle;
  fy: PSingle;
  fz: PSingle;
  tx: PSingle;
  ty: PSingle;
  tz: PSingle); {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
procedure FSOUND_3D_Listener_SetDopplerFactor(Scale: Single); {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
procedure FSOUND_3D_Listener_SetDistanceFactor(Scale: Single); {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
procedure FSOUND_3D_Listener_SetRolloffFactor(Scale: Single); {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

{ ========================= }
{ File Streaming functions. }
{ ========================= }

{
    Note : Use FSOUND_LOADMEMORY   flag with FSOUND_Stream_OpenFile to stream from memory.
           Use FSOUND_LOADRAW      flag with FSOUND_Stream_OpenFile to treat stream as raw pcm data.
           Use FSOUND_MPEGACCURATE flag with FSOUND_Stream_OpenFile to open mpegs in 'accurate mode' for settime/gettime/getlengthms.
           Use FSOUND_FREE as the 'channel' variable, to let FMOD pick a free channel for you.
}

function FSOUND_Stream_OpenFile(const Filename: PChar; Mode: Cardinal;
  MemLength: Integer): PFSoundStream; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Stream_Create(Callback: TFSoundStreamCallback;
  Length: Integer;
  Mode: Cardinal;
  SampleRate: Integer;
  UserData: Integer): PFSoundStream; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Stream_Play(Channel: Integer; Stream: PFSoundStream): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Stream_PlayEx(Channel: Integer; Stream: PFSoundStream; Dsp: PFSoundDSPUnit; StartPaused: ByteBool): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Stream_Stop(Stream: PFSoundStream): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Stream_Close(Stream: PFSoundStream): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Stream_SetEndCallback(Stream: PFSoundStream;
  Callback: TFSoundStreamCallback; UserData: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Stream_SetSynchCallback(Stream: PFSoundStream;
  Callback: TFSoundStreamCallback; UserData: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Stream_GetSample(Stream: PFSoundStream): PFSoundSample; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF}; { Every stream contains a sample to play back on }
function FSOUND_Stream_CreateDSP(Stream: PFSoundStream; Callback: TFSoundDSPCallback;
  Priority: Integer; Param: Integer): PFSoundDSPUnit; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Stream_SetBufferSize(Ms: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Stream_SetPosition(Stream: PFSoundStream; Position: Cardinal): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Stream_GetPosition(Stream: PFSoundStream): Cardinal; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Stream_SetTime(Stream: PFSoundStream; Ms: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Stream_GetTime(Stream: PFSoundStream): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Stream_GetLength(Stream: PFSoundStream): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Stream_GetLengthMs(Stream: PFSoundStream): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

{ =================== }
{ CD audio functions. }
{ =================== }

{
  Note: 0 = first drive
}

function FSOUND_CD_Play(Drive: Byte; Track: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
procedure FSOUND_CD_SetPlayMode(Drive: Byte; Mode: Integer); {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_CD_Stop(Drive: Byte): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_CD_SetPaused(Drive: Byte; Paused: ByteBool): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_CD_SetVolume(Drive: Byte; Volume: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_CD_Eject(Drive: Byte): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

function FSOUND_CD_GetPaused(Drive: Byte): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_CD_GetTrack(Drive: Byte): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_CD_GetNumTracks(Drive: Byte): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_CD_GetVolume(Drive: Byte): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_CD_GetTrackLength(Drive: Byte; Track: Integer): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_CD_GetTrackTime(Drive: Byte): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

{ ============== }
{ DSP functions. }
{ ============== }

{
  DSP Unit control and information functions.
}

function FSOUND_DSP_Create(Callback: TFSoundDSPCallback;
  Priority: Integer; Param: Integer): PFSoundDSPUnit; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
procedure FSOUND_DSP_Free(DSPUnit: PFSoundDSPUnit); {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
procedure FSOUND_DSP_SetPriority(DSPUnit: PFSoundDSPUnit; Priority: Integer); {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_DSP_GetPriority(DSPUnit: PFSoundDSPUnit): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
procedure FSOUND_DSP_SetActive(DSPUnit: PFSoundDSPUnit; Active: ByteBool); {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_DSP_GetActive(DSPUnit: PFSoundDSPUnit): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

{
  Functions to get hold of FSOUND 'system DSP unit' handles.
}

function FSOUND_DSP_GetClearUnit: PFSoundDSPUnit; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_DSP_GetSFXUnit: PFSoundDSPUnit; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_DSP_GetMusicUnit: PFSoundDSPUnit; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_DSP_GetClipAndCopyUnit: PFSoundDSPUnit; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_DSP_GetFFTUnit: PFSoundDSPUnit;

{
  Miscellaneous DSP functions
  Note for the spectrum analysis function to work, you have to enable the FFT DSP unit with
  the following code FSOUND_DSP_SetActive(FSOUND_DSP_GetFFTUnit(), TRUE);
  It is off by default to save cpu usage.
}

function FSOUND_DSP_MixBuffers(DestBuffer: Pointer;
  SrcBuffer: Pointer;
  Len: Integer;
  Freq: Integer;
  Vol: Integer;
  Pan: Integer;
  Mode: Cardinal): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
procedure FSOUND_DSP_ClearMixBuffer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_DSP_GetBufferLength: Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};      { Length of each DSP update }
function FSOUND_DSP_GetBufferLengthTotal: Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF}; { Total buffer length due to FSOUND_SetBufferSize }
function FSOUND_DSP_GetSpectrum: PSingle; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};          { Array of 512 floats - call FSOUND_DSP_SetActive(FSOUND_DSP_GetFFTUnit(), TRUE)) for this to work. }

{ ========================================================================== }
{ Reverb functions. (eax2/3 reverb)  (NOT SUPPORTED IN LINUX/CE)               }
{ ========================================================================== }

{
  See structures above for definitions and information on the reverb parameters.
}

function FSOUND_Reverb_SetProperties(var Prop: TFSoundReverbProperties): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Reverb_GetProperties(var Prop: TFSoundReverbProperties): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Reverb_SetChannelProperties(Channel: Integer; var Prop: TFSoundReverbChannelProperties): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Reverb_GetChannelProperties(Channel: Integer; var Prop: TFSoundReverbChannelProperties): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

{ ================================================ }
{ Recording functions  (NOT SUPPORTED IN LINUX/MAC) }
{ ================================================ }

{
  Recording initialization functions
}

function FSOUND_Record_SetDriver(OutputType: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Record_GetNumDrivers: Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Record_GetDriverName(Id: Integer): PChar; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Record_GetDriver: Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

{
  Recording functionality. Only one recording session will work at a time.
}

function FSOUND_Record_StartSample(Sptr: PFSoundSample; Loop: ByteBool): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Record_Stop: ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FSOUND_Record_GetPosition: Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

{ ============================================================================================= }
{ FMUSIC API (MOD,S3M,XM,IT,MIDI PLAYBACK)                                                      }
{ ============================================================================================= }

{
  Song management / playback functions.
}

function FMUSIC_LoadSong(const Name: PChar): PFMusicModule; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_LoadSongMemory(Data: Pointer; Length: Integer): PFMusicModule; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_FreeSong(Module: PFMusicModule): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_PlaySong(Module: PFMusicModule): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_StopSong(Module: PFMusicModule): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
procedure FMUSIC_StopAllSongs; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

function FMUSIC_SetZxxCallback(Module: PFMusicModule; Callback: TFMusicCallback): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_SetRowCallback(Module: PFMusicModule; Callback: TFMusicCallback; RowStep: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_SetOrderCallback(Module: PFMusicModule; Callback: TFMusicCallback; OrderStep: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_SetInstCallback(Module: PFMusicModule; Callback: TFMusicCallback; Instrument: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

function FMUSIC_SetSample(Module: PFMusicModule; SampNo: Integer; Sptr: PFSoundSample): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_OptimizeChannels(Module: PFMusicModule; MaxChannels: Integer; MinVolume: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

{
  Runtime song functions.
}

function FMUSIC_SetReverb(Reverb: ByteBool): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_SetLooping(Module: PFMusicModule; Looping: ByteBool): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_SetOrder(Module: PFMusicModule; Order: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_SetPaused(Module: PFMusicModule; Pause: ByteBool): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_SetMasterVolume(Module: PFMusicModule; Volume: Integer): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_SetMasterSpeed(Module: PFMusicModule; speed: Single): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_SetPanSeperation(Module: PFMusicModule; PanSep: Single): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

{
  Static song information functions.
}

function FMUSIC_GetName(Module: PFMusicModule): PCHAR; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_GetType(Module: PFMusicModule): TFMusicTypes; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_GetNumOrders(Module: PFMusicModule): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_GetNumPatterns(Module: PFMusicModule): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_GetNumInstruments(Module: PFMusicModule): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_GetNumSamples(Module: PFMusicModule): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_GetNumChannels(Module: PFMusicModule): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_GetSample(Module: PFMusicModule; SampNo: Integer): PFSoundSample; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_GetPatternLength(Module: PFMusicModule; OrderNo: Integer): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

{
  Runtime song information.
}

function FMUSIC_IsFinished(Module: PFMusicModule): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_IsPlaying(Module: PFMusicModule): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_GetMasterVolume(Module: PFMusicModule): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_GetGlobalVolume(Module: PFMusicModule): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_GetOrder(Module: PFMusicModule): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_GetPattern(Module: PFMusicModule): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_GetSpeed(Module: PFMusicModule): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_GetBPM(Module: PFMusicModule): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_GetRow(Module: PFMusicModule): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_GetPaused(Module: PFMusicModule): ByteBool; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_GetTime(Module: PFMusicModule): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};
function FMUSIC_GetRealChannel(Module: PFMusicModule; modchannel: Integer): Integer; {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

implementation

const
{$IFDEF LINUX}
  FMOD_DLL = 'libfmod-3.6.so';
{$ELSE}
  FMOD_DLL = 'basenfk\system\fmod.dll';
{$ENDIF}

function FSOUND_SetOutput; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetOutput@4' {$ENDIF};
function FSOUND_SetDriver; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetDriver@4' {$ENDIF};
function FSOUND_SetMixer; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetMixer@4' {$ENDIF};
function FSOUND_SetBufferSize; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetBufferSize@4' {$ENDIF};
function FSOUND_SetHWND; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetHWND@4' {$ENDIF};
function FSOUND_SetMinHardwareChannels; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetMinHardwareChannels@4' {$ENDIF};
function FSOUND_SetMaxHardwareChannels; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetMaxHardwareChannels@4' {$ENDIF};
function FSOUND_SetMemorySystem; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetMemorySystem@20' {$ENDIF};
function FSOUND_Init; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Init@12' {$ENDIF};
procedure FSOUND_Close; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Close@0' {$ENDIF};
procedure FSOUND_SetSFXMasterVolume; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetSFXMasterVolume@4' {$ENDIF};
procedure FSOUND_SetPanSeperation; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetPanSeperation@4' {$ENDIF};
procedure FSOUND_SetSpeakerMode; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetSpeakerMode@4' {$ENDIF};
function FSOUND_GetError; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetError@0' {$ENDIF};
function FSOUND_GetVersion; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetVersion@0' {$ENDIF};
function FSOUND_GetOutput; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetOutput@0' {$ENDIF};
function FSOUND_GetOutputHandle; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetOutputHandle@0' {$ENDIF};
function FSOUND_GetDriver; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetDriver@0' {$ENDIF};
function FSOUND_GetMixer; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetMixer@0' {$ENDIF};
function FSOUND_GetNumDrivers; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetNumDrivers@0' {$ENDIF};
function FSOUND_GetDriverName; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetDriverName@4' {$ENDIF};
function FSOUND_GetDriverCaps; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetDriverCaps@8' {$ENDIF};
function FSOUND_GetOutputRate; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetOutputRate@0' {$ENDIF};
function FSOUND_GetMaxChannels; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetMaxChannels@0' {$ENDIF};
function FSOUND_GetMaxSamples; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetMaxSamples@0' {$ENDIF};
function FSOUND_GetSFXMasterVolume; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetSFXMasterVolume@0' {$ENDIF};
function FSOUND_GetNumHardwareChannels; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetNumHardwareChannels@0' {$ENDIF};
function FSOUND_GetChannelsPlaying; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetChannelsPlaying@0' {$ENDIF};
function FSOUND_GetCPUUsage; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetCPUUsage@0' {$ENDIF};
procedure FSOUND_GetMemoryStats; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetMemoryStats@8' {$ENDIF};
function FSOUND_Sample_Load; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Sample_Load@16' {$ENDIF};
function FSOUND_Sample_Alloc; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Sample_Alloc@28' {$ENDIF};
procedure FSOUND_Sample_Free; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Sample_Free@4' {$ENDIF};
function FSOUND_Sample_Upload; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Sample_Upload@12' {$ENDIF};
function FSOUND_Sample_Lock; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Sample_Lock@28' {$ENDIF};
function FSOUND_Sample_Unlock; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Sample_Unlock@20' {$ENDIF};
function FSOUND_Sample_SetMode; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Sample_SetMode@8' {$ENDIF};
function FSOUND_Sample_SetLoopPoints; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Sample_SetLoopPoints@12' {$ENDIF};
function FSOUND_Sample_SetDefaults; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Sample_SetDefaults@20' {$ENDIF};
function FSOUND_Sample_SetMinMaxDistance; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Sample_SetMinMaxDistance@12' {$ENDIF};
function FSOUND_Sample_Get; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Sample_Get@4' {$ENDIF};
function FSOUND_Sample_GetName; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Sample_GetName@4' {$ENDIF};
function FSOUND_Sample_GetLength; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Sample_GetLength@4' {$ENDIF};
function FSOUND_Sample_GetLoopPoints; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Sample_GetLoopPoints@12' {$ENDIF};
function FSOUND_Sample_GetDefaults; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Sample_GetDefaults@20' {$ENDIF};
function FSOUND_Sample_GetMode; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Sample_GetMode@4' {$ENDIF};
function FSOUND_PlaySound; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_PlaySound@8' {$ENDIF};
function FSOUND_PlaySoundEx; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_PlaySoundEx@16' {$ENDIF};
function FSOUND_StopSound; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_StopSound@4' {$ENDIF};
function FSOUND_SetFrequency; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetFrequency@8' {$ENDIF};
function FSOUND_SetVolume; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetVolume@8' {$ENDIF};
function FSOUND_SetVolumeAbsolute; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetVolumeAbsolute@8' {$ENDIF};
function FSOUND_SetPan; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetPan@8' {$ENDIF};
function FSOUND_SetSurround; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetSurround@8' {$ENDIF};
function FSOUND_SetMute; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetMute@8' {$ENDIF};
function FSOUND_SetPriority; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetPriority@8' {$ENDIF};
function FSOUND_SetReserved; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetReserved@8' {$ENDIF};
function FSOUND_SetPaused; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetPaused@8' {$ENDIF};
function FSOUND_SetLoopMode; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetLoopMode@8' {$ENDIF};
function FSOUND_IsPlaying; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_IsPlaying@4' {$ENDIF};
function FSOUND_GetFrequency; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetFrequency@4' {$ENDIF};
function FSOUND_GetVolume; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetVolume@4' {$ENDIF};
function FSOUND_GetPan; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetPan@4' {$ENDIF};
function FSOUND_GetSurround; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetSurround@4' {$ENDIF};
function FSOUND_GetMute; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetMute@4' {$ENDIF};
function FSOUND_GetPriority; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetPriority@4' {$ENDIF};
function FSOUND_GetReserved; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetReserved@4' {$ENDIF};
function FSOUND_GetPaused; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetPaused@4' {$ENDIF};
function FSOUND_GetLoopMode; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetLoopMode@4' {$ENDIF};
function FSOUND_GetCurrentPosition; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetCurrentPosition@4' {$ENDIF};
function FSOUND_SetCurrentPosition; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_SetCurrentPosition@8' {$ENDIF};
function FSOUND_GetCurrentSample; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetCurrentSample@4' {$ENDIF};
function FSOUND_GetCurrentLevels; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_GetCurrentLevels@12' {$ENDIF};
function FSOUND_FX_Enable; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_FX_Enable@8' {$ENDIF};
function FSOUND_FX_Disable; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_FX_Disable@4' {$ENDIF};
function FSOUND_FX_SetChorus; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_FX_SetChorus@32' {$ENDIF};
function FSOUND_FX_SetCompressor; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_FX_SetCompressor@28' {$ENDIF};
function FSOUND_FX_SetDistortion; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_FX_SetDistortion@24' {$ENDIF};
function FSOUND_FX_SetEcho; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_FX_SetEcho@24' {$ENDIF};
function FSOUND_FX_SetFlanger; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_FX_SetFlanger@32' {$ENDIF};
function FSOUND_FX_SetGargle; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_FX_SetGargle@12' {$ENDIF};
function FSOUND_FX_SetI3DL2Reverb; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_FX_SetI3DL2Reverb@52' {$ENDIF};
function FSOUND_FX_SetParamEQ; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_FX_SetParamEQ@16' {$ENDIF};
function FSOUND_FX_SetWavesReverb; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_FX_SetWavesReverb@20' {$ENDIF};
procedure FSOUND_3D_Update; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_3D_Update@0' {$ENDIF};
function FSOUND_3D_SetAttributes; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_3D_SetAttributes@12' {$ENDIF};
function FSOUND_3D_GetAttributes; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_3D_GetAttributes@12' {$ENDIF};
procedure FSOUND_3D_Listener_SetAttributes; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_3D_Listener_SetAttributes@32' {$ENDIF};
procedure FSOUND_3D_Listener_GetAttributes; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_3D_Listener_GetAttributes@32' {$ENDIF};
procedure FSOUND_3D_Listener_SetDopplerFactor; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_3D_Listener_SetDopplerFactor@4' {$ENDIF};
procedure FSOUND_3D_Listener_SetDistanceFactor; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_3D_Listener_SetDistanceFactor@4' {$ENDIF};
procedure FSOUND_3D_Listener_SetRolloffFactor; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_3D_Listener_SetRolloffFactor@4' {$ENDIF};
function FSOUND_Stream_OpenFile; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Stream_OpenFile@12' {$ENDIF};
function FSOUND_Stream_Create; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Stream_Create@20' {$ENDIF};
function FSOUND_Stream_Play; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Stream_Play@8' {$ENDIF};
function FSOUND_Stream_PlayEx; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Stream_PlayEx@16' {$ENDIF};
function FSOUND_Stream_Stop; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Stream_Stop@4' {$ENDIF};
function FSOUND_Stream_Close; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Stream_Close@4' {$ENDIF};
function FSOUND_Stream_SetEndCallback; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Stream_SetEndCallback@12' {$ENDIF};
function FSOUND_Stream_SetSynchCallback; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Stream_SetSynchCallback@12' {$ENDIF};
function FSOUND_Stream_GetSample; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Stream_GetSample@4' {$ENDIF};
function FSOUND_Stream_CreateDSP; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Stream_CreateDSP@16' {$ENDIF};
function FSOUND_Stream_SetBufferSize; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Stream_SetBufferSize@4' {$ENDIF};
function FSOUND_Stream_SetPosition; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Stream_SetPosition@8' {$ENDIF};
function FSOUND_Stream_GetPosition; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Stream_GetPosition@4' {$ENDIF};
function FSOUND_Stream_SetTime; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Stream_SetTime@8' {$ENDIF};
function FSOUND_Stream_GetTime; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Stream_GetTime@4' {$ENDIF};
function FSOUND_Stream_GetLength; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Stream_GetLength@4' {$ENDIF};
function FSOUND_Stream_GetLengthMs; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Stream_GetLengthMs@4' {$ENDIF};
function FSOUND_CD_Play; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_CD_Play@8' {$ENDIF};
procedure FSOUND_CD_SetPlayMode; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_CD_SetPlayMode@8' {$ENDIF};
function FSOUND_CD_Stop; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_CD_Stop@4' {$ENDIF};
function FSOUND_CD_SetPaused; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_CD_SetPaused@8' {$ENDIF};
function FSOUND_CD_SetVolume; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_CD_SetVolume@8' {$ENDIF};
function FSOUND_CD_Eject; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_CD_Eject@4' {$ENDIF};
function FSOUND_CD_GetPaused; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_CD_GetPaused@4' {$ENDIF};
function FSOUND_CD_GetTrack; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_CD_GetTrack@4' {$ENDIF};
function FSOUND_CD_GetNumTracks; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_CD_GetNumTracks@4' {$ENDIF};
function FSOUND_CD_GetVolume; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_CD_GetVolume@4' {$ENDIF};
function FSOUND_CD_GetTrackLength; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_CD_GetTrackLength@8' {$ENDIF};
function FSOUND_CD_GetTrackTime; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_CD_GetTrackTime@4' {$ENDIF};
function FSOUND_DSP_Create; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_DSP_Create@12' {$ENDIF};
procedure FSOUND_DSP_Free; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_DSP_Free@4' {$ENDIF};
procedure FSOUND_DSP_SetPriority; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_DSP_SetPriority@8' {$ENDIF};
function FSOUND_DSP_GetPriority; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_DSP_GetPriority@4' {$ENDIF};
procedure FSOUND_DSP_SetActive; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_DSP_SetActive@8' {$ENDIF};
function FSOUND_DSP_GetActive; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_DSP_GetActive@4' {$ENDIF};
function FSOUND_DSP_GetClearUnit; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_DSP_GetClearUnit@0' {$ENDIF};
function FSOUND_DSP_GetSFXUnit; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_DSP_GetSFXUnit@0' {$ENDIF};
function FSOUND_DSP_GetMusicUnit; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_DSP_GetMusicUnit@0' {$ENDIF};
function FSOUND_DSP_GetClipAndCopyUnit; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_DSP_GetClipAndCopyUnit@0' {$ENDIF};
function FSOUND_DSP_GetFFTUnit; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_DSP_GetFFTUnit@0' {$ENDIF};
function FSOUND_DSP_MixBuffers; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_DSP_MixBuffers@28' {$ENDIF};
procedure FSOUND_DSP_ClearMixBuffer; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_DSP_ClearMixBuffer@0' {$ENDIF};
function FSOUND_DSP_GetBufferLength; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_DSP_GetBufferLength@0' {$ENDIF};
function FSOUND_DSP_GetBufferLengthTotal; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_DSP_GetBufferLengthTotal@0' {$ENDIF};
function FSOUND_DSP_GetSpectrum; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_DSP_GetSpectrum@0' {$ENDIF};
function FSOUND_Reverb_SetProperties; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Reverb_SetProperties@4' {$ENDIF};
function FSOUND_Reverb_GetProperties; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Reverb_GetProperties@4' {$ENDIF};
function FSOUND_Reverb_SetChannelProperties; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Reverb_SetChannelProperties@8' {$ENDIF};
function FSOUND_Reverb_GetChannelProperties; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Reverb_GetChannelProperties@8' {$ENDIF};
function FSOUND_Record_SetDriver; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Record_SetDriver@4' {$ENDIF};
function FSOUND_Record_GetNumDrivers; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Record_GetNumDrivers@0' {$ENDIF};
function FSOUND_Record_GetDriverName; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Record_GetDriverName@4' {$ENDIF};
function FSOUND_Record_GetDriver; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Record_GetDriver@0' {$ENDIF};
function FSOUND_Record_StartSample; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Record_StartSample@8' {$ENDIF};
function FSOUND_Record_Stop; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Record_Stop@0' {$ENDIF};
function FSOUND_Record_GetPosition; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_Record_GetPosition@0' {$ENDIF};
procedure FSOUND_File_SetCallbacks; external FMOD_DLL {$IFDEF WIN32} name '_FSOUND_File_SetCallbacks@20' {$ENDIF};
function FMUSIC_LoadSong; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_LoadSong@4' {$ENDIF};
function FMUSIC_LoadSongMemory; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_LoadSongMemory@8' {$ENDIF};
function FMUSIC_FreeSong; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_FreeSong@4' {$ENDIF};
function FMUSIC_PlaySong; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_PlaySong@4' {$ENDIF};
function FMUSIC_StopSong; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_StopSong@4' {$ENDIF};
procedure FMUSIC_StopAllSongs; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_StopAllSongs@0' {$ENDIF};
function FMUSIC_SetZxxCallback; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_SetZxxCallback@8' {$ENDIF};
function FMUSIC_SetRowCallback; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_SetRowCallback@12' {$ENDIF};
function FMUSIC_SetOrderCallback; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_SetOrderCallback@12' {$ENDIF};
function FMUSIC_SetInstCallback; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_SetInstCallback@12' {$ENDIF};
function FMUSIC_SetSample; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_SetSample@12' {$ENDIF};
function FMUSIC_OptimizeChannels; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_OptimizeChannels@12' {$ENDIF};
function FMUSIC_SetReverb; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_SetReverb@4' {$ENDIF};
function FMUSIC_SetLooping; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_SetLooping@8' {$ENDIF};
function FMUSIC_SetOrder; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_SetOrder@8' {$ENDIF};
function FMUSIC_SetPaused; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_SetPaused@8' {$ENDIF};
function FMUSIC_SetMasterVolume; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_SetMasterVolume@8' {$ENDIF};
function FMUSIC_SetMasterSpeed; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_SetMasterSpeed@8' {$ENDIF};
function FMUSIC_SetPanSeperation; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_SetPanSeperation@8' {$ENDIF};
function FMUSIC_GetName; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_GetName@4' {$ENDIF};
function FMUSIC_GetType; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_GetType@4' {$ENDIF};
function FMUSIC_GetNumOrders; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_GetNumOrders@4' {$ENDIF};
function FMUSIC_GetNumPatterns; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_GetNumPatterns@4' {$ENDIF};
function FMUSIC_GetNumInstruments; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_GetNumInstruments@4' {$ENDIF};
function FMUSIC_GetNumSamples; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_GetNumSamples@4' {$ENDIF};
function FMUSIC_GetNumChannels; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_GetNumChannels@4' {$ENDIF};
function FMUSIC_GetSample; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_GetSample@8' {$ENDIF};
function FMUSIC_GetPatternLength; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_GetPatternLength@8' {$ENDIF};
function FMUSIC_IsFinished; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_IsFinished@4' {$ENDIF};
function FMUSIC_IsPlaying; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_IsPlaying@4' {$ENDIF};
function FMUSIC_GetMasterVolume; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_GetMasterVolume@4' {$ENDIF};
function FMUSIC_GetGlobalVolume; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_GetGlobalVolume@4' {$ENDIF};
function FMUSIC_GetOrder; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_GetOrder@4' {$ENDIF};
function FMUSIC_GetPattern; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_GetPattern@4' {$ENDIF};
function FMUSIC_GetSpeed; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_GetSpeed@4' {$ENDIF};
function FMUSIC_GetBPM; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_GetBPM@4' {$ENDIF};
function FMUSIC_GetRow; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_GetRow@4' {$ENDIF};
function FMUSIC_GetPaused; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_GetPaused@4' {$ENDIF};
function FMUSIC_GetTime; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_GetTime@4' {$ENDIF};
function FMUSIC_GetRealChannel; external FMOD_DLL {$IFDEF WIN32} name '_FMUSIC_GetRealChannel@8' {$ENDIF};

var
  Saved8087CW: Word;

initialization
  Saved8087CW := Default8087CW;
  Set8087CW($133f); { Disable all fpu exceptions }

finalization
  Set8087CW(Saved8087CW);

end.

