# Cryptographic Schemes Implementation

Implementation of 5 cryptographic protocols in PARI/GP on Kali Linux,
applied to a SHA-256 image hash as the shared input across all schemes.

## Tools & Technologies
- PARI/GP (computer algebra system)
- Kali Linux
- 256-bit large integer arithmetic
- secp256k1 elliptic curve

## Hash Used
0faefbb49dfbfef88789ede4dbd753ed8d3b8162898bcdc6e3b06e363f89760a

## Schemes Implemented

| File | Scheme | Description |
|---|---|---|
| `hash_conversion.gp` | Hash Conversion | Hex-to-integer conversion and modular reduction |
| `diffie_hellman.gp` | Diffie-Hellman | 256-bit key exchange with prime generation |
| `elgamal_finite_field.gp` | ElGamal (Finite Field) | Encryption, decryption and digital signature |
| `elgamal_elliptic_curve.gp` | ElGamal (Elliptic Curve) | ECDSA over secp256k1 |
| `pedersen_threshold.gp` | Pedersen Threshold | (2-of-3) threshold signature with Feldman VSS |
| `run_all.gp` | Run All | Runs all 5 components in sequence |

## How to Run
```bash
gp < hash_conversion.gp
gp < diffie_hellman.gp
gp < elgamal_finite_field.gp
gp < elgamal_elliptic_curve.gp
gp < pedersen_threshold.gp
```

## Score
14 / 15 (solo project)
