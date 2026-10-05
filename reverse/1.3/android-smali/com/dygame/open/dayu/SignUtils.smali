.class public Lcom/dygame/open/dayu/SignUtils;
.super Ljava/lang/Object;
.source "SignUtils.java"


# static fields
.field private static final ALGORITHM:Ljava/lang/String; = "RSA"

.field private static final DEFAULT_CHARSET:Ljava/lang/String; = "UTF-8"

.field private static final SIGN_ALGORITHMS:Ljava/lang/String; = "SHA1WithRSA"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static sign(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 7
    .param p0, "content"    # Ljava/lang/String;
    .param p1, "privateKey"    # Ljava/lang/String;

    .prologue
    .line 17
    :try_start_0
    new-instance v3, Ljava/security/spec/PKCS8EncodedKeySpec;

    .line 18
    invoke-static {p1}, Lcom/dygame/open/dayu/Base64;->decode(Ljava/lang/String;)[B

    move-result-object v6

    invoke-direct {v3, v6}, Ljava/security/spec/PKCS8EncodedKeySpec;-><init>([B)V

    .line 19
    .local v3, "priPKCS8":Ljava/security/spec/PKCS8EncodedKeySpec;
    const-string v6, "RSA"

    invoke-static {v6}, Ljava/security/KeyFactory;->getInstance(Ljava/lang/String;)Ljava/security/KeyFactory;

    move-result-object v1

    .line 20
    .local v1, "keyf":Ljava/security/KeyFactory;
    invoke-virtual {v1, v3}, Ljava/security/KeyFactory;->generatePrivate(Ljava/security/spec/KeySpec;)Ljava/security/PrivateKey;

    move-result-object v2

    .line 22
    .local v2, "priKey":Ljava/security/PrivateKey;
    const-string v6, "SHA1WithRSA"

    .line 23
    invoke-static {v6}, Ljava/security/Signature;->getInstance(Ljava/lang/String;)Ljava/security/Signature;

    move-result-object v4

    .line 25
    .local v4, "signature":Ljava/security/Signature;
    invoke-virtual {v4, v2}, Ljava/security/Signature;->initSign(Ljava/security/PrivateKey;)V

    .line 26
    const-string v6, "UTF-8"

    invoke-virtual {p0, v6}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v6

    invoke-virtual {v4, v6}, Ljava/security/Signature;->update([B)V

    .line 28
    invoke-virtual {v4}, Ljava/security/Signature;->sign()[B

    move-result-object v5

    .line 30
    .local v5, "signed":[B
    invoke-static {v5}, Lcom/dygame/open/dayu/Base64;->encode([B)Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v6

    .line 35
    .end local v1    # "keyf":Ljava/security/KeyFactory;
    .end local v2    # "priKey":Ljava/security/PrivateKey;
    .end local v3    # "priPKCS8":Ljava/security/spec/PKCS8EncodedKeySpec;
    .end local v4    # "signature":Ljava/security/Signature;
    .end local v5    # "signed":[B
    :goto_0
    return-object v6

    .line 31
    :catch_0
    move-exception v0

    .line 32
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 35
    const/4 v6, 0x0

    goto :goto_0
.end method
