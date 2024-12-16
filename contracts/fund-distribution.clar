;; Fund Distribution Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-insufficient-funds (err u102))

;; Data Maps
(define-map distributions
  { distribution-id: uint }
  {
    charity-id: uint,
    amount: uint,
    timestamp: uint,
    status: (string-ascii 20)
  }
)

(define-data-var next-distribution-id uint u0)

;; Public Functions
(define-public (create-distribution (charity-id uint) (amount uint))
  (let
    (
      (distribution-id (var-get next-distribution-id))
      (charity (unwrap! (contract-call? .dac get-charity charity-id) err-not-found))
    )
    (asserts! (>= (get funds-allocated charity) amount) err-insufficient-funds)
    (map-set distributions
      { distribution-id: distribution-id }
      {
        charity-id: charity-id,
        amount: amount,
        timestamp: block-height,
        status: "pending"
      }
    )
    (var-set next-distribution-id (+ distribution-id u1))
    (ok distribution-id)
  )
)

(define-public (execute-distribution (distribution-id uint))
  (let
    (
      (distribution (unwrap! (map-get? distributions { distribution-id: distribution-id }) err-not-found))
    )
    (asserts! (is-eq (get status distribution) "pending") (err u403))
    ;; In a real implementation, you would integrate with external payment systems here
    ;; For this example, we'll just update the status
    (map-set distributions
      { distribution-id: distribution-id }
      (merge distribution { status: "executed" })
    )
    (ok true)
  )
)

;; Read-only Functions
(define-read-only (get-distribution (distribution-id uint))
  (ok (unwrap! (map-get? distributions { distribution-id: distribution-id }) err-not-found))
)

