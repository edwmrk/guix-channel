(define-module (edwmrk packages)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix git-download))

(define-public sdhcp
  (package
    (name "sdhcp")
    (version "8455fd2d090bd9b227340c30c92c6aa13302c91a")
    (source (origin
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
    (version "6.17.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/xmrig/xmrig")
               (commit "56c95703a555e8bdf773b51ea475be9ad58c4333")))
        (sha256 (base32 "11wh2ry3dnjynzc9a3nd8mfja7h6nxmx4fwaha82ssz5dkfqvj9b"))))
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
    (version "d3aace98ac4a52cf13fbd677de0639e17ea5a9ff")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/pcsx2/pcsx2")
               (commit version)
               (recursive? #t)))
        (sha256 (base32 "1zbbjcikh3csmv60q5iqnipjrlhh2q79vixxf0i310n40l3920wi"))))
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