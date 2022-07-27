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
(define-param arrayidx '())

(include "supercell-lattice.scm")

(set! filename-prefix (string-append prefix "-corner-"))

(set! resolution res)

(cond ((number? supercell)
(set! num-bands  ( * (expt supercell 2) nbands))
)
(else   
(set! num-bands (inexact->exact (* (* (vector3-x supercell) (vector3-y supercell)) nbands)))
))

; set k-points from input param 'kvecs' (list of kvecs)
(cond 
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

(define nkpoints (length k-points))
(cond ((number? supercell) 
(set! k-points (list (vector3 0 0))) ; For supercell calculations don't look past gamma point
)
(else 
(set! k-points (list (vector3 0 0) (vector3 0 0.5)))
(set! k-points (interpolate nkpoints k-points)) 
))

(cond ((not (null? arrayidx)) 
(set! k-points (list (list-ref k-points (- arrayidx 1))))
))

(output-epsilon)
; determine the "parity constraint" 
(define p (cond ((string=? run-type "all")  NO-PARITY)    ;          ≡ 0
                ((string=? run-type "te")   TE)           ; ≡ EVEN-Z ≡ 1
                ((string=? run-type "tm")   TM)))         ; ≡ ODD-Z  ≡ 2

(run-parity p true)

(output-epsilon)
(define (output-all-dpwr ntotal n) (cond ((<= n ntotal) (output-dpwr n) (output-all-dpwr ntotal (+ n 1)) )))
(output-all-dpwr num-bands 1)
(quit)
