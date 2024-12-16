;; Donation Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))

;; Data Variables
(define-data-var total-donations uint u0)

;; Data Maps
(define-map donations
  { donation-id: uint }
  {
    donor: principal,
    amount: uint,
    charity-id: uint,
    timestamp: uint
  }
)

(define-data-var next-donation-id uint u0)

;; Public Functions
(define-public (donate (amount uint) (charity-id uint))
  (let
    (
      (donation-id (var-get next-donation-id))
    )
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    (map-set donations
      { donation-id: donation-id }
      {
        donor: tx-sender,
        amount: amount,
        charity-id: charity-id,
        timestamp: block-height
      }
    )
    (var-set next-donation-id (+ donation-id u1))
    (var-set total-donations (+ (var-get total-donations) amount))
    (try! (contract-call? .dac allocate-funds charity-id amount))
    (ok donation-id)
  )
)

;; Read-only Functions
(define-read-only (get-donation (donation-id uint))
  (ok (unwrap! (map-get? donations { donation-id: donation-id }) (err u404)))
)

(define-read-only (get-total-donations)
  (ok (var-get total-donations))
)

