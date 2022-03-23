# signed_json

An implementation to read signed jsons

## How to use it

This is the library that should be used to verify the files generated [sign_config](https://github.com/jeroentrappers/sign_config)

Example -> config/remote_config_sign.sh

## Verify
### Get the sign key
https://mkjwk.org -> EC
- Key Size:P-512
- Key Use: Signature
- Algorithm: ES512: ECDSA using P-521 and SHA-512
- Key ID: Specify: signed_json
- Show X.509: No

Copy the private key

### Get the verify key
Copy the public key

### Decryption
### Get the encryption key
https://mkjwk.org -> RSA
- Key Size:2024
- Key Use: Signature
- Algorithm: PS512
- Key ID: Specify: signed_json
- Show X.509: No

Remove the use/kid/alg

Copy
### Get the decryption key
Copy the encryption key
