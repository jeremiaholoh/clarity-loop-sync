;; Asset Registry Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u100))
(define-constant err-already-registered (err u101))

;; Data vars
(define-map assets 
  { asset-id: uint }
  { 
    owner: principal,
    metadata: (string-utf8 256),
    registered: bool
  }
)

(define-data-var next-asset-id uint u0)

;; Public functions
(define-public (register-asset (metadata (string-utf8 256)))
  (let
    (
      (asset-id (var-get next-asset-id))
    )
    (asserts! (is-eq tx-sender contract-owner) err-not-owner)
    (map-set assets
      { asset-id: asset-id }
      {
        owner: tx-sender,
        metadata: metadata,
        registered: true
      }
    )
    (var-set next-asset-id (+ asset-id u1))
    (ok asset-id)
  )
)

;; Read only functions
(define-read-only (get-asset (asset-id uint))
  (map-get? assets { asset-id: asset-id })
)
