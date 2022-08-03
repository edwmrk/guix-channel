(define-module (edwmrk services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module (guix records)
  #:export (dhcp-client-configuration
            dhcp-client-shepherd-service
            dhcp-client-service-type))

(define-record-type* <dhcp-client-configuration>
  dhcp-client-configuration
  make-dhcp-client-configuration
  dhcp-client-configuration?
  (domain-name-servers
    dhcp-client-configuration-domain-name-servers
    (default '("8.8.8.8")))
  (pid-file
    dhcp-client-configuration-pid-file
    (default "/var/run/dhclient.pid")))

(define (dhcp-client-shepherd-service configuration)
  (let ((domain-name-servers
          (dhcp-client-configuration-domain-name-servers
            configuration))
        (pid-file
          (dhcp-client-configuration-pid-file
            configuration)))
    (shepherd-service
      (requirement '(user-processes udev))
      (provision '(networking dhcp-client))
      (start #~(lambda ()
                 (define (valid-interface? interface)
                   (and (arp-network-interface? interface)
                        (not (loopback-network-interface? interface))
                        (false-if-exception
                          (set-network-interface-up interface))))

                 (define interfaces
                   (filter valid-interface? (all-network-interface-names)))

                 (define dhcp-client-command
                   (cons* #$(file-append (@ (gnu packages admin) isc-dhcp) "/sbin/dhclient")
                          "-nw"
                          "-cf" #$(plain-file "dhclient-configuration-file"
                                    (string-append
                                      "supersede domain-name-servers "
                                      (string-join domain-name-servers ", ")
                                      ";\n"))
                          "-pf" #$pid-file
                          interfaces))

                 (false-if-exception (delete-file #$pid-file))
                 (let ((pid (fork+exec-command dhcp-client-command)))
                   (and (zero? (cdr (waitpid pid)))
                        (read-pid-file #$pid-file)))))
      (stop #~(make-kill-destructor)))))

(define dhcp-client-service-type
  (service-type
    (name 'dhcp-client)
    (extensions
      (list
        (service-extension shepherd-root-service-type
          (λ arguments (list (apply dhcp-client-shepherd-service arguments))))))
    (default-value (dhcp-client-configuration))
    (description "")))
