(define-param rvecs    (list (vector3 1 0 0) (vector3 0 1 0) (vector3 0 0 1)))
(define-param uc-gvecs (list (vector3 0 0 0))) ; initialized as constant function
(define-param uc-gvecs-clad (list (vector3 0 0 0))) ; cladding uc-gvecs
(define-param uc-coefs (list 1.0+0.0i))
(define-param uc-coefs-clad (list 1.0+0.0i))
(define-param uc-level  0.0)
(define-param uc-level-clad 0.0)
(define-param epsin    10.0)
(define-param epsout    1.0)
(define-param epsin-clad 10.0)
(define-param epsout-clad 1.0)
(define-param supercell 1)
(define-param cladding 0.5)
(define-param relative-shift (vector3 0 0 0))

(cond 
    ((equal? dim 2) ; 2D
	(cond ((number? supercell)

        (set! geometry-lattice (make lattice
            (size (* 1 supercell) (* 1 supercell) no-size) 
            (basis1 (list-ref rvecs 0)) (basis2 (list-ref rvecs 1))
            (basis-size (vector3-norm (list-ref rvecs 0)) (vector3-norm (list-ref rvecs 1)) 1)
        ))
	)
	(else 
	(set! geometry-lattice (make lattice
            (size (* 1 (vector3-x supercell)) (* 1 (vector3-y supercell)) no-size) 
            (basis1 (list-ref rvecs 0)) (basis2 (list-ref rvecs 1))
            (basis-size (vector3-norm (list-ref rvecs 0)) (vector3-norm (list-ref rvecs 1)) 1)
        ))
        ))
 
    )
)

(add-to-load-path ".") ; ensure the ctl directory is in load path (+ avoid issues w/ paths relative to current working dir)
(load "calc-fourier-sum-fast.scm")
(load "calc-fourier-sum-fast-clad.scm")

(define (level-set-eps r)
    (define x (vector3-x r))
    (define y (vector3-y r))

    (define bound1 (+ cladding y (* -2 x)))
    (define bound2 (+ cladding (* -1 y) (* 2 x)))
    (define bound3 (+ cladding x (* -2 y)))
    (define bound4 (+ cladding (* -1 x) (* 2 y)))
    (define bound5 (+ y x cladding))
    (define bound6 (+ cladding (* -1 x) (* -1 y)))

    (cond ((number? supercell)
    (cond ( (and (> bound1 0) (> bound2 0) (> bound3 0) (> bound4 0) (> bound5 0) (> bound6 0))    
	 (cond ((< (calc-fourier-sum-fast r) uc-level) epsin)
          (else epsout)))
    (else 
	(cond ((< (calc-fourier-sum-fast-clad (vector3+ r relative-shift)) uc-level-clad) epsin-clad)
	(else epsout-clad))
    ))
    )
    (else 
    (cond ( (< x cladding)     
	 (cond ((< (calc-fourier-sum-fast r) uc-level) epsin)
          (else epsout)))
    (else 
	(cond ((< (calc-fourier-sum-fast-clad r) uc-level-clad) epsin-clad)
	(else epsout-clad))
    ))
    ))
)

(set! default-material (make material-function (epsilon-func level-set-eps)))
