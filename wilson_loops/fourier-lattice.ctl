(include "aux-functionality.scm")
(include "berry-phase.scm")
(include "print-symeigs.scm")

(define-param run-type "all") ; ("all", "te", "tm"); optionally set at geometry-creation
(define-param dim      3)     ; dimension
(define-param sgnum    1)     ; space group number
(define-param res      32)    ; resolution
(define-param prefix   filename-prefix) ; custom file prefix for *.h5 output
(define-param optarg   "")    ; optional arguments
(define-param kvecs   '())    ; list of k-vectors (list of kvecs or string to kvecs data file)
(define-param kvecs-restart-idx 0) ; optional restarting point in kvecs
(define-param nbands   12)    ; # of bands to compute
(define-param Ws      '())    ; point group parts of symops; see SYMMETRY EIGENVALUES part

(include "level-set-fourier-lattice.scm")
(set! filename-prefix (string-append prefix "-"))

; set calculation-specific parameters
(set! resolution res)
(set! num-bands  nbands)

; remove output of *.h5 unitcell files
(set! output-mu      (lambda () (print "... skipping output-mu\n")))
(set! output-epsilon (lambda () (print "... skipping output-epsilon\n")))

; set k-points from input param 'kvecs' (list of kvecs)
(cond 
    ; if 'kvecs' is a string, interpret as a file name in /input/ directory (to a list of lists)
    ((string? kvecs)
        (let* ((port (open-input-file (string-append "input/" kvecs)))
              (kvecs-as-list (read port))) ; list of list
                (close-input-port port) ; close file again
                (set! k-points (map (lambda (x) (apply vector3 x)) kvecs-as-list))
        )
    )
    ; if 'kvecs' is a list of vector3, use directly (TODO: fix)
    ((not (null? kvecs))  ;((fold-left (lambda (x y) (and x (vector3? y))) true kvecs))
        (set! k-points kvecs)
    )
    ; otherwise, ignore
    (else (print "\nkvecs = " kvecs ", is not an interpretable input type: ignored\n"))
)

(if (> kvecs-restart-idx 1) ; optionally restart at a kvecs offset given by kvecs-restart-idx: 1-based (<= 1 => keeps all)
   (begin 
       (set! k-points (keep-from-idx k-points kvecs-restart-idx))
       (print "\n... restarting from k-point index " kvecs-restart-idx "\n")
   )
)
;(output-epsilon)
; determine the "parity constraint" 
(define p (cond ((string=? run-type "all")  NO-PARITY)    ;          ≡ 0
                ((string=? run-type "te")   TE)           ; ≡ EVEN-Z ≡ 1
                ((string=? run-type "tm")   TM)))         ; ≡ ODD-Z  ≡ 2

(cond ; run-parity is effectively equivalent to run, run-te, run-tm, etc.:
      ; like them, it also implicitly sets the global symmetry constraint (to p)
      ((and (null? Ws) (not (null? k-points))) (run-parity p true))

      ; otherwise, we just set the global symmetry constraint setting explicitly
      ; so we can later call (solve-kpoint ...)
      (else (init-params p true))
)

(define-param berry-bool       true) ; Note that we have now set the default value of berry-bool to true- since all calculations herein involve Berry phases 
(define-param berry-ks-loops   '())
(define-param berry-bands-list (list '(1 2) '(1 2 3) '(1 2 3 4) '(1 2 3 4 5)))
(define-param berry-Nk-loop    100)     ; only relevant if berry-ks-loops is empty
(define-param berry-Nk-sweep   20)     ; --||--

(cond (berry-bool ; run calculation if berry-bool is true
    (print-berry-phase-output-struct berry-bands-list)
    (cond 
        ((null? berry-ks-loops) ; then we default to linear loops along ky, sweeping along kx
            (let ((ks-sweep (interpolate berry-Nk-sweep (list -0.5 0.5))))
                ; run through the different k-loops and print Berry phases along the way
                (do ((i 0 (+ i 1))) ((= i (length ks-sweep)))
                    (let* ( (k-sweep      (list-ref ks-sweep i))
                            (k-loop-start (vector3 k-sweep 0.0 0))
                            (k-loop-stop  (vector3 k-sweep 1.0 0))
                            (ks-loop      (interpolate berry-Nk-loop (list k-loop-start k-loop-stop)))
                          )
                        ; calculate and print berry phases (no need to store them)
                        (berry-phase ks-loop berry-bands-list) 
                    )
                )
            )
        )
        (else ; assume that berry-ks-loops is a list of list of vector3
            (map (lambda (ks-loop)
                (berry-phase ks-loop berry-bands-list)
            ) berry-ks-loops)
        )
    )
))

(define-param ws      '())
(define-param opidxs  '())
; Note that we do not calculate symmetry eigenvalues

(quit)
