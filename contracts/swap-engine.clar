;; Swap Engine Contract

;; Constants
(define-constant err-invalid-swap (err u100))

;; Maps
(define-map swaps
  { swap-id: uint }
  {
    maker: principal,
    taker: principal,
    asset-a: uint,
    asset-b: uint,
    completed: bool
  }
)

(define-data-var next-swap-id uint u0)

;; Public functions
(define-public (create-swap (taker principal) (asset-a uint) (asset-b uint))
  (let
    (
      (swap-id (var-get next-swap-id))
    )
    (map-set swaps
      { swap-id: swap-id }
      {
        maker: tx-sender,
        taker: taker, 
        asset-a: asset-a,
        asset-b: asset-b,
        completed: false
      }
    )
    (var-set next-swap-id (+ swap-id u1))
    (ok swap-id)
  )
)

(define-public (complete-swap (swap-id uint))
  (let
    (
      (swap (unwrap! (map-get? swaps {swap-id: swap-id}) err-invalid-swap))
    )
    (asserts! (is-eq tx-sender (get taker swap)) err-invalid-swap)
    (map-set swaps
      { swap-id: swap-id }
      {
        maker: (get maker swap),
        taker: (get taker swap),
        asset-a: (get asset-a swap),
        asset-b: (get asset-b swap),
        completed: true
      }
    )
    (ok true)
  )
)

;; Read only functions
(define-read-only (get-swap (swap-id uint))
  (map-get? swaps { swap-id: swap-id })
)
