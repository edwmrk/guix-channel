(define-module (edwmrk packages)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix git-download))

(define-public python-hy
  (package
    (name "python-hy")
    (version "0.24.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/hylang/hy")
               (commit version)))
        (sha256 (base32 "1s458ymd9g3s8k2ccc300jr4w66c7q3vhmhs9z3d3a4qg0xdhs9y"))))
    (build-system (@ (guix build-system python) python-build-system))
    (arguments '(#:tests? #f))
    (propagated-inputs
      (list
        (@ (gnu packages python-xyz) python-astor)
        (@ (gnu packages python-xyz) python-colorama)
        (@ (gnu packages python-xyz) python-funcparserlib)
        (@ (gnu packages python-xyz) python-rply)
        (@ (gnu packages python-build) python-wheel)))
    (home-page "https://hylang.org")
    (synopsis "Lisp frontend to Python")
    (description "Hy is a dialect of Lisp that's embedded in Python. Since Hy transforms its Lisp code into the Python Abstract Syntax Tree, you have the whole world of Python at your fingertips, in Lisp form.")
    (license (@ (guix licenses) expat))))

(define-public ani-cli
  (package
    (name "ani-cli")
    (version "3.2")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/pystardust/ani-cli")
               (commit (string-append "v" version))))
        (sha256 (base32 "0k618dl0mdnhnpywy6aydidrf5pmc6k1bdykmazzav7yjmqalb1d"))))
    (build-system (@ (guix build-system copy) copy-build-system))
    (arguments
      '(#:install-plan
        '(("bin" "/")
          ("lib" "/"))))
    (propagated-inputs
      (list
        (@ (gnu packages bittorrent) aria2)
        (@ (gnu packages ncurses) ncurses)
        (@ (gnu packages base) coreutils)
        (@ (gnu packages base) grep)
        (@ (gnu packages base) sed)
        (@ (gnu packages gawk) gawk)
        (@ (gnu packages curl) curl)
        (@ (gnu packages tls) openssl-3.0)
        (@ (gnu packages video) mpv)
        (@ (gnu packages video) vlc)
        (@ (gnu packages video) ffmpeg-5)))
    (home-page "https://github.com/pystardust/ani-cli")
    (synopsis "A cli tool to browse and play anime")
    (description #f)
    (license (@ (guix licenses) gpl3+))))

(define-public sdhcp
  (package
    (name "sdhcp")
    (version "8455fd2d090bd9b227340c30c92c6aa13302c91a")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "git://git.2f30.org/sdhcp")
               (commit version)))
        (sha256 (base32 "07f545cxrb75csinj7qi82jih0xbnv50fvs4jdf5b9wwxwaa7pbc"))))
    (build-system (@ (guix build-system gnu) gnu-build-system))
    (arguments 
      `(#:phases
        (modify-phases %standard-phases
          (delete 'configure)
          (delete 'check))
        #:make-flags
        (list ,(string-append "CC=" (cc-for-target))
           (string-append "PREFIX=" %output))))
    (home-page "https://git.2f30.org/sdhcp")
    (synopsis "simple dhcp client")
    (description #f)
    (license (@ (guix licenses) expat))))

(define-public xmrig
  (package
    (name "xmrig")
    (version "6.18.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/xmrig/xmrig")
               (commit (string-append "v" version))))
        (sha256 (base32 "1ncnfjpjwjdv29plyiam2nh01bfni49sgfi3qkijygi1450w71dx"))))
    (build-system (@ (guix build-system cmake) cmake-build-system))
    (inputs
      (list
        (list (@ (gnu packages mpi) hwloc) "lib")
        (@ (gnu packages libevent) libuv)
        (@ (gnu packages tls) openssl)))
    (arguments
      '(#:tests? #f
        #:phases
        (modify-phases %standard-phases
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (install-file "xmrig" (string-append (assoc-ref outputs "out") "/bin"))
              #t)))))
    (home-page "https://xmrig.com")
    (synopsis "RandomX, KawPow, CryptoNight and GhostRider unified CPU/GPU miner")
    (description "XMRig is a high performance, open source, cross platform RandomX, KawPow, CryptoNight, AstroBWT and GhostRider unified CPU/GPU miner and RandomX benchmark.")
    (license (@ (guix licenses) gpl3+))))

(define-public pcsx2
  (package
    (name "pcsx2")
    (version "1.7.3055")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/pcsx2/pcsx2")
               (commit (string-append "v" version))
               (recursive? #t)))
        (sha256 (base32 "195skdlsw60mv50zldr19m9j5s2iajviwxwpy5fzkdkf4hqvfdrp"))))
    (build-system (@ (guix build-system cmake) cmake-build-system))
    (inputs
      (list
        (@ (gnu packages perl) perl)
        (@ (gnu packages pkg-config) pkg-config)
        (@ (gnu packages linux) alsa-lib)
        (@ (gnu packages pretty-print) fmt)
        (@ (gnu packages gettext) gnu-gettext)
        (@ (gnu packages glib) glib-with-documentation)
        (@ (gnu packages gtk) gtk+)
        (@ (gnu packages gtk) harfbuzz)
        (@ (gnu packages linux) libaio)
        (@ (gnu packages admin) libpcap)
        (@ (gnu packages image) libpng)
        (@ (gnu packages pulseaudio) pulseaudio)
        (@ (gnu packages pulseaudio) libsamplerate)
        (@ (gnu packages xml) libxml2)
        (@ (gnu packages audio) portaudio)
        (@ (gnu packages sdl) sdl2)
        (@ (gnu packages audio) soundtouch)
        (@ (gnu packages linux) eudev)
        (@ (gnu packages freedesktop) wayland)
        (@ (gnu packages wxwidgets) wxwidgets)
        (@ (gnu packages compression) zlib)))
    (arguments
     '(#:configure-flags
       '("-DDISABLE_ADVANCE_SIMD=TRUE"
         "-DDISABLE_PCSX2_WRAPPER=TRUE"
         "-DPACKAGE_MODE=TRUE"
         "-DWAYLAND_API=TRUE"
         "-DSDL2_API=TRUE"
         "-DXDG_STD=TRUE")
       #:tests? #f))
    (home-page "https://pcsx2.net")
    (synopsis "PCSX2 - The Playstation 2 Emulator")
    (description "PCSX2 is a free and open-source PlayStation 2 (PS2) emulator. Its purpose is to emulate the PS2's hardware, using a combination of MIPS CPU Interpreters, Recompilers and a Virtual Machine which manages hardware states and PS2 system memory. This allows you to play PS2 games on your PC, with many additional features and benefits.")
    (license (@ (guix licenses) gpl3+))))
