(define-param rvecs    (list (vector3 1 0 0) (vector3 0 1 0) (vector3 0 0 1)))
(define-param uc-gvecs (list (vector3 0 0 0))) ; initialized as constant function
(define-param uc-coefs (list 1.0+0.0i))
(define-param uc-level  0.0)
(define-param epsin    10.0)
(define-param epsout    1.0)

(cond 
    ((equal? dim 1) ; 1D
        (set! geometry-lattice (make lattice
            (size 1 no-size no-size) 
            (basis1 (list-ref rvecs 0))
            (basis-size (vector3-norm (list-ref rvecs 0)) 1 1)
        ))
    )
    ((equal? dim 2) ; 2D
        (set! geometry-lattice (make lattice
            (size 1 1 no-size) 
            (basis1 (list-ref rvecs 0)) (basis2 (list-ref rvecs 1))
            (basis-size (vector3-norm (list-ref rvecs 0)) (vector3-norm (list-ref rvecs 1)) 1)
        ))
    )
    ((equal? dim 3) ; 3D
        (set! geometry-lattice (make lattice
            (size 1 1 1)
            (basis1 (list-ref rvecs 0)) (basis2 (list-ref rvecs 1)) (basis3 (list-ref rvecs 2))
            (basis-size (vector3-norm (list-ref rvecs 0)) (vector3-norm (list-ref rvecs 1)) (vector3-norm (list-ref rvecs 2)))
        ))
    )
)

(add-to-load-path ".") ; ensure the ctl directory is in load path (+ avoid issues w/ paths relative to current working dir)
(load "calc-fourier-sum-fast.scm")

(define (level-set-eps r)
    (cond ((< (calc-fourier-sum-fast r) uc-level) epsin)
          (else epsout))
)


(set! default-material (make material-function (epsilon-func level-set-eps)))
