; input values
(define-param rvecs    (list (vector3 1 0 0) (vector3 0 1 0) (vector3 0 0 1)))
(define-param uc-gvecs (list (vector3 0 0 0))) ; initialized as constant function
(define-param uc-coefs (list 1.0+0.0i))
(define-param uc-level  0.0)
(define-param epsin    10.0)
(define-param epsout    1.0)
(define-param epsin-diag     '()) ; a vector3:  (εxx εyy εzz) [Cartesian axes]
(define-param epsin-offdiag  '()) ; a cvector3: (εxy εxz εyz) [Cartesian axes]
(define-param epsout-diag    '()) ; a vector3:  (εxx εyy εzz) [Cartesian axes]
(define-param epsout-offdiag '()) ; a cvector3: (εxy εxz εyz) [Cartesian axes]
(define-param origin (vector3 0 0 0))
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
    (cond ((< (calc-fourier-sum-fast (vector3+ r origin)) uc-level) epsin)
          (else epsout))
)

(define-param uc-gvecs-mu '())
(define-param uc-coefs-mu '())
(define-param uc-level-mu 0.0)
(define-param muin        1.0)
(define-param muout       1.0)

(load "calc-fourier-sum-fast-mu-copy.scm")

(define (level-set-mu r)
    (cond ((< (calc-fourier-sum-fast-mu r) uc-level-mu) muin)
          (else muout))
)
(define (level-set-eps-and-mu r)
    (make medium (epsilon (level-set-eps r)) (mu (level-set-mu r)) )
)

(cond 
    ((null? uc-gvecs-mu)  ; nonuniform permittivity & uniform permeabilty (=1)
        (cond 
            ((and (null? epsin-offdiag) (null? epsout-offdiag))
                (set! default-material (make material-function (epsilon-func level-set-eps)))
            )
            (else         ; epsilon tensor
                (print "\nAnisotropic material: a tensorial permittivity with nonzero off-diagonal components was specified...\n")
                (set! default-material (make material-function (material-func level-set-tensor-eps)))
            )
        )
    )
    (else                 ; nonuniform permittivity _and_ permability
        (set! force-mu? true) ; # must set explicitly since we have no objects with μ ≠ 1 (see https://github.com/NanoComp/mpb/issues/39)
        (set! default-material (make material-function (material-func level-set-eps-and-mu)))
    )
)
