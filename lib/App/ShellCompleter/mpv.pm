package App::ShellCompleter::mpv;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Complete::File qw(complete_file);
use Complete::Number qw(complete_int complete_float);
use Complete::Util qw(complete_array_elem combine_answers);

sub _gcint {
    my ($min, $max) = @_;
    sub {
        my %args = @_;
        complete_float(word=>$args{word}, min=>$min, max=>$max);
    };
}

sub _gcfloat {
    my ($min, $max) = @_;
    sub {
        my %args = @_;
        complete_float(word=>$args{word}, min=>$min, max=>$max);
    };
}

my $compfile = sub {
    my %args = @_;
    complete_file(word=>$args{word});
};

my $compdir = sub {
    my %args = @_;
    complete_file(word=>$args{word}, filter=>'d');
};

my $MAX_INT = 2_147_483_647;

our %scargs = (
    'ad=s' => undef,                    # String (default: -spdif:*)
    'ad-lavc-ac3drc=f' => _gcfloat(0,2), # Float (0 to 2) (default: 1.000000)
    'ad-lavc-downmix!' => undef,        # Flag (default: yes)
    'ad-lavc-o=s' => undef,             # Key/value list (default: )
    'ad-lavc-threads=i' => _gcint(1,16), # Integer (1 to 16) (default: 1)
    'ad-spdif-dtshd!' => undef,         # Flag (default: no)
    'af=s' => undef,                    # Object settings list (default: )
    'af-defaults=s' => undef,           # Object settings list (default: )
    'aid=s' => sub {                    # Choices: no auto (or an integer) (1 to 8190) (default: auto)
        my %args = @_;
        my $word = $args{word};
        combine_anwers(
            complete_array_elem(array=>['no','auto'], word=>$word),
            complete_int(word=>$word, min=>1, max=>8190),
        );
    },
    'alang=s' => undef,                 # String list (default: )
    'ao=s' => undef,                    # Object settings list (default: )
    'ao-defaults=s' => undef,           # Object settings list (default: )
    'ass-force-style=s' => undef,       # String list (default: )
    'ass-hinting=s' => [qw/none light normal native/], # Choices: none light normal native (default: none)
    'ass-line-spacing=f' => _gcfloat(-1000,1000), # Float (-1000 to 1000) (default: 0.000000)
    'ass-shaper=s' => [qw/simple complex/], # Choices: simple complex (default: complex)
    'ass-style-override=s' => [qw/no yes force signfs/], # Choices: no yes force signfs (default: yes)
    'ass-styles=s' => $compfile,        # String (default: ) [file]
    'ass-use-margins!' => undef,        # Flag (default: no)
    'ass-vsfilter-aspect-compat!' => undef, # Flag (default: yes)
    'ass-vsfilter-blur-compat!' => undef, # Flag (default: yes)
    'ass-vsfilter-color-compat=s' => [qw/no basic full force-601/], # Choices: no basic full force-601 (default: basic)
    'audio-buffer=f' => _gcfloat(0,10), # Double (0 to 10) (default: 0.200000)
    'audio-channels=i' => _gcint(0),    # Audio channels or channel map (0 to any)
    'audio-delay=f' => _gcfloat(-100,100), # Float (-100 to 100) (default: 0.000000)
    'audio-demuxer=s' => undef,         # String (default: )
    'audio-display=s' => [qw/no attachment/], # Choices: no attachment (default: attachment)
    'audio-file=s' => $compfile,        # String list (default: ) [file]
    'audio-format=s' => undef,          # Audio format
    'audio-samplerate=i' => undef,      # Integer (1000 to 384000) (default: 0)
    'autofit=s' => undef,               # Window size
    'autofit-larger=s' => undef,        # Window size
    'autosync=s' => sub {               # Choices: no (or an integer) (0 to 10000) (default: 0)
        my %args = @_;
        my $word = $args{word};
        combine_answers(
            complete_array_elem(array=>[qw/no/], word=>$word),
            complete_int(word=>$word, min=>0, max=>10000),
        );
    },
    'bluray-angle=i' => _gcint(0,999),  # Integer (0 to 999) (default: 0)
    'bluray-device=s' => $compfile,     # String (default: ) [file]
    'border!' => undef,                 # Flag (default: yes)
    'brightness=i' => _gcint(-100,100), # Integer (-100 to 100) (default: 1000)
    'cache=s' => sub {                  # Choices: no auto (or an integer) (32 to 2147483647) (default: auto)
        my %args = @_;
        my $word = $args{word};
        combine_answers(
            complete_array_elem(array=>[qw/no auto/], word=>$word),
            complete_int(word=>$word, min=>32, max=>$MAX_INT),
        );
    },
    'cache-default=s' => undef,         # Choices: no (or an integer) (32 to 2147483647) (default: 25000)
    'cache-file=s' => $compfile,        # String (default: ) [file]
    'cache-file-size=i' => _gcint(0,$MAX_INT), # Integer (0 to 2147483647) (default: 1048576)
    'cache-initial=i' => _gcint(0,$MAX_INT), # Integer (0 to 2147483647) (default: 0)
    'cache-pause!' => undef,            # Flag (default: yes)
    'cache-secs=f' => _gcfloat(0),      # Double (0 to any) (default: 2.000000)
    'cache-seek-min=i' => _gcint(0, $MAX_INT),        # Integer (0 to 2147483647) (default: 500)
    'cdda-device=s' => undef,           # String (default: )
    'cdda-overlap=i' => _gcint(0,75),          # Integer (0 to 75) (default: -1)
    'cdda-paranoia=i' => _gcint(0,2),         # Integer (0 to 2) (default: 0)
    'cdda-sector-size=i' => _gcint(1,100),      # Integer (1 to 100) (default: 0)
    'cdda-skip!' => undef,              # Flag (default: yes)
    'cdda-span=i' => undef,             # Int[-Int]
    'cdda-speed=i' => _gcint(1,100),            # Integer (1 to 100) (default: 0)
    'cdda-toc-bias=i' => undef,         # Integer (default: 0)
    'cdda-toc-offset=i' => undef,       # Integer (default: 0)
    'cdrom-device=s' => $compfile,          # String (default: ) [file]
    'chapter=i' => undef,               # Int[-Int]
    'chapter-merge-threshold=i' => _gcint(0,10000), # Integer (0 to 10000) (default: 100)
    'chapter-seek-threshold=f' => undef, # Double (default: 5.000000)
    'colormatrix=s' => [qw/auto BT.601 BT.709 SMPTE-240M BT.2020-NCL BT.2020-CL YCgCo/],           # Choices: auto BT.601 BT.709 SMPTE-240M BT.2020-NCL BT.2020-CL YCgCo (default: auto)
    'colormatrix-input-range=s' => [qw/auto limited full/], # Choices: auto limited full (default: auto)
    'colormatrix-output-range=s' => [qw/auto limited full/], # Choices: auto limited full (default: auto)
    'colormatrix-primaries=s' => [qw/auto BT.601-525 BT.601-625 BT.709 BT.2020/], # Choices: auto BT.601-525 BT.601-625 BT.709 BT.2020 (default: auto)
    'config!' => undef,                 # Flag (default: yes) [global] [nocfg]
    'config-dir=s' => $compdir,            # String (default: ) [global] [nocfg]
    'contrast=i' => _gcint(-100,100),              # Integer (-100 to 100) (default: 1000)
    'cookies!' => undef,                # Flag (default: no)
    'cookies-file=s' => $compfile,          # String (default: ) [file]
    'correct-pts!' => undef,            # Flag (default: yes)
    'cursor-autohide=s' => sub {       # Choices: no always (or an integer) (0 to 30000) (default: 1000)
        my %args = @_;
        my $word = $args{word};
        combine_answers(
            complete_array_elem(array=>[qw/no always/], word=>$word),
            complete_int(min=>0, max=>30000, word=>$word),
        );
    },
    'cursor-autohide-fs-only!' => undef, # Flag (default: no)
    'deinterlace=s' => [qw/auto no yes/],           # Choices: auto no yes  (default: auto)
    'demuxer=s' => undef,               #  String (default: )
    'demuxer-lavf-allow-mimetype!' => undef, # Flag (default: yes)
    'demuxer-lavf-analyzeduration=f' => _gcfloat(0,3600), # Float (0 to 3600) (default: 0.000000)
    'demuxer-lavf-buffersize=i' => _gcint(1,10485760), # Integer (1 to 10485760) (default: 32768)
    'demuxer-lavf-cryptokey=s' => undef, # String (default: )
    'demuxer-lavf-format=s' => undef,   # String (default: )
    'demuxer-lavf-genpts-mode=s' => [qw/lavf no/], # Choices: lavf no (default: no)
    'demuxer-lavf-o=s' => undef,        # Key/value list (default: )
    'demuxer-lavf-probescore=i' => _gcint(0,100), # Integer (0 to 100) (default: 0)
    'demuxer-lavf-probesize=i' => _gcint(32,$MAX_INT), # Integer (32 to 2147483647) (default: 0)
    'demuxer-mkv-subtitle-preroll!' => undef, # Flag (default: no)
    'demuxer-rawaudio-channels=i' => _gcint(1), # Audio channels or channel map (1 to any)
    'demuxer-rawaudio-format=s' => [qw/u8 s8 u16le u16be s16le u16be u24le u24be s24le s24be u32le u32be s32le s32be floatle floatbe doublele doublebe u16 s16 u24 s24 u32 s32 float double/], #       Choices: u8 s8 u16le u16be s16le u16be u24le u24be s24le s24be u32le u32be s32le s32be floatle floatbe doublele doublebe u16 s16 u24 s24 u32 s32 float double (default: s16le)
    'demuxer-rawaudio-rate=i' => _gcint(1000,384000), #         Integer (1000 to 384000) (default: 44100)
    'demuxer-rawvideo-codec=s' => undef, #        String (default: )
    'demuxer-rawvideo-format=s' => undef, #       FourCC
    'demuxer-rawvideo-fps=f' => _gcfloat(0.001,1000), #          Float (0.001 to 1000) (default: 25.000000)
    'demuxer-rawvideo-h=i' => _gcint(1,8192), #            Integer (1 to 8192) (default: 720)
    'demuxer-rawvideo-mp-format=s' => undef, #    Image format
    'demuxer-rawvideo-size=i' => _gcint(1,268435456), #         Integer (1 to 268435456) (default: 0)
    'demuxer-rawvideo-w=i' => _gcint(1,8192), #            Integer (1 to 8192) (default: 1280)
    'demuxer-readahead-bytes=i' => _gcint(0,419430400), #       Integer (0 to 419430400) (default: 0)
    'demuxer-readahead-packets=i' => _gcint(0,16000), #     Integer (0 to 16000) (default: 0)
    'demuxer-readahead-secs=f' => _gcfloat(0), #        Double (0 to any) (default: 0.200000)
    'demuxer-thread!' => undef, #                Flag (default: yes)
    'display-fps=f' => _gcfloat(0), #                   Double (0 to any) (default: 0.000000)
    'dtshd!' => undef, #                         Flag (default: no)
    'dump-stats=s' => undef, #                    String (default: ) [global]
    'dvbin-card=i' => _gcint(1,4), #                      Integer (1 to 4) (default: 1)
    'dvbin-file=s' => undef, #                      String (default: )
    'dvbin-prog=s' => undef, #                      String (default: )
    'dvbin-timeout=i' => _gcint(1,30), #                   Integer (1 to 30) (default: 30)
    'dvd-angle=i' => _gcint(1,99), #                       Integer (1 to 99) (default: 1)
    'dvd-device=s' => undef, #                      String (default: ) [file]
    'dvd-speed=i' => undef, #                       Integer (default: 0)
    'edition=s' => sub { #                        Choices: auto (or an integer) (0 to 8190) (default: auto)
        my %args = @_;
        my $word = $args{word};
        combine_answers(
            complete_array_elem(array=>[qw/auto/], word=>$word),
            complete_int(min=>0, max=>8190, word=>$word),
        );
    },
    'embeddedfonts!' => undef, #                   Flag (default: yes)
    'end=s' => undef, #                             Relative time or percent position
    'field-dominance=s' => [qw/auto top bottom/], #                 Choices: auto top bottom (default: auto)
    'fixed-vo!' => undef, #                        Flag (default: yes) [global]
    'force-rgba-osd-rendering!' => undef, #        Flag (default: no)
    'force-window!' => undef, #                    Flag (default: no) [global]
    'force-window-position!' => undef, #           Flag (default: no)
    'fps=f' => _gcfloat(0), #                             Double (0 to any) (default: 0.000000)
    'framedrop=s' => [qw/no vo decoder decoder+vo/], #                       Choices: no vo decoder decoder+vo (default: vo)
    'frames=s' => sub { #                          Choices: all (or an integer) (0 to 2147483647) (default: all)
        my %args = @_;
        my $word = $args{word};
        combine_answers(
            complete_array_elem(array=>[qw/all/], word=>$word),
            complete_int(min=>0, max=>$MAX_INT, word=>$word),
        );
    },
    'fs!' => undef, #                              Flag (default: no)
    'fs-screen=s' => sub { #                       Choices: all current (or an integer) (0 to 32) (default: current)
        my %args = @_;
        my $word = $args{word};
        combine_answers(
            complete_array_elem(array=>[qw/all current/], word=>$word),
            complete_int(min=>0, max=>32, word=>$word),
        );
    },
    'fullscreen!' => undef, #                      Flag (default: no)
    'gamma=i' => _gcint(-100,100), #                           Integer (-100 to 100) (default: 1000)
    'gapless-audio=s' => [qw/no yes weak/], #                   Choices: no yes  weak (default: weak)
    'geometry=s' => undef, #                        Window geometry
    'help|h' => undef, #                               Print [global] [nocfg]
    'heartbeat-cmd=s' => undef, #                   String (default: )
    'heartbeat-interval=f' => _gcfloat(0), #              Float (0 to any) (default: 30.000000)
    'hls-bitrate=s' => [qw/no min max/], #                     Choices: no min max (default: no)
    'hr-seek=s' => [qw/no absolute always yes/], #                         Choices: no absolute always yes (default: absolute)
    'hr-seek-demuxer-offset=f' => _gcfloat(-9,99), #          Float (-9 to 99) (default: 0.000000)
    'hr-seek-framedrop!' => undef, #               Flag (default: yes)
    'http-header-fields=s' => undef, #              String list (default: )
    'hue=i' => _gcint(-100,100), #                             Integer (-100 to 100) (default: 1000)
    'hwdec=s' => [qw/no auto vdpau vda vaapi vaapi-copy/], #                           Choices: no auto vdpau vda vaapi vaapi-copy (default: no)
    'hwdec-codecs=s' => undef, #                    String (default: h264,vc1,wmv3)
    'idle!' => undef, #                            Flag (default: no) [global]
    'include=s' => $compfile, #                         String (default: ) [file]
    'index=s' => [qw/default recreate/], #                           Choices: default recreate (default: default)
    'initial-audio-sync!' => undef, #              Flag (default: yes)
    'input-ar-delay=i' => undef, #                  Integer (default: 200) [global]
    'input-ar-rate=i' => undef, #                   Integer (default: 40) [global]
    'input-cmdlist' => undef, #                   Print [global] [nocfg]
    'input-conf=s' => undef, #                      String (default: ) [global]
    'input-cursor!' => undef, #                    Flag (default: yes) [global]
    'input-default-bindings!' => undef, #          Flag (default: yes) [global]
    'input-doubleclick-time=i' => _gcint(0,1000), #          Integer (0 to 1000) (default: 300)
    'input-file=s' => undef, #                      String (default: ) [global]
    'input-joystick!' => undef, #                  Flag (default: no) [global]
    'input-js-dev=s' => undef, #                    String (default: ) [global]
    'input-key-fifo-size=i' => _gcint(2,65000), #             Integer (2 to 65000) (default: 7) [global]
    'input-keylist' => undef, #                   Print [global] [nocfg]
    'input-lirc!' => undef, #                      Flag (default: yes) [global]
    'input-lirc-conf=s' => undef, #                 String (default: ) [global]
    'input-right-alt-gr!' => undef, #              Flag (default: yes) [global]
    'input-terminal!' => undef, #                  Flag (default: yes) [global]
    'input-test!' => undef, #                      Flag (default: no) [global]
    'input-x11-keyboard!' => undef, #              Flag (default: yes) [global]
    'keep-open!' => undef, #                       Flag (default: no)
    'keepaspect!' => undef, #                      Flag (default: yes)
    'leak-report!' => undef, #                    Flag [global] [nocfg]
    'length=s' => undef, #                          Relative time or percent position
    'list-options!' => undef, #                    Flag [nocfg]
    'list-properties' => undef, #                 Print [global] [nocfg]
    'list-protocols' => undef, #                  Print [global] [nocfg]
    'load-scripts!' => undef, #                    Flag (default: yes) [global]
    'load-unsafe-playlists!' => undef, #           Flag (default: no)
    'loop=s' => sub { #                            Choices: no 1 inf (or an integer) (2 to 10000) (default: no) [global]
        my %args = @_;
        my $word = $args{word};
        combine_answers(
            complete_array_elem(array=>[qw/no 1 inf/], word=>$word),
            complete_int(min=>2, max=>10000, word=>$word),
        );
    },
    'loop-file=s' => sub { #                       Choices: yes  no inf (or an integer) (0 to 10000) (default: no)
        my %args = @_;
        my $word = $args{word};
        combine_answers(
            complete_array_elem(array=>[qw/yes no inf/], word=>$word),
            complete_int(min=>0, max=>10000, word=>$word),
        );
    },
    'lua=s' => undef, #                             String list (default: ) [global] [file]
    'lua-opts=s' => undef, #                        Key/value list (default: ) [global]
    'mc=f' => _gcfloat(0,100), #                              Float (0 to 100) (default: -1.000000)
    'media-title=s' => undef, #                     String (default: )
    'merge-files!' => undef, #                     Flag (default: no)
    'mf-fps=f' => undef, #                          Double (default: 1.000000)
    'mf-type=s' => undef, #                         String (default: )
    'mkv-subtitle-preroll!' => undef, #            Flag (default: no)
    'monitoraspect=f' => _gcfloat(0,9), #                   Float (0 to 9) (default: 0.000000)
    'monitorpixelaspect!' => _gcfloat(0.2,9), #              Float (0.2 to 9) (default: 1.000000)
    'msg-color!' => undef, #                       Flag (default: yes) [global]
    'msg-level=s' => undef, #                       Output verbosity levels (default: ) [global]
    'msg-module!' => undef, #                      Flag (default: no) [global]
    'msg-time!' => undef, #                        Flag (default: no) [global]
    'mute=s' => [qw/auto no yes/], #                            Choices: auto no yes  (default: auto)
    'native-keyrepeat!' => undef, #                Flag (default: no)
    'no-audio' => undef, #                      Flag
    'no-sub' => undef, #                         Flag
    'no-video' => undef, #                       Flag
    'no-video-aspect' => undef, #                Flag
    'o=s' => undef, #                              String (default: ) [global] [nocfg]
    'oac=s' => undef, #                            String (default: ) [global]
    'oacopts=s' => undef, #                       String list (default: ) [global]
    'oafirst!' => undef, #                        Flag (default: no) [global]
    'oaoffset=f' => _gcfloat(-1000000,1000000), #                       Float (-1000000 to 1000000) (default: 0.000000) [global]
    'oautofps!' => undef, #                       Flag (default: no) [global]
    'ocopyts!' => undef, #                        Flag (default: no) [global]
    'of=s' => undef, #                             String (default: ) [global]
    'ofopts=s' => undef, #                        String list (default: ) [global]
    'ofps=f' => _gcfloat(0,1000000), #                           Float (0 to 1000000) (default: 0.000000) [global]
    'oharddup!' => undef, #                       Flag (default: no) [global]
    'omaxfps=f' => _gcfloat(0,1000000), #                        Float (0 to 1000000) (default: 0.000000) [global]
    'ometadata!' => undef, #                      Flag (default: yes) [global]
    'oneverdrop!' => undef, #                     Flag (default: no) [global]
    'ontop!' => undef, #                          Flag (default: no)
    'orawts!' => undef, #                         Flag (default: no) [global]
    'ordered-chapters!' => undef, #               Flag (default: yes)
    'ordered-chapters-files=s' => undef, #         String (default: ) [file]
    'osc!' => undef, #                            Flag (default: yes) [global]
    'osd-back-color=s' => undef, #                 Color
    'osd-bar!' => undef, #                        Flag (default: yes)
    'osd-bar-align-x=f' => _gcfloat(-1,1), #                Float (-1 to 1) (default: 0.000000)
    'osd-bar-align-y=f' => _gcfloat(-1,1), #                Float (-1 to 1) (default: 0.500000)
    'osd-bar-h=f' => _gcfloat(0.1,50), #                      Float (0.1 to 50) (default: 3.125000)
    'osd-bar-w=f' => _gcfloat(1,100), #                      Float (1 to 100) (default: 75.000000)
    'osd-blur=f' => _gcfloat(0,20), #                       Float (0 to 20) (default: 0.000000)
    'osd-border-color=s' => undef, #               Color
    'osd-border-size=f' => _gcfloat(0,10), #                Float (0 to 10) (default: 2.500000)
    'osd-color=s' => undef, #                      Color
    'osd-duration=i' => _gcint(0,3600000), #                   Integer (0 to 3600000) (default: 1000)
    'osd-font=s' => undef, #                       String (default: sans-serif)
    'osd-font-size=f' => _gcfloat(1,9000), #                  Float (1 to 9000) (default: 45.000000)
    'osd-fractions!' => undef, #                  Flag (default: no)
    'osd-level=s' => [qw/0 1 2 3/], #                      Choices: 0 1 2 3 (default: 1)
    'osd-margin-x=i' => _gcint(0,300), #                   Integer (0 to 300) (default: 25)
    'osd-margin-y=i' => _gcint(0,600), #                   Integer (0 to 600) (default: 10)
    'osd-msg1=s' => undef, #                       String (default: )
    'osd-msg2=s' => undef, #                       String (default: )
    'osd-msg3=s' => undef, #                       String (default: )
    'osd-playing-msg=s' => undef, #                String (default: )
    'osd-scale=f' => _gcfloat(0,100), #                      Float (0 to 100) (default: 1.000000)
    'osd-scale-by-window=f' => undef, #            Flag (default: yes)
    'osd-shadow-color=s' => undef, #               Color
    'osd-shadow-offset=f' => _gcfloat(0,10), #              Float (0 to 10) (default: 0.000000)
    'osd-spacing=f' => _gcfloat(-10,10), #                    Float (-10 to 10) (default: 0.000000)
    'osd-status-msg=s' => undef, #                 String (default: )
    'ovc=s' => undef, #                            String (default: ) [global]
    'ovcopts=s' => undef, #                       String list (default: ) [global]
    'ovfirst!' => undef, #                        Flag (default: no) [global]
    'ovoffset=f' => _gcfloat(-1000000,1000000), #                       Float (-1000000 to 1000000) (default: 0.000000) [global]
    'panscan=f' => _gcfloat(0,1), #                        Float (0 to 1) (default: 0.000000)
    'pause=f' => undef, #                          Flag (default: no)
    'playlist=s' => undef, #                       String (1 to any) (default: ) [nocfg] [file]
    'profile=s' => undef, #                        String list (default: )
    'pts-association-mode=s' => [qw/auto decoder sort/], #           Choices: auto decoder sort (default: decoder)
    'pvr-abitrate=i' => undef, #                   Integer (default: 0)
    'pvr-alayer=i' => undef, #                     Integer (default: 0)
    'pvr-amode=s' => undef, #                      String (default: )
    'pvr-arate=i' => undef, #                      Integer (default: 0)
    'pvr-aspect=i' => undef, #                     Integer (default: 0)
    'pvr-fmt=s' => undef, #                        String (default: )
    'pvr-vbitrate=i' => undef, #                   Integer (default: 0)
    'pvr-vmode=s' => undef, #                      String (default: )
    'pvr-vpeak=i' => undef, #                      Integer (default: 0)
    'quiet!' => undef, #                          Flag (default: no) [global]
    'quvi-fetch-subtitles!' => undef, #           Flag (default: no)
    'quvi-format=s' => undef, #                    String (default: )
    'really-quiet' => undef, #                   Flag [global]
    'referrer=s' => undef, #                       String (default: )
    'reset-on-next-file=s' => undef, #             String list (default: ) [global]
    'resume-playback!' => undef, #                Flag (default: yes)
    'rtsp-transport=s' => [qw/lavf udp tcp http/], #                 Choices: lavf udp tcp http (default: tcp)
    'saturation=i' => _gcint(-100,100), #                     Integer (-100 to 100) (default: 1000)
    'save-position-on-quit!' => undef, #          Flag (default: no)
    'screen=s' => sub { #                         Choices: default (or an integer) (0 to 32) (default: default)
        my %args = @_;
        my $word = $args{word};
        combine_answers(
            complete_array_elem(array=>[qw/default/], word=>$word),
            complete_int(min=>0, max=>32, word=>$word),
        );
    },
    'screenshot-format=s' => undef, #              String (default: jpg)
    'screenshot-jpeg-baseline!' => undef, #       Flag (default: yes)
    'screenshot-jpeg-dpi=i' => _gcint(1,99999), #            Integer (1 to 99999) (default: 72)
    'screenshot-jpeg-optimize=i' => _gcint(0,100), #       Integer (0 to 100) (default: 100)
    'screenshot-jpeg-progressive!' => undef, #    Flag (default: no)
    'screenshot-jpeg-quality=i' => _gcint(0,100), #        Integer (0 to 100) (default: 90)
    'screenshot-jpeg-smooth=i' => _gcint(0,100), #         Integer (0 to 100) (default: 0)
    'screenshot-png-compression=i' => _gcint(0,9), #     Integer (0 to 9) (default: 7)
    'screenshot-png-filter=i' => _gcint(0,5), #          Integer (0 to 5) (default: 5)
    'screenshot-template=s' => undef, #            String (default: )
    'secondary-sid=s' => sub { #                  Choices: no auto (or an integer) (1 to 8190) (default: no)
        my %args = @_;
        my $word = $args{word};
        combine_answers(
            complete_array_elem(array=>[qw/no auto/], word=>$word),
            complete_int(min=>1, max=>8190, word=>$word),
        );
    },
    'show-profile=s' => undef, #                   String (default: ) [nocfg]
    'shuffle!' => undef, #                        Flag (default: no) [global] [nocfg]
    'sid=s' => sub { #                            Choices: no auto (or an integer) (1 to 8190) (default: auto)
        my %args = @_;
        my $word = $args{word};
        combine_answers(
            complete_array_elem(array=>[qw/no auto/], word=>$word),
            complete_int(min=>1, max=>8190, word=>$word),
        );
    },
    'slang=s' => undef, #                          String list (default: )
    'slave-broken!' => undef, #                   Flag (default: no) [global]
    'softvol=s' => [qw/no yes auto/], #                        Choices: no yes auto (default: auto)
    'softvol-max' => _gcfloat(10,10000), #                    Float (10 to 10000) (default: 200.000000)
    'speed=f' => _gcfloat(0.01,100), #                          Double (0.01 to 100) (default: 1.000000)
    'sstep=f' => _gcfloat(0), #                          Double (0 to any) (default: 0.000000)
    'start=s' => undef, #                          Relative time or percent position
    'stop-screensaver!' => undef, #               Flag (default: yes)
    'stream-capture=s' => undef, #                 String (default: ) [file]
    'stream-dump=s' => undef, #                    String (default: ) [file]
    'stream-lavf-o=s' => undef, #                  Key/value list (default: )
    'stretch-dvd-subs!' => undef, #               Flag (default: no)
    'sub-ass!' => undef, #                        Flag (default: yes)
    'sub-auto=s' => [qw/no exact fuzzy all/], #                       Choices: no exact fuzzy all (default: exact)
    'sub-clear-on-seek!' => undef, #              Flag (default: no)
    'sub-codepage=s' => undef, #                   String (default: auto)
    'sub-delay=f' => undef, #                      Float (default: 0.000000)
    'sub-demuxer=s' => undef, #                    String (default: )
    'sub-file=f' => undef, #                       String list (default: ) [file]
    'sub-fix-timing!' => undef, #                 Flag (default: yes)
    'sub-forced-only!' => undef, #                Flag (default: no)
    'sub-fps=f' => undef, #                        Float (default: 0.000000)
    'sub-gauss=f' => _gcfloat(0,3), #                      Float (0 to 3) (default: 0.000000)
    'sub-gray!' => undef, #                       Flag (default: no)
    'sub-paths=s' => undef, #                      String list (default: )
    'sub-pos=i' => _gcint(0,100), #                        Integer (0 to 100) (default: 100)
    'sub-scale=f' => _gcfloat(0,100), #                      Float (0 to 100) (default: 1.000000)
    'sub-scale-with-window!' => undef, #          Flag (default: no)
    'sub-speed=f' => undef, #                      Float (default: 1.000000)
    'sub-text-back-color=s' => undef, #            Color
    'sub-text-blur=f' => _gcfloat(0,20), #                  Float (0 to 20) (default: 0.000000)
    'sub-text-border-color=s' => undef, #          Color
    'sub-text-border-size=f' => _gcfloat(0,10), #           Float (0 to 10) (default: 2.500000)
    'sub-text-color=s' => undef, #                 Color
    'sub-text-font=s' => undef, #                  String (default: sans-serif)
    'sub-text-font-size=f' => _gcfloat(1,9000), #             Float (1 to 9000) (default: 45.000000)
    'sub-text-margin-x=i' => _gcint(0,300), #              Integer (0 to 300) (default: 25)
    'sub-text-margin-y=i' => _gcint(0,600), #              Integer (0 to 600) (default: 10)
    'sub-text-shadow-color=s' => undef, #          Color
    'sub-text-shadow-offset=f' => _gcfloat(0,10), #         Float (0 to 10) (default: 0.000000)
    'sub-text-spacing=f' => _gcfloat(-10,10), #               Float (-10 to 10) (default: 0.000000)
    'sub-visibility!' => undef, #                 Flag (default: yes)
    'sws-cgb=f' => _gcfloat(0,100), #                        Float (0 to 100) (default: 0.000000)
    'sws-chs=i' => undef, #                        Integer (default: 0)
    'sws-cs=f' => _gcfloat(-100,100), #                         Float (-100 to 100) (default: 0.000000)
    'sws-cvs=i' => undef, #                        Integer (default: 0)
    'sws-lgb=f' => _gcfloat(0,100), #                        Float (0 to 100) (default: 0.000000)
    'sws-ls=f' => _gcfloat(-100,100), #                         Float (-100 to 100) (default: 0.000000)
    'sws-scaler=s' => [qw/fast-bilinear bilinear bicubic x point area bicublin gauss sinc lanczos spline/], #                     Choices: fast-bilinear bilinear bicubic x point area bicublin gauss sinc lanczos spline (default: bicubic)
    'term-osd=s' => [qw/force auto no/], #                       Choices: force auto no (default: auto)
    'term-osd-bar!' => undef, #                   Flag (default: no)
    'term-osd-bar-chars=s' => undef, #             String (default: [-+-])
    'term-playing-msg=s' => undef, #               String (default: )
    'term-status-msg=s' => undef, #                String (default: )
    'terminal!' => undef, #                       Flag (default: yes) [global]
    'title=s' => undef, #                          String (default: mpv - ${media-title})
    'tls-ca-file=s' => undef, #                    String (default: ) [file]
    'tls-verify!' => undef, #                     Flag (default: no)
    'tv-adevice=s' => undef, #                     String (default: )
    'tv-alsa!' => undef, #                        Flag (default: no)
    'tv-amode=i' => _gcint(0,3), #                       Integer (0 to 3) (default: -1)
    'tv-audio!' => undef, #                       Flag (default: yes)
    'tv-audioid=i' => _gcint(0,9), #                     Integer (0 to 9) (default: 0)
    'tv-audiorate=i' => undef, #                   Integer (default: 44100)
    'tv-automute=i' => _gcint(0,255), #                    Integer (0 to 255) (default: 0)
    'tv-balance=i' => _gcint(0,65535), #                     Integer (0 to 65535) (default: -1)
    'tv-bass=i' => _gcint(0,65535), #                        Integer (0 to 65535) (default: -1)
    'tv-brightness=i' => _gcint(-100,100), #                  Integer (-100 to 100) (default: 0)
    'tv-buffersize=i' => _gcint(16,1024), #                  Integer (16 to 1024) (default: -1)
    'tv-chanlist=s' => undef, #                    String (default: europe-east)
    'tv-channel=s' => undef, #                     String (default: )
    'tv-channels=s' => undef, #                    String list (default: )
    'tv-contrast=i' => _gcint(-100,100), #                    Integer (-100 to 100) (default: 0)
    'tv-decimation=i' => _gcint(1,4), #                  Integer (1 to 4) (default: 2)
    'tv-device=s' => undef, #                      String (default: )
    'tv-driver=s' => undef, #                      String (default: )
    'tv-forceaudio!' => undef, #                  Flag (default: no)
    'tv-forcechan=i' => _gcint(1,2), #                   Integer (1 to 2) (default: -1)
    'tv-fps=f' => undef, #                         Float (default: -1.000000)
    'tv-freq=s' => undef, #                        String (default: )
    'tv-gain=i' => _gcint(-1,100), #                        Integer (-1 to 100) (default: -1)
    'tv-height=i' => _gcint(0,4096), #                      Integer (0 to 4096) (default: -1)
    'tv-hue=i' => _gcint(-100,100), #                         Integer (-100 to 100) (default: 0)
    'tv-immediatemode!' => undef, #               Flag (default: yes)
    'tv-input=i' => undef, #                       Integer (default: 0)
    'tv-mjpeg!' => undef, #                       Flag (default: no)
    'tv-norm=s' => undef, #                        String (default: pal)
    'tv-normid=i' => undef, #                      Integer (default: -1)
    'tv-outfmt=s' => undef, #                      FourCC
    'tv-quality=i' => undef, #                     Integer (0 to 100) (default: 90)
    'tv-saturation=i' => _gcint(-100,100), #                  Integer (-100 to 100) (default: 0)
    'tv-scan-autostart!' => undef, #              Flag (default: no)
    'tv-scan-period=f' => _gcfloat(0.1,2), #                 Float (0.1 to 2) (default: 0.500000)
    'tv-scan-threshold=i' => _gcint(1,100), #              Integer (1 to 100) (default: 50)
    'tv-treble=i' => _gcint(0,65535), #                      Integer (0 to 65535) (default: -1)
    'tv-volume=i' => _gcint(0,65535), #                      Integer (0 to 65535) (default: -1)
    'tv-width=i' => _gcint(0,4096), #                       Integer (0 to 4096) (default: -1)
    'untimed!' => undef, #                        Flag (default: no)
    'use-filedir-conf!' => undef, #               Flag (default: no) [global]
    'user-agent=s' => undef, #                     String (default: mpv 0.6.2)
    'verbose|v' => undef, #                              Flag [global] [nocfg]
    'version|V' => undef, #                              Print [global] [nocfg]
    'vd=s' => undef, #                             String (default: )
    'vd-lavc-bitexact!' => undef, #               Flag (default: no)
    'vd-lavc-check-hw-profile!' => undef, #       Flag (default: yes)
    'vd-lavc-fast!' => undef, #                   Flag (default: no)
    'vd-lavc-framedrop=s' => [qw/none default nonref bidir nonkey all/], #              Choices: none default nonref bidir nonkey all (default: nonref)
    'vd-lavc-o=s' => undef, #                      Key/value list (default: )
    'vd-lavc-show-all!' => undef, #               Flag (default: no)
    'vd-lavc-skipframe=s' => [qw/none default nonref bidir nonkey all/], #              Choices: none default nonref bidir nonkey all (default: default)
    'vd-lavc-skipidct=s' => [qw/none default nonref bidir nonkey all/], #               Choices: none default nonref bidir nonkey all (default: default)
    'vd-lavc-skiploopfilter=s' => [qw/none default nonref bidir nonkey all/], #         Choices: none default nonref bidir nonkey all (default: default)
    'vd-lavc-threads=i' => _gcint(0,16), #                Integer (0 to 16) (default: 0)
    'vf=s' => undef, #                            Object settings list (default: )
    'vf-defaults=s' => undef, #                    Object settings list (default: )
    'vid=s' => sub { #                            Choices: no auto (or an integer) (1 to 8190) (default: auto)
        my %args = @_;
        my $word = $args{word};
        combine_answers(
            complete_array_elem(array=>[qw/no auto/], word=>$word),
            complete_int(min=>1, max=>8190, word=>$word),
        );
    },
    'video-align-x=f' => _gcfloat(-1,1), #                  Float (-1 to 1) (default: 0.000000)
    'video-align-y=f' => _gcfloat(-1,1), #                  Float (-1 to 1) (default: 0.000000)
    'video-aspect=f' => _gcfloat(-1,10), #                   Float (-1 to 10) (default: -1.000000)
    'video-pan-x=f' => _gcfloat(-3,3), #                    Float (-3 to 3) (default: 0.000000)
    'video-pan-y=f' => _gcfloat(-3,3), #                    Float (-3 to 3) (default: 0.000000)
    'video-rotate=s' => sub { #                   Choices: no (or an integer) (0 to 359) (default: 0)
        my %args = @_;
        my $word = $args{word};
        combine_answers(
            complete_array_elem(array=>[qw/no/], word=>$word),
            complete_int(min=>0, max=>359, word=>$word),
        );
    },
    'video-stereo-mode=s' => undef, #              Stereo 3D mode (default: mono)
    'video-unscaled!' => undef, #                 Flag (default: no)
    'video-zoom=f' => _gcfloat(-20,20), #                     Float (-20 to 20) (default: 0.000000)
    'vo=s' => undef, #                             Object settings list (default: )
    'vo-defaults=s' => undef, #                    Object settings list (default: )
    'volume=f' => _gcfloat(-1,100), #                         Float (-1 to 100) (default: -1.000000)
    'volume-restore-data=s' => undef, #            String (default: )
    'wid=i' => undef, #                            Integer64 (default: -1) [global]
    'window-dragging!' => undef, #                Flag (default: yes) [global]
    'write-filename-in-watch-later-config!' => undef, # Flag (default: no)
    'x11-name=s' => undef, #                       String (default: )
    'x11-netwm!' => undef, #                      Flag (default: yes)

 # UNSUPPORTED: --{                              Flag [nocfg]
 # UNSUPPORTED: --}                              Flag [nocfg]
);

1;
# ABSTRACT: Shell completion for mpv

=head1 SYNOPSIS

See L<_mpv> included in this distribution.


=head1 SEE ALSO

mpv, L<http://mpv.io/>
