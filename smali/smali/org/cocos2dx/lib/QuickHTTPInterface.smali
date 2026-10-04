.class public Lorg/cocos2dx/lib/QuickHTTPInterface;
.super Ljava/lang/Object;
.source "QuickHTTPInterface.java"


# static fields
.field static BOUNDARY:Ljava/lang/String;

.field static NEWLINE:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 27
    const-string v0, "----------------------------78631b43218d"

    sput-object v0, Lorg/cocos2dx/lib/QuickHTTPInterface;->BOUNDARY:Ljava/lang/String;

    .line 28
    const-string v0, "\r\n"

    sput-object v0, Lorg/cocos2dx/lib/QuickHTTPInterface;->NEWLINE:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 26
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static addRequestHeader(Ljava/net/HttpURLConnection;Ljava/lang/String;Ljava/lang/String;Z)V
    .locals 2
    .param p0, "http"    # Ljava/net/HttpURLConnection;
    .param p1, "strkey"    # Ljava/lang/String;
    .param p2, "strValue"    # Ljava/lang/String;
    .param p3, "bNeedBoundary"    # Z

    .prologue
    .line 58
    const-string v0, "Content-Type"

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    if-eqz p3, :cond_0

    .line 59
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-static {p2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v1, "; boundary="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v1, Lorg/cocos2dx/lib/QuickHTTPInterface;->BOUNDARY:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 61
    :cond_0
    invoke-virtual {p0, p1, p2}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 62
    return-void
.end method

.method static close(Ljava/net/HttpURLConnection;)V
    .locals 3
    .param p0, "http"    # Ljava/net/HttpURLConnection;

    .prologue
    .line 351
    :try_start_0
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v1

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 355
    :goto_0
    return-void

    .line 352
    :catch_0
    move-exception v0

    .line 353
    .local v0, "e":Ljava/io/IOException;
    const-string v1, "QuickHTTPInterface"

    invoke-virtual {v0}, Ljava/io/IOException;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method public static combinCookies(Ljava/util/List;Ljava/lang/String;)Ljava/lang/String;
    .locals 16
    .param p1, "strDomain"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List",
            "<",
            "Ljava/lang/String;",
            ">;",
            "Ljava/lang/String;",
            ")",
            "Ljava/lang/String;"
        }
    .end annotation

    .prologue
    .line 377
    .local p0, "list":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    .line 379
    .local v6, "sbCookies":Ljava/lang/StringBuilder;
    const/4 v9, 0x0

    .line 380
    .local v9, "strKey":Ljava/lang/String;
    const/4 v10, 0x0

    .line 381
    .local v10, "strValue":Ljava/lang/String;
    const/4 v8, 0x0

    .line 382
    .local v8, "strExpire":Ljava/lang/String;
    const/4 v2, 0x0

    .line 383
    .local v2, "bSecure":Z
    const/4 v1, 0x0

    .line 385
    .local v1, "bFirst":Z
    invoke-interface/range {p0 .. p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v12

    :goto_0
    invoke-interface {v12}, Ljava/util/Iterator;->hasNext()Z

    move-result v11

    if-nez v11, :cond_0

    .line 431
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    return-object v11

    .line 385
    :cond_0
    invoke-interface {v12}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/String;

    .line 386
    .local v7, "str":Ljava/lang/String;
    const/4 v2, 0x0

    .line 387
    const/4 v1, 0x1

    .line 388
    const-string v11, ";"

    invoke-virtual {v7, v11}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v5

    .line 389
    .local v5, "parts":[Ljava/lang/String;
    array-length v13, v5

    const/4 v11, 0x0

    :goto_1
    if-lt v11, v13, :cond_2

    .line 410
    if-nez p1, :cond_1

    .line 411
    const-string p1, "none"

    .line 414
    :cond_1
    move-object/from16 v0, p1

    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 415
    const/16 v11, 0x9

    invoke-virtual {v6, v11}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 416
    const-string v11, "FALSE\t"

    invoke-virtual {v6, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 417
    const-string v11, "/\t"

    invoke-virtual {v6, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 418
    if-eqz v2, :cond_8

    .line 419
    const-string v11, "TRUE\t"

    invoke-virtual {v6, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 423
    :goto_2
    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 424
    const-string v11, "\t"

    invoke-virtual {v6, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 425
    invoke-virtual {v6, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 426
    const-string v11, "\t"

    invoke-virtual {v6, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 427
    invoke-virtual {v6, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 428
    const/16 v11, 0xa

    invoke-virtual {v6, v11}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto :goto_0

    .line 389
    :cond_2
    aget-object v4, v5, v11

    .line 390
    .local v4, "part":Ljava/lang/String;
    const-string v14, "="

    invoke-virtual {v4, v14}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    .line 391
    .local v3, "item":[Ljava/lang/String;
    if-eqz v1, :cond_3

    .line 392
    const/4 v14, 0x2

    array-length v15, v3

    if-ne v14, v15, :cond_5

    .line 393
    const/4 v14, 0x0

    aget-object v9, v3, v14

    .line 394
    const/4 v14, 0x1

    aget-object v10, v3, v14

    .line 399
    :goto_3
    const/4 v1, 0x0

    .line 401
    :cond_3
    const-string v14, "expires"

    const/4 v15, 0x0

    aget-object v15, v3, v15

    invoke-virtual {v15}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v15

    invoke-virtual {v14, v15}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v14

    if-eqz v14, :cond_6

    .line 402
    const/4 v14, 0x1

    aget-object v14, v3, v14

    invoke-virtual {v14}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v14

    invoke-static {v14}, Lorg/cocos2dx/lib/QuickHTTPInterface;->str2Seconds(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    .line 389
    :cond_4
    :goto_4
    add-int/lit8 v11, v11, 0x1

    goto :goto_1

    .line 396
    :cond_5
    const-string v9, ""

    .line 397
    const-string v10, ""

    goto :goto_3

    .line 403
    :cond_6
    const-string v14, "secure"

    const/4 v15, 0x0

    aget-object v15, v3, v15

    invoke-virtual {v15}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v15

    invoke-virtual {v14, v15}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v14

    if-eqz v14, :cond_7

    .line 404
    const/4 v2, 0x1

    .line 405
    goto :goto_4

    :cond_7
    const-string v14, "domain"

    const/4 v15, 0x0

    aget-object v15, v3, v15

    invoke-virtual {v15}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v15

    invoke-virtual {v14, v15}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v14

    if-eqz v14, :cond_4

    .line 406
    const/4 v14, 0x1

    aget-object p1, v3, v14

    goto :goto_4

    .line 421
    .end local v3    # "item":[Ljava/lang/String;
    .end local v4    # "part":Ljava/lang/String;
    :cond_8
    const-string v11, "FALSE\t"

    invoke-virtual {v6, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_2
.end method

.method static connect(Ljava/net/HttpURLConnection;)I
    .locals 4
    .param p0, "http"    # Ljava/net/HttpURLConnection;

    .prologue
    .line 70
    const/4 v1, 0x0

    .line 73
    .local v1, "nSuc":I
    :try_start_0
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->connect()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 79
    :goto_0
    return v1

    .line 74
    :catch_0
    move-exception v0

    .line 75
    .local v0, "e":Ljava/io/IOException;
    const-string v2, "QuickHTTPInterface"

    invoke-virtual {v0}, Ljava/io/IOException;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 76
    const/4 v1, 0x1

    goto :goto_0
.end method

.method static createURLConnect(Ljava/lang/String;)Ljava/net/HttpURLConnection;
    .locals 5
    .param p0, "strURL"    # Ljava/lang/String;

    .prologue
    .line 34
    :try_start_0
    new-instance v1, Ljava/net/URL;

    invoke-direct {v1, p0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    .line 35
    .local v1, "url":Ljava/net/URL;
    invoke-virtual {v1}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v2

    check-cast v2, Ljava/net/HttpURLConnection;

    .line 36
    .local v2, "urlConnection":Ljava/net/HttpURLConnection;
    const-string v3, "Accept-Encoding"

    const-string v4, "identity"

    invoke-virtual {v2, v3, v4}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 37
    const/4 v3, 0x1

    invoke-virtual {v2, v3}, Ljava/net/HttpURLConnection;->setDoInput(Z)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 43
    .end local v1    # "url":Ljava/net/URL;
    .end local v2    # "urlConnection":Ljava/net/HttpURLConnection;
    :goto_0
    return-object v2

    .line 38
    :catch_0
    move-exception v0

    .line 39
    .local v0, "e":Ljava/lang/Exception;
    const-string v3, "QuickHTTPInterface"

    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 40
    const/4 v2, 0x0

    goto :goto_0
.end method

.method static getBoundaryContentHeader(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    .param p0, "key"    # Ljava/lang/String;
    .param p1, "val"    # Ljava/lang/String;

    .prologue
    .line 186
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 187
    .local v0, "sb":Ljava/lang/StringBuilder;
    const-string v1, "--"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 188
    sget-object v1, Lorg/cocos2dx/lib/QuickHTTPInterface;->BOUNDARY:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 189
    sget-object v1, Lorg/cocos2dx/lib/QuickHTTPInterface;->NEWLINE:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 190
    const-string v1, "Content-Disposition: form-data; name=\""

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 191
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 192
    const-string v1, "\""

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 193
    sget-object v1, Lorg/cocos2dx/lib/QuickHTTPInterface;->NEWLINE:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 194
    sget-object v1, Lorg/cocos2dx/lib/QuickHTTPInterface;->NEWLINE:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 195
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 196
    sget-object v1, Lorg/cocos2dx/lib/QuickHTTPInterface;->NEWLINE:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 198
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    return-object v1
.end method

.method static getBoundaryEnd()Ljava/lang/String;
    .locals 2

    .prologue
    .line 202
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 203
    .local v0, "sb":Ljava/lang/StringBuilder;
    const-string v1, "--"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 204
    sget-object v1, Lorg/cocos2dx/lib/QuickHTTPInterface;->BOUNDARY:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 205
    const-string v1, "--"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 206
    sget-object v1, Lorg/cocos2dx/lib/QuickHTTPInterface;->NEWLINE:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 208
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    return-object v1
.end method

.method static getBoundaryFileHeader(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 3
    .param p0, "key"    # Ljava/lang/String;
    .param p1, "filePath"    # Ljava/lang/String;

    .prologue
    .line 165
    new-instance v0, Ljava/io/File;

    invoke-direct {v0, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 166
    .local v0, "file":Ljava/io/File;
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 167
    .local v1, "sb":Ljava/lang/StringBuilder;
    const-string v2, "--"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 168
    sget-object v2, Lorg/cocos2dx/lib/QuickHTTPInterface;->BOUNDARY:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 169
    sget-object v2, Lorg/cocos2dx/lib/QuickHTTPInterface;->NEWLINE:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 170
    const-string v2, "Content-Disposition: form-data; "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 171
    const-string v2, "name=\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 172
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 173
    const-string v2, "\"; "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 174
    const-string v2, "filename=\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 175
    invoke-virtual {v0}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 176
    const-string v2, "\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 177
    sget-object v2, Lorg/cocos2dx/lib/QuickHTTPInterface;->NEWLINE:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 178
    const-string v2, "Content-Type: application/octet-stream"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 179
    sget-object v2, Lorg/cocos2dx/lib/QuickHTTPInterface;->NEWLINE:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 180
    sget-object v2, Lorg/cocos2dx/lib/QuickHTTPInterface;->NEWLINE:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 182
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    return-object v2
.end method

.method static getContentLeng(Ljava/net/HttpURLConnection;)I
    .locals 1
    .param p0, "http"    # Ljava/net/HttpURLConnection;

    .prologue
    .line 321
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getContentLength()I

    move-result v0

    return v0
.end method

.method static getResponedCode(Ljava/net/HttpURLConnection;)I
    .locals 4
    .param p0, "http"    # Ljava/net/HttpURLConnection;

    .prologue
    .line 212
    const/4 v0, 0x0

    .line 214
    .local v0, "code":I
    :try_start_0
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getResponseCode()I
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    move-result v0

    .line 219
    :goto_0
    return v0

    .line 216
    :catch_0
    move-exception v1

    .line 217
    .local v1, "e":Ljava/io/IOException;
    const-string v2, "QuickHTTPInterface"

    invoke-virtual {v1}, Ljava/io/IOException;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method static getResponedErr(Ljava/net/HttpURLConnection;)Ljava/lang/String;
    .locals 3
    .param p0, "http"    # Ljava/net/HttpURLConnection;

    .prologue
    .line 225
    :try_start_0
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getResponseMessage()Ljava/lang/String;
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v1

    .line 231
    .local v1, "msg":Ljava/lang/String;
    :goto_0
    return-object v1

    .line 226
    .end local v1    # "msg":Ljava/lang/String;
    :catch_0
    move-exception v0

    .line 227
    .local v0, "e":Ljava/io/IOException;
    invoke-virtual {v0}, Ljava/io/IOException;->toString()Ljava/lang/String;

    move-result-object v1

    .line 228
    .restart local v1    # "msg":Ljava/lang/String;
    const-string v2, "QuickHTTPInterface"

    invoke-static {v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method static getResponedHeader(Ljava/net/HttpURLConnection;)Ljava/lang/String;
    .locals 11
    .param p0, "http"    # Ljava/net/HttpURLConnection;

    .prologue
    .line 235
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getHeaderFields()Ljava/util/Map;

    move-result-object v2

    .line 237
    .local v2, "headers":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Ljava/util/List<Ljava/lang/String;>;>;"
    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3}, Lorg/json/JSONObject;-><init>()V

    .line 239
    .local v3, "json":Lorg/json/JSONObject;
    :try_start_0
    invoke-interface {v2}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v8

    invoke-interface {v8}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v8

    :goto_0
    invoke-interface {v8}, Ljava/util/Iterator;->hasNext()Z
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    move-result v9

    if-nez v9, :cond_0

    .line 255
    :goto_1
    invoke-virtual {v3}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v8

    return-object v8

    .line 239
    :cond_0
    :try_start_1
    invoke-interface {v8}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map$Entry;

    .line 240
    .local v1, "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Ljava/lang/String;Ljava/util/List<Ljava/lang/String;>;>;"
    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/String;

    .line 241
    .local v5, "key":Ljava/lang/String;
    if-nez v5, :cond_1

    .line 242
    const-string v5, ""

    .line 244
    :cond_1
    invoke-interface {v1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/util/List;

    .line 245
    .local v7, "value":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    new-instance v4, Lorg/json/JSONArray;

    invoke-direct {v4}, Lorg/json/JSONArray;-><init>()V

    .line 246
    .local v4, "jsonArray":Lorg/json/JSONArray;
    invoke-interface {v7}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v9

    :goto_2
    invoke-interface {v9}, Ljava/util/Iterator;->hasNext()Z

    move-result v10

    if-nez v10, :cond_2

    .line 249
    invoke-virtual {v3, v5, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_1
    .catch Lorg/json/JSONException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    .line 251
    .end local v1    # "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Ljava/lang/String;Ljava/util/List<Ljava/lang/String;>;>;"
    .end local v4    # "jsonArray":Lorg/json/JSONArray;
    .end local v5    # "key":Ljava/lang/String;
    .end local v7    # "value":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    :catch_0
    move-exception v0

    .line 252
    .local v0, "e":Lorg/json/JSONException;
    const-string v8, "QuickHTTPInterface"

    invoke-virtual {v0}, Lorg/json/JSONException;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-static {v8, v9}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1

    .line 246
    .end local v0    # "e":Lorg/json/JSONException;
    .restart local v1    # "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Ljava/lang/String;Ljava/util/List<Ljava/lang/String;>;>;"
    .restart local v4    # "jsonArray":Lorg/json/JSONArray;
    .restart local v5    # "key":Ljava/lang/String;
    .restart local v7    # "value":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    :cond_2
    :try_start_2
    invoke-interface {v9}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/String;

    .line 247
    .local v6, "strVal":Ljava/lang/String;
    invoke-virtual {v4, v6}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;
    :try_end_2
    .catch Lorg/json/JSONException; {:try_start_2 .. :try_end_2} :catch_0

    goto :goto_2
.end method

.method static getResponedHeaderByIdx(Ljava/net/HttpURLConnection;I)Ljava/lang/String;
    .locals 8
    .param p0, "http"    # Ljava/net/HttpURLConnection;
    .param p1, "idx"    # I

    .prologue
    .line 259
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getHeaderFields()Ljava/util/Map;

    move-result-object v3

    .line 260
    .local v3, "headers":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Ljava/util/List<Ljava/lang/String;>;>;"
    if-nez v3, :cond_1

    .line 261
    const/4 v2, 0x0

    .line 280
    :cond_0
    :goto_0
    return-object v2

    .line 264
    :cond_1
    const/4 v2, 0x0

    .line 266
    .local v2, "header":Ljava/lang/String;
    const/4 v0, 0x0

    .line 267
    .local v0, "counter":I
    invoke-interface {v3}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v5

    invoke-interface {v5}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v5

    :goto_1
    invoke-interface {v5}, Ljava/util/Iterator;->hasNext()Z

    move-result v6

    if-eqz v6, :cond_0

    invoke-interface {v5}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map$Entry;

    .line 268
    .local v1, "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Ljava/lang/String;Ljava/util/List<Ljava/lang/String;>;>;"
    if-ne v0, p1, :cond_3

    .line 269
    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    .line 270
    .local v4, "key":Ljava/lang/String;
    if-nez v4, :cond_2

    .line 271
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-interface {v1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/util/List;

    const-string v7, ","

    invoke-static {v5, v7}, Lorg/cocos2dx/lib/QuickHTTPInterface;->listToString(Ljava/util/List;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    invoke-direct {v6, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v5, "\n"

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 272
    goto :goto_0

    .line 273
    :cond_2
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v6

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v6, ":"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-interface {v1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/util/List;

    const-string v7, ","

    invoke-static {v5, v7}, Lorg/cocos2dx/lib/QuickHTTPInterface;->listToString(Ljava/util/List;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "\n"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 275
    goto :goto_0

    .line 277
    .end local v4    # "key":Ljava/lang/String;
    :cond_3
    add-int/lit8 v0, v0, 0x1

    goto :goto_1
.end method

.method static getResponedHeaderByKey(Ljava/net/HttpURLConnection;Ljava/lang/String;)Ljava/lang/String;
    .locals 5
    .param p0, "http"    # Ljava/net/HttpURLConnection;
    .param p1, "key"    # Ljava/lang/String;

    .prologue
    const/4 v1, 0x0

    .line 284
    if-nez p1, :cond_1

    .line 307
    :cond_0
    :goto_0
    return-object v1

    .line 288
    :cond_1
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getHeaderFields()Ljava/util/Map;

    move-result-object v2

    .line 289
    .local v2, "headers":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Ljava/util/List<Ljava/lang/String;>;>;"
    if-eqz v2, :cond_0

    .line 293
    const/4 v1, 0x0

    .line 295
    .local v1, "header":Ljava/lang/String;
    invoke-interface {v2}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :cond_2
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_0

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Map$Entry;

    .line 296
    .local v0, "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Ljava/lang/String;Ljava/util/List<Ljava/lang/String;>;>;"
    invoke-interface {v0}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    invoke-virtual {p1, v3}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_2

    .line 298
    const-string v3, "set-cookie"

    invoke-virtual {v3, p1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_3

    .line 299
    invoke-interface {v0}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/util/List;

    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getURL()Ljava/net/URL;

    move-result-object v4

    invoke-virtual {v4}, Ljava/net/URL;->getHost()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4}, Lorg/cocos2dx/lib/QuickHTTPInterface;->combinCookies(Ljava/util/List;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 300
    goto :goto_0

    .line 301
    :cond_3
    invoke-interface {v0}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/util/List;

    const-string v4, ","

    invoke-static {v3, v4}, Lorg/cocos2dx/lib/QuickHTTPInterface;->listToString(Ljava/util/List;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 303
    goto :goto_0
.end method

.method static getResponedHeaderByKeyInt(Ljava/net/HttpURLConnection;Ljava/lang/String;)I
    .locals 2
    .param p0, "http"    # Ljava/net/HttpURLConnection;
    .param p1, "key"    # Ljava/lang/String;

    .prologue
    .line 311
    invoke-virtual {p0, p1}, Ljava/net/HttpURLConnection;->getHeaderField(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 313
    .local v0, "value":Ljava/lang/String;
    if-nez v0, :cond_0

    .line 314
    const/4 v1, 0x0

    .line 316
    :goto_0
    return v1

    :cond_0
    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v1

    goto :goto_0
.end method

.method static getResponedString(Ljava/net/HttpURLConnection;)[B
    .locals 7
    .param p0, "http"    # Ljava/net/HttpURLConnection;

    .prologue
    .line 326
    :try_start_0
    new-instance v2, Ljava/io/DataInputStream;

    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v5

    invoke-direct {v2, v5}, Ljava/io/DataInputStream;-><init>(Ljava/io/InputStream;)V

    .line 328
    .local v2, "in":Ljava/io/DataInputStream;
    const/16 v5, 0x400

    new-array v0, v5, [B

    .line 329
    .local v0, "buffer":[B
    const/4 v4, 0x0

    .line 330
    .local v4, "retBuf":[B
    invoke-virtual {v2, v0}, Ljava/io/DataInputStream;->read([B)I

    move-result v3

    .line 333
    .local v3, "len":I
    const/4 v5, -0x1

    if-ne v5, v3, :cond_0

    .line 334
    const/4 v5, 0x1

    new-array v4, v5, [B

    .line 335
    const/4 v5, 0x0

    const/4 v6, 0x0

    aput-byte v6, v4, v5

    .line 346
    .end local v0    # "buffer":[B
    .end local v2    # "in":Ljava/io/DataInputStream;
    .end local v3    # "len":I
    .end local v4    # "retBuf":[B
    :goto_0
    return-object v4

    .line 337
    .restart local v0    # "buffer":[B
    .restart local v2    # "in":Ljava/io/DataInputStream;
    .restart local v3    # "len":I
    .restart local v4    # "retBuf":[B
    :cond_0
    add-int/lit8 v5, v3, 0x1

    new-array v4, v5, [B

    .line 338
    const/4 v5, 0x0

    const/4 v6, 0x1

    aput-byte v6, v4, v5

    .line 339
    const/4 v5, 0x0

    const/4 v6, 0x1

    invoke-static {v0, v5, v4, v6, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 342
    .end local v0    # "buffer":[B
    .end local v2    # "in":Ljava/io/DataInputStream;
    .end local v3    # "len":I
    .end local v4    # "retBuf":[B
    :catch_0
    move-exception v1

    .line 343
    .local v1, "e":Ljava/io/IOException;
    const-string v5, "QuickHTTPInterface"

    invoke-virtual {v1}, Ljava/io/IOException;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v5, v6}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 346
    const/4 v4, 0x0

    goto :goto_0
.end method

.method public static listToString(Ljava/util/List;Ljava/lang/String;)Ljava/lang/String;
    .locals 5
    .param p1, "strInterVal"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List",
            "<",
            "Ljava/lang/String;",
            ">;",
            "Ljava/lang/String;",
            ")",
            "Ljava/lang/String;"
        }
    .end annotation

    .prologue
    .line 358
    .local p0, "list":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    if-nez p0, :cond_0

    .line 359
    const/4 v3, 0x0

    .line 373
    :goto_0
    return-object v3

    .line 361
    :cond_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 362
    .local v1, "result":Ljava/lang/StringBuilder;
    const/4 v0, 0x0

    .line 363
    .local v0, "flag":Z
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_1
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-nez v4, :cond_1

    .line 373
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    goto :goto_0

    .line 363
    :cond_1
    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 364
    .local v2, "str":Ljava/lang/String;
    if-eqz v0, :cond_2

    .line 365
    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 367
    :cond_2
    if-nez v2, :cond_3

    .line 368
    const-string v2, ""

    .line 370
    :cond_3
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 371
    const/4 v0, 0x1

    goto :goto_1
.end method

.method static postContent(Ljava/net/HttpURLConnection;Ljava/lang/String;Ljava/lang/String;Z)V
    .locals 5
    .param p0, "http"    # Ljava/net/HttpURLConnection;
    .param p1, "name"    # Ljava/lang/String;
    .param p2, "value"    # Ljava/lang/String;
    .param p3, "bNeedConnectSym"    # Z

    .prologue
    .line 84
    :try_start_0
    new-instance v2, Ljava/io/DataOutputStream;

    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/io/DataOutputStream;-><init>(Ljava/io/OutputStream;)V

    .line 85
    .local v2, "out":Ljava/io/DataOutputStream;
    const/4 v0, 0x0

    .line 86
    .local v0, "content":Ljava/lang/String;
    if-eqz p1, :cond_0

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v3

    if-nez v3, :cond_2

    .line 87
    :cond_0
    move-object v0, p2

    .line 91
    :goto_0
    if-eqz p3, :cond_1

    .line 92
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "&"

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 94
    :cond_1
    invoke-virtual {v0}, Ljava/lang/String;->getBytes()[B

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/io/DataOutputStream;->write([B)V

    .line 95
    invoke-virtual {v2}, Ljava/io/DataOutputStream;->flush()V

    .line 99
    .end local v0    # "content":Ljava/lang/String;
    .end local v2    # "out":Ljava/io/DataOutputStream;
    :goto_1
    return-void

    .line 89
    .restart local v0    # "content":Ljava/lang/String;
    .restart local v2    # "out":Ljava/io/DataOutputStream;
    :cond_2
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v4, "="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v0

    goto :goto_0

    .line 96
    .end local v0    # "content":Ljava/lang/String;
    .end local v2    # "out":Ljava/io/DataOutputStream;
    :catch_0
    move-exception v1

    .line 97
    .local v1, "e":Ljava/io/IOException;
    const-string v3, "QuickHTTPInterface"

    invoke-virtual {v1}, Ljava/io/IOException;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1
.end method

.method static postContentByteArray(Ljava/net/HttpURLConnection;[B)V
    .locals 4
    .param p0, "http"    # Ljava/net/HttpURLConnection;
    .param p1, "byteArray"    # [B

    .prologue
    .line 103
    :try_start_0
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v1

    .line 105
    .local v1, "out":Ljava/io/OutputStream;
    invoke-virtual {v1, p1}, Ljava/io/OutputStream;->write([B)V

    .line 107
    invoke-virtual {v1}, Ljava/io/OutputStream;->flush()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 111
    .end local v1    # "out":Ljava/io/OutputStream;
    :goto_0
    return-void

    .line 108
    :catch_0
    move-exception v0

    .line 109
    .local v0, "e":Ljava/io/IOException;
    const-string v2, "QuickHTTPInterface"

    invoke-virtual {v0}, Ljava/io/IOException;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method static postFormContent(Ljava/net/HttpURLConnection;Ljava/lang/String;Ljava/lang/String;)V
    .locals 4
    .param p0, "http"    # Ljava/net/HttpURLConnection;
    .param p1, "key"    # Ljava/lang/String;
    .param p2, "val"    # Ljava/lang/String;

    .prologue
    .line 115
    :try_start_0
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v1

    .line 117
    .local v1, "out":Ljava/io/OutputStream;
    invoke-static {p1, p2}, Lorg/cocos2dx/lib/QuickHTTPInterface;->getBoundaryContentHeader(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->getBytes()[B

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/io/OutputStream;->write([B)V

    .line 119
    invoke-virtual {v1}, Ljava/io/OutputStream;->flush()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 123
    .end local v1    # "out":Ljava/io/OutputStream;
    :goto_0
    return-void

    .line 120
    :catch_0
    move-exception v0

    .line 121
    .local v0, "e":Ljava/io/IOException;
    const-string v2, "QuickHTTPInterface"

    invoke-virtual {v0}, Ljava/io/IOException;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method static postFormEnd(Ljava/net/HttpURLConnection;Z)V
    .locals 4
    .param p0, "http"    # Ljava/net/HttpURLConnection;
    .param p1, "bBoundary"    # Z

    .prologue
    .line 147
    const-string v2, "GET"

    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getRequestMethod()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 162
    :goto_0
    return-void

    .line 152
    :cond_0
    :try_start_0
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v1

    .line 154
    .local v1, "out":Ljava/io/OutputStream;
    if-eqz p1, :cond_1

    .line 155
    invoke-static {}, Lorg/cocos2dx/lib/QuickHTTPInterface;->getBoundaryEnd()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->getBytes()[B

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/io/OutputStream;->write([B)V

    .line 156
    invoke-virtual {v1}, Ljava/io/OutputStream;->flush()V

    .line 158
    :cond_1
    invoke-virtual {v1}, Ljava/io/OutputStream;->close()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 159
    .end local v1    # "out":Ljava/io/OutputStream;
    :catch_0
    move-exception v0

    .line 160
    .local v0, "e":Ljava/io/IOException;
    const-string v2, "QuickHTTPInterface"

    invoke-virtual {v0}, Ljava/io/IOException;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method static postFormFile(Ljava/net/HttpURLConnection;Ljava/lang/String;Ljava/lang/String;)V
    .locals 7
    .param p0, "http"    # Ljava/net/HttpURLConnection;
    .param p1, "name"    # Ljava/lang/String;
    .param p2, "filePath"    # Ljava/lang/String;

    .prologue
    .line 127
    :try_start_0
    new-instance v2, Ljava/io/FileInputStream;

    invoke-direct {v2, p2}, Ljava/io/FileInputStream;-><init>(Ljava/lang/String;)V

    .line 128
    .local v2, "fin":Ljava/io/FileInputStream;
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v4

    .line 131
    .local v4, "out":Ljava/io/OutputStream;
    invoke-static {p1, p2}, Lorg/cocos2dx/lib/QuickHTTPInterface;->getBoundaryFileHeader(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/String;->getBytes()[B

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/io/OutputStream;->write([B)V

    .line 132
    const/16 v5, 0x400

    new-array v0, v5, [B

    .line 133
    .local v0, "buffer":[B
    const/4 v3, 0x0

    .line 134
    .local v3, "len":I
    :goto_0
    invoke-virtual {v2, v0}, Ljava/io/FileInputStream;->read([B)I

    move-result v3

    const/4 v5, -0x1

    if-ne v3, v5, :cond_0

    .line 137
    sget-object v5, Lorg/cocos2dx/lib/QuickHTTPInterface;->NEWLINE:Ljava/lang/String;

    invoke-virtual {v5}, Ljava/lang/String;->getBytes()[B

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/io/OutputStream;->write([B)V

    .line 139
    invoke-virtual {v4}, Ljava/io/OutputStream;->flush()V

    .line 140
    invoke-virtual {v2}, Ljava/io/FileInputStream;->close()V

    .line 144
    .end local v0    # "buffer":[B
    .end local v2    # "fin":Ljava/io/FileInputStream;
    .end local v3    # "len":I
    .end local v4    # "out":Ljava/io/OutputStream;
    :goto_1
    return-void

    .line 135
    .restart local v0    # "buffer":[B
    .restart local v2    # "fin":Ljava/io/FileInputStream;
    .restart local v3    # "len":I
    .restart local v4    # "out":Ljava/io/OutputStream;
    :cond_0
    const/4 v5, 0x0

    invoke-virtual {v4, v0, v5, v3}, Ljava/io/OutputStream;->write([BII)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 141
    .end local v0    # "buffer":[B
    .end local v2    # "fin":Ljava/io/FileInputStream;
    .end local v3    # "len":I
    .end local v4    # "out":Ljava/io/OutputStream;
    :catch_0
    move-exception v1

    .line 142
    .local v1, "e":Ljava/io/IOException;
    const-string v5, "QuickHTTPInterface"

    invoke-virtual {v1}, Ljava/io/IOException;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v5, v6}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1
.end method

.method static setRequestMethod(Ljava/net/HttpURLConnection;Ljava/lang/String;)V
    .locals 3
    .param p0, "http"    # Ljava/net/HttpURLConnection;
    .param p1, "strMedthod"    # Ljava/lang/String;

    .prologue
    .line 48
    :try_start_0
    const-string v1, "POST"

    invoke-virtual {v1, p1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 49
    const/4 v1, 0x1

    invoke-virtual {p0, v1}, Ljava/net/HttpURLConnection;->setDoOutput(Z)V

    .line 51
    :cond_0
    invoke-virtual {p0, p1}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/net/ProtocolException; {:try_start_0 .. :try_end_0} :catch_0

    .line 55
    :goto_0
    return-void

    .line 52
    :catch_0
    move-exception v0

    .line 53
    .local v0, "e":Ljava/net/ProtocolException;
    const-string v1, "QuickHTTPInterface"

    invoke-virtual {v0}, Ljava/net/ProtocolException;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method static setTimeout(Ljava/net/HttpURLConnection;I)V
    .locals 0
    .param p0, "http"    # Ljava/net/HttpURLConnection;
    .param p1, "msTime"    # I

    .prologue
    .line 65
    invoke-virtual {p0, p1}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    .line 66
    invoke-virtual {p0, p1}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    .line 67
    return-void
.end method

.method private static str2Seconds(Ljava/lang/String;)Ljava/lang/String;
    .locals 8
    .param p0, "strTime"    # Ljava/lang/String;

    .prologue
    .line 435
    invoke-static {}, Ljava/util/Calendar;->getInstance()Ljava/util/Calendar;

    move-result-object v0

    .line 436
    .local v0, "c":Ljava/util/Calendar;
    const-wide/16 v2, 0x0

    .line 439
    .local v2, "millisSecond":J
    :try_start_0
    new-instance v4, Ljava/text/SimpleDateFormat;

    const-string v5, "EEE, dd-MMM-yyyy hh:mm:ss zzz"

    sget-object v6, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-direct {v4, v5, v6}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    invoke-virtual {v4, p0}, Ljava/text/SimpleDateFormat;->parse(Ljava/lang/String;)Ljava/util/Date;

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/util/Calendar;->setTime(Ljava/util/Date;)V

    .line 440
    invoke-virtual {v0}, Ljava/util/Calendar;->getTimeInMillis()J

    move-result-wide v4

    const-wide/16 v6, 0x3e8

    div-long v2, v4, v6
    :try_end_0
    .catch Ljava/text/ParseException; {:try_start_0 .. :try_end_0} :catch_0

    .line 446
    :goto_0
    const-wide/16 v4, -0x1

    cmp-long v4, v4, v2

    if-nez v4, :cond_0

    .line 450
    .end local p0    # "strTime":Ljava/lang/String;
    :goto_1
    return-object p0

    .line 441
    .restart local p0    # "strTime":Ljava/lang/String;
    :catch_0
    move-exception v1

    .line 442
    .local v1, "e":Ljava/text/ParseException;
    const-wide/16 v2, -0x1

    goto :goto_0

    .line 450
    .end local v1    # "e":Ljava/text/ParseException;
    :cond_0
    invoke-static {v2, v3}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object p0

    goto :goto_1
.end method
