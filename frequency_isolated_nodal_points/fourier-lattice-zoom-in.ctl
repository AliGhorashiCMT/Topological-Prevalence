(include "aux-functionality.scm")

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
(define-param kidx 0) 

(include "level-set-fourier-lattice.scm")

; define file-name prefix for *.h5 output files
(set! filename-prefix (string-append prefix "-"))


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

(define k-point-origin (list-ref k-points kidx))

(define k-point-mesh (interpolate 100 (list (vector3 -0.04 -0.04) (vector3 0.04 -0.04)))) 
(define (interpolate-along-y x) (interpolate 100 (list x (vector3 (vector3-x x) (* -1 (vector3-y x)) ) ) ) )
(define (add-origin x) (vector3+ x k-point-origin))
(set! k-point-mesh (map interpolate-along-y k-point-mesh))
(set! k-point-mesh (apply append k-point-mesh))
(set! k-points (map add-origin k-point-mesh))

; determine the "parity constraint" 
(define p (cond ((string=? run-type "all")  NO-PARITY)    ;          ≡ 0
                ((string=? run-type "te")   TE)           ; ≡ EVEN-Z ≡ 1
                ((string=? run-type "tm")   TM)))         ; ≡ ODD-Z  ≡ 2

(run-parity p true)


(define-param ws      '())
(define-param opidxs  '())

(quit)
