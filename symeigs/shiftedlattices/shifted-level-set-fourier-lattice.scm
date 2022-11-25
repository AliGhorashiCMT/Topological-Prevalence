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
(set! geometry-lattice 
(make lattice
	(size 1 1 no-size) 
        (basis1 (list-ref rvecs 0)) (basis2 (list-ref rvecs 1))
        (basis-size (vector3-norm (list-ref rvecs 0)) (vector3-norm (list-ref rvecs 1)) 1)
))
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

(set! default-material (make material-function (epsilon-func level-set-eps)))
