;; Decentralized Autonomous Charity (DAC) Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))

;; Data Variables
(define-data-var total-funds uint u0)

;; Data Maps
(define-map charities
  { charity-id: uint }
  {
    name: (string-ascii 64),
    description: (string-utf8 256),
    funds-allocated: uint
  }
)

(define-data-var next-charity-id uint u0)

;; Public Functions
(define-public (register-charity (name (string-ascii 64)) (description (string-utf8 256)))
  (let
    (
      (charity-id (var-get next-charity-id))
    )
    (map-set charities
      { charity-id: charity-id }
      {
        name: name,
        description: description,
        funds-allocated: u0
      }
    )
    (var-set next-charity-id (+ charity-id u1))
    (ok charity-id)
  )
)

(define-public (allocate-funds (charity-id uint) (amount uint))
  (let
    (
      (charity (unwrap! (map-get? charities { charity-id: charity-id }) err-not-found))
    )
    (map-set charities
      { charity-id: charity-id }
      (merge charity { funds-allocated: (+ (get funds-allocated charity) amount) })
    )
    (var-set total-funds (+ (var-get total-funds) amount))
    (ok true)
  )
)

;; Read-only Functions
(define-read-only (get-charity (charity-id uint))
  (ok (unwrap! (map-get? charities { charity-id: charity-id }) err-not-found))
)

(define-read-only (get-total-funds)
  (ok (var-get total-funds))
)

