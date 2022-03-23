# signed_json

An implementation to read signed jsons

## How to use it

This is the library that should be used to verify the files generated by `https://github.com/jeroentrappers/sign_config`

## Get the sign key
https://mkjwk.org
Key Size:2048
Key Use: Signature
Algorithm: PS512: RSASSA-PSS using SHA-512 and MGF1 with SHA-512
Key ID: Specify: signed_json
Show X.509: No


## Get the verify key
Copy the sign key & Remove `use`, `kid`, `alg` from the private key