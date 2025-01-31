;; Sync Manager Contract

;; Constants
(define-constant err-unauthorized (err u100))
(define-constant err-invalid-state (err u101))

;; Maps
(define-map sync-states
  { account: principal }
  {
    last-sync: uint,
    verified: bool
  }
)

;; Public functions
(define-public (update-sync-state (new-state uint))
  (begin
    (map-set sync-states
      { account: tx-sender }
      {
        last-sync: new-state,
        verified: false
      }
    )
    (ok true)
  )
)

(define-public (verify-sync (account principal))
  (let
    ((current-state (unwrap! (map-get? sync-states {account: account}) err-invalid-state)))
    (asserts! (is-authorized account) err-unauthorized)
    (map-set sync-states
      { account: account }
      {
        last-sync: (get last-sync current-state),
        verified: true
      }
    )
    (ok true)
  )
)

;; Read only functions
(define-read-only (get-sync-state (account principal))
  (map-get? sync-states { account: account })
)

;; Private functions
(define-private (is-authorized (account principal))
  (is-eq tx-sender account)
)
