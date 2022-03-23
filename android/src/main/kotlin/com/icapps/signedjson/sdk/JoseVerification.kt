package com.icapps.signedjson.sdk

import java.io.ByteArrayOutputStream
import java.util.zip.Inflater
import org.jose4j.jws.JsonWebSignature;
import org.jose4j.jwe.JsonWebEncryption;
import org.jose4j.jwk.*;

object JoseVerification {
    fun verifyAndDecrypt(certVerify: String, certDecrypt: String, encoded: String): ByteArray {
        val zipped = verify(certVerify, encoded)
        val verifiedContent = unzip(zipped)
        return decrypt(certDecrypt, verifiedContent)
    }

    fun verify(cert: String, encoded: String): ByteArray {
        val jws = JsonWebSignature();
        jws.setCompactSerialization(encoded);    
        val jwkSelector = VerificationJwkSelector();
        val jsonWebKeySet = JsonWebKeySet(cert);
        val jwk = jwkSelector.select(jws, jsonWebKeySet.getJsonWebKeys());    
        jws.setKey(jwk.getKey());
        val verified = jws.verifySignature()
        if (verified) {
            return jws.getPayloadBytes()
        }
        return byteArrayOf()
    }

    fun unzip(bytes: ByteArray): String {
        val inflater = Inflater()
        val outputStream = ByteArrayOutputStream()
        return outputStream.use {
            val buffer = ByteArray(1024)
            inflater.setInput(bytes)
            var count = -1
            while (count != 0) {
                count = inflater.inflate(buffer)
                outputStream.write(buffer, 0, count)
            }
            inflater.end()
            outputStream.toString("UTF-8")
        }    
    }

    fun decrypt(cert: String, encoded: String): ByteArray {
        val jwe = JsonWebEncryption();
        jwe.setCompactSerialization(encoded);    
        val jwk = PublicJsonWebKey.Factory.newPublicJwk(cert);
        jwe.setKey(jwk.getPrivateKey());
        return jwe.getPlaintextBytes()
    }
}