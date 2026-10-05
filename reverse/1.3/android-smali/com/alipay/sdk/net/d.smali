.class public final Lcom/alipay/sdk/net/d;
.super Ljava/lang/Object;
.source "SourceFile"


# instance fields
.field private a:I

.field private b:Lcom/alipay/sdk/data/c;


# direct methods
.method public constructor <init>()V
    .locals 1

    .prologue
    .line 55
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 45
    const/4 v0, 0x0

    iput v0, p0, Lcom/alipay/sdk/net/d;->a:I

    .line 57
    return-void
.end method

.method public constructor <init>(Lcom/alipay/sdk/data/c;)V
    .locals 1

    .prologue
    .line 51
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 45
    const/4 v0, 0x0

    iput v0, p0, Lcom/alipay/sdk/net/d;->a:I

    .line 52
    iput-object p1, p0, Lcom/alipay/sdk/net/d;->b:Lcom/alipay/sdk/data/c;

    .line 53
    return-void
.end method

.method private a(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Lcom/alipay/sdk/data/c;Lcom/alipay/sdk/data/f;)Ljava/lang/String;
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/alipay/sdk/exception/NetErrorException;
        }
    .end annotation

    .prologue
    const/4 v4, 0x0

    .line 191
    :try_start_0
    sget-object v0, Lcom/alipay/sdk/net/c;->a:Lcom/alipay/sdk/net/a;

    if-nez v0, :cond_2

    new-instance v0, Lcom/alipay/sdk/net/a;

    invoke-direct {v0, p1, p2}, Lcom/alipay/sdk/net/a;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    sput-object v0, Lcom/alipay/sdk/net/c;->a:Lcom/alipay/sdk/net/a;

    :cond_0
    :goto_0
    if-eqz p4, :cond_3

    sget-object v0, Lcom/alipay/sdk/net/c;->a:Lcom/alipay/sdk/net/a;

    invoke-virtual {v0, p3, p4}, Lcom/alipay/sdk/net/a;->a(Ljava/lang/String;Lcom/alipay/sdk/data/c;)Lorg/apache/http/HttpResponse;

    move-result-object v0

    .line 195
    :goto_1
    invoke-interface {v0}, Lorg/apache/http/HttpResponse;->getStatusLine()Lorg/apache/http/StatusLine;

    move-result-object v1

    .line 196
    invoke-interface {v1}, Lorg/apache/http/StatusLine;->getStatusCode()I

    move-result v2

    iput v2, p5, Lcom/alipay/sdk/data/f;->c:I

    .line 197
    invoke-interface {v1}, Lorg/apache/http/StatusLine;->getReasonPhrase()Ljava/lang/String;

    move-result-object v1

    iput-object v1, p5, Lcom/alipay/sdk/data/f;->d:Ljava/lang/String;

    .line 199
    iget-object v1, p0, Lcom/alipay/sdk/net/d;->b:Lcom/alipay/sdk/data/c;

    const-string v2, "Msp-Param"

    invoke-interface {v0, v2}, Lorg/apache/http/HttpResponse;->getHeaders(Ljava/lang/String;)[Lorg/apache/http/Header;

    move-result-object v2

    if-eqz v1, :cond_1

    array-length v3, v2

    if-lez v3, :cond_1

    iput-object v2, v1, Lcom/alipay/sdk/data/c;->b:[Lorg/apache/http/Header;

    .line 201
    :cond_1
    invoke-static {v0}, Lcom/alipay/sdk/net/c;->a(Lorg/apache/http/HttpResponse;)Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move-result-object v0

    .line 207
    sput-object v4, Lcom/alipay/sdk/net/c;->a:Lcom/alipay/sdk/net/a;

    return-object v0

    .line 191
    :cond_2
    :try_start_1
    sget-object v0, Lcom/alipay/sdk/net/c;->a:Lcom/alipay/sdk/net/a;

    iget-object v0, v0, Lcom/alipay/sdk/net/a;->a:Ljava/lang/String;

    invoke-static {p2, v0}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_0

    sget-object v0, Lcom/alipay/sdk/net/c;->a:Lcom/alipay/sdk/net/a;

    iput-object p2, v0, Lcom/alipay/sdk/net/a;->a:Ljava/lang/String;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    .line 205
    :catch_0
    move-exception v0

    :try_start_2
    new-instance v0, Lcom/alipay/sdk/exception/NetErrorException;

    invoke-direct {v0}, Lcom/alipay/sdk/exception/NetErrorException;-><init>()V

    throw v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 207
    :catchall_0
    move-exception v0

    sput-object v4, Lcom/alipay/sdk/net/c;->a:Lcom/alipay/sdk/net/a;

    throw v0

    .line 191
    :cond_3
    :try_start_3
    sget-object v0, Lcom/alipay/sdk/net/c;->a:Lcom/alipay/sdk/net/a;

    const/4 v1, 0x0

    invoke-virtual {v0, p3, v1}, Lcom/alipay/sdk/net/a;->a(Ljava/lang/String;Lcom/alipay/sdk/data/c;)Lorg/apache/http/HttpResponse;
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    move-result-object v0

    goto :goto_1
.end method

.method private static a(Ljava/lang/String;)Ljava/lang/String;
    .locals 8

    .prologue
    const/4 v0, 0x0

    .line 130
    .line 133
    :try_start_0
    new-instance v1, Ljava/io/FileInputStream;

    invoke-direct {v1, p0}, Ljava/io/FileInputStream;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_4
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 134
    :try_start_1
    new-instance v2, Ljava/io/BufferedReader;

    new-instance v3, Ljava/io/InputStreamReader;

    invoke-direct {v3, v1}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V

    invoke-direct {v2, v3}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    .line 136
    const/16 v3, 0x800

    new-array v3, v3, [C

    .line 137
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    .line 138
    :goto_0
    invoke-virtual {v2, v3}, Ljava/io/BufferedReader;->read([C)I

    move-result v5

    if-lez v5, :cond_1

    .line 140
    const/4 v6, 0x0

    invoke-virtual {v4, v3, v6, v5}, Ljava/lang/StringBuilder;->append([CII)Ljava/lang/StringBuilder;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    goto :goto_0

    .line 147
    :catch_0
    move-exception v2

    :goto_1
    if-eqz v1, :cond_0

    .line 149
    :try_start_2
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_2

    .line 154
    :cond_0
    :goto_2
    return-object v0

    .line 143
    :cond_1
    :try_start_3
    invoke-virtual {v2}, Ljava/io/BufferedReader;->close()V

    .line 144
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    move-result-object v0

    .line 147
    :try_start_4
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V
    :try_end_4
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_1

    goto :goto_2

    :catch_1
    move-exception v1

    goto :goto_2

    :catchall_0
    move-exception v1

    move-object v7, v1

    move-object v1, v0

    move-object v0, v7

    :goto_3
    if-eqz v1, :cond_2

    .line 149
    :try_start_5
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V
    :try_end_5
    .catch Ljava/io/IOException; {:try_start_5 .. :try_end_5} :catch_3

    .line 151
    :cond_2
    :goto_4
    throw v0

    :catch_2
    move-exception v1

    goto :goto_2

    :catch_3
    move-exception v1

    goto :goto_4

    .line 147
    :catchall_1
    move-exception v0

    goto :goto_3

    :catch_4
    move-exception v1

    move-object v1, v0

    goto :goto_1
.end method

.method private a(Landroid/content/Context;Lcom/alipay/sdk/data/e;Lcom/alipay/sdk/data/f;)Lorg/json/JSONObject;
    .locals 11
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/alipay/sdk/exception/NetErrorException;
        }
    .end annotation

    .prologue
    const/4 v10, 0x3

    const/4 v0, 0x0

    const-wide/high16 v8, 0x4039000000000000L    # 25.0

    .line 99
    new-instance v1, Ljava/util/Random;

    invoke-direct {v1}, Ljava/util/Random;-><init>()V

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    :goto_0
    const/16 v3, 0x18

    if-ge v0, v3, :cond_0

    invoke-virtual {v1, v10}, Ljava/util/Random;->nextInt(I)I

    move-result v3

    packed-switch v3, :pswitch_data_0

    :goto_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :pswitch_0
    invoke-static {}, Ljava/lang/Math;->random()D

    move-result-wide v4

    mul-double/2addr v4, v8

    const-wide v6, 0x4050400000000000L    # 65.0

    add-double/2addr v4, v6

    invoke-static {v4, v5}, Ljava/lang/Math;->round(D)J

    move-result-wide v4

    long-to-int v3, v4

    int-to-char v3, v3

    invoke-static {v3}, Ljava/lang/String;->valueOf(C)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_1

    :pswitch_1
    invoke-static {}, Ljava/lang/Math;->random()D

    move-result-wide v4

    mul-double/2addr v4, v8

    const-wide v6, 0x4058400000000000L    # 97.0

    add-double/2addr v4, v6

    invoke-static {v4, v5}, Ljava/lang/Math;->round(D)J

    move-result-wide v4

    long-to-int v3, v4

    int-to-char v3, v3

    invoke-static {v3}, Ljava/lang/String;->valueOf(C)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_1

    :pswitch_2
    new-instance v3, Ljava/util/Random;

    invoke-direct {v3}, Ljava/util/Random;-><init>()V

    const/16 v4, 0xa

    invoke-virtual {v3, v4}, Ljava/util/Random;->nextInt(I)I

    move-result v3

    invoke-static {v3}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_1

    :cond_0
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    .line 101
    :try_start_0
    iget-object v0, p2, Lcom/alipay/sdk/data/e;->a:Lcom/alipay/sdk/data/a;

    iget-object v2, v0, Lcom/alipay/sdk/data/a;->a:Ljava/lang/String;

    invoke-virtual {p2, v6}, Lcom/alipay/sdk/data/e;->a(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v3

    iget-object v0, p2, Lcom/alipay/sdk/data/e;->b:Ljava/lang/ref/WeakReference;

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/alipay/sdk/data/c;

    move-object v0, p0

    move-object v1, p1

    move-object v5, p3

    invoke-direct/range {v0 .. v5}, Lcom/alipay/sdk/net/d;->a(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Lcom/alipay/sdk/data/c;Lcom/alipay/sdk/data/f;)Ljava/lang/String;

    move-result-object v0

    .line 108
    invoke-static {}, Ljava/util/Calendar;->getInstance()Ljava/util/Calendar;

    move-result-object v1

    invoke-virtual {v1}, Ljava/util/Calendar;->getTimeInMillis()J

    move-result-wide v2

    iput-wide v2, p3, Lcom/alipay/sdk/data/f;->e:J

    .line 111
    iget-boolean v1, p2, Lcom/alipay/sdk/data/e;->c:Z

    if-eqz v1, :cond_2

    .line 112
    invoke-static {v0, p3}, Lcom/alipay/sdk/net/d;->a(Ljava/lang/String;Lcom/alipay/sdk/data/f;)Lorg/json/JSONObject;

    move-result-object v0

    iget v1, p3, Lcom/alipay/sdk/data/f;->c:I

    const/16 v2, 0x3e8

    if-ne v1, v2, :cond_1

    iget v1, p0, Lcom/alipay/sdk/net/d;->a:I

    if-ge v1, v10, :cond_1

    iget v0, p0, Lcom/alipay/sdk/net/d;->a:I

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Lcom/alipay/sdk/net/d;->a:I

    invoke-direct {p0, p1, p2, p3}, Lcom/alipay/sdk/net/d;->a(Landroid/content/Context;Lcom/alipay/sdk/data/e;Lcom/alipay/sdk/data/f;)Lorg/json/JSONObject;

    move-result-object v0

    .line 120
    :goto_2
    return-object v0

    .line 112
    :cond_1
    const/4 v1, 0x0

    iput v1, p0, Lcom/alipay/sdk/net/d;->a:I

    const-string v1, "res_data"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v6, v0}, Lcom/alipay/sdk/encrypt/e;->b(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Lcom/alipay/sdk/exception/NetErrorException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    goto :goto_2

    .line 121
    :catch_0
    move-exception v0

    throw v0

    .line 115
    :cond_2
    :try_start_1
    invoke-static {v0, p3}, Lcom/alipay/sdk/net/d;->a(Ljava/lang/String;Lcom/alipay/sdk/data/f;)Lorg/json/JSONObject;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "respData:"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_1
    .catch Lcom/alipay/sdk/exception/NetErrorException; {:try_start_1 .. :try_end_1} :catch_0
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_2

    .line 124
    :catch_1
    move-exception v0

    new-instance v0, Lcom/alipay/sdk/exception/NetErrorException;

    invoke-direct {v0}, Lcom/alipay/sdk/exception/NetErrorException;-><init>()V

    throw v0

    .line 99
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
        :pswitch_2
    .end packed-switch
.end method

.method private a(Landroid/content/Context;Lcom/alipay/sdk/data/e;Lcom/alipay/sdk/data/f;Ljava/lang/String;Ljava/lang/String;)Lorg/json/JSONObject;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;,
            Lcom/alipay/sdk/exception/NetErrorException;
        }
    .end annotation

    .prologue
    .line 161
    invoke-static {p5, p3}, Lcom/alipay/sdk/net/d;->a(Ljava/lang/String;Lcom/alipay/sdk/data/f;)Lorg/json/JSONObject;

    move-result-object v0

    .line 162
    iget v1, p3, Lcom/alipay/sdk/data/f;->c:I

    const/16 v2, 0x3e8

    if-ne v1, v2, :cond_0

    iget v1, p0, Lcom/alipay/sdk/net/d;->a:I

    const/4 v2, 0x3

    if-ge v1, v2, :cond_0

    .line 164
    iget v0, p0, Lcom/alipay/sdk/net/d;->a:I

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Lcom/alipay/sdk/net/d;->a:I

    .line 165
    invoke-direct {p0, p1, p2, p3}, Lcom/alipay/sdk/net/d;->a(Landroid/content/Context;Lcom/alipay/sdk/data/e;Lcom/alipay/sdk/data/f;)Lorg/json/JSONObject;

    move-result-object v0

    .line 174
    :goto_0
    return-object v0

    .line 167
    :cond_0
    const/4 v1, 0x0

    iput v1, p0, Lcom/alipay/sdk/net/d;->a:I

    .line 170
    const-string v1, "res_data"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 173
    invoke-static {p4, v0}, Lcom/alipay/sdk/encrypt/e;->b(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 174
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    goto :goto_0
.end method

.method private static a(Lcom/alipay/sdk/data/f;Ljava/lang/String;)Lorg/json/JSONObject;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .prologue
    .line 181
    invoke-static {p1, p0}, Lcom/alipay/sdk/net/d;->a(Ljava/lang/String;Lcom/alipay/sdk/data/f;)Lorg/json/JSONObject;

    move-result-object v0

    .line 182
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "respData:"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 184
    return-object v0
.end method

.method private static a(Ljava/lang/String;Lcom/alipay/sdk/data/f;)Lorg/json/JSONObject;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .prologue
    const/16 v2, 0x1f7

    .line 213
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0, p0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 215
    const-string v1, "data"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    .line 217
    if-eqz v0, :cond_2

    .line 219
    const-string v1, "code"

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v1

    iput v1, p1, Lcom/alipay/sdk/data/f;->c:I

    .line 220
    const-string v1, "error_msg"

    const-string v2, ""

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, p1, Lcom/alipay/sdk/data/f;->d:Ljava/lang/String;

    .line 222
    const-string v1, "params"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    .line 223
    if-eqz v0, :cond_1

    .line 224
    iget v1, p1, Lcom/alipay/sdk/data/f;->c:I

    const/16 v2, 0x3e8

    if-ne v1, v2, :cond_0

    .line 226
    const-string v1, "public_key"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_0

    invoke-static {}, Lcom/alipay/sdk/sys/b;->a()Lcom/alipay/sdk/sys/b;

    move-result-object v2

    invoke-virtual {v2}, Lcom/alipay/sdk/sys/b;->b()Lcom/alipay/sdk/data/d;

    move-result-object v2

    invoke-virtual {v2, v1}, Lcom/alipay/sdk/data/d;->a(Ljava/lang/String;)V

    .line 229
    :cond_0
    new-instance v1, Lcom/alipay/sdk/data/a;

    invoke-direct {v1}, Lcom/alipay/sdk/data/a;-><init>()V

    .line 230
    const-string v2, "next_api_name"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    iput-object v2, v1, Lcom/alipay/sdk/data/a;->c:Ljava/lang/String;

    .line 231
    const-string v2, "next_api_version"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    iput-object v2, v1, Lcom/alipay/sdk/data/a;->d:Ljava/lang/String;

    .line 232
    const-string v2, "next_namespace"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    iput-object v2, v1, Lcom/alipay/sdk/data/a;->b:Ljava/lang/String;

    .line 233
    const-string v2, "next_request_url"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    iput-object v2, v1, Lcom/alipay/sdk/data/a;->a:Ljava/lang/String;

    .line 234
    iput-object v1, p1, Lcom/alipay/sdk/data/f;->l:Lcom/alipay/sdk/data/a;

    .line 244
    :goto_0
    return-object v0

    .line 237
    :cond_1
    iget v0, p1, Lcom/alipay/sdk/data/f;->c:I

    .line 244
    :goto_1
    const/4 v0, 0x0

    goto :goto_0

    .line 241
    :cond_2
    iput v2, p1, Lcom/alipay/sdk/data/f;->c:I

    .line 242
    const-string v0, ""

    iput-object v0, p1, Lcom/alipay/sdk/data/f;->d:Ljava/lang/String;

    goto :goto_1
.end method

.method private static a(Lorg/json/JSONObject;)V
    .locals 2

    .prologue
    .line 248
    const-string v0, "public_key"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 249
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 250
    invoke-static {}, Lcom/alipay/sdk/sys/b;->a()Lcom/alipay/sdk/sys/b;

    move-result-object v1

    invoke-virtual {v1}, Lcom/alipay/sdk/sys/b;->b()Lcom/alipay/sdk/data/d;

    move-result-object v1

    invoke-virtual {v1, v0}, Lcom/alipay/sdk/data/d;->a(Ljava/lang/String;)V

    .line 252
    :cond_0
    return-void
.end method


# virtual methods
.method public final a(Landroid/content/Context;Lcom/alipay/sdk/data/e;Z)Lcom/alipay/sdk/protocol/c;
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/alipay/sdk/exception/NetErrorException;
        }
    .end annotation

    .prologue
    .line 62
    new-instance v1, Lcom/alipay/sdk/data/f;

    invoke-direct {v1}, Lcom/alipay/sdk/data/f;-><init>()V

    .line 65
    invoke-direct {p0, p1, p2, v1}, Lcom/alipay/sdk/net/d;->a(Landroid/content/Context;Lcom/alipay/sdk/data/e;Lcom/alipay/sdk/data/f;)Lorg/json/JSONObject;

    move-result-object v2

    .line 68
    const-string v0, "gzip"

    invoke-virtual {v2, v0}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;)Z

    move-result v0

    .line 69
    if-eqz v0, :cond_1

    .line 70
    const-string v0, "form"

    invoke-virtual {v2, v0}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    .line 71
    if-eqz v0, :cond_0

    const-string v3, "quickpay"

    invoke-virtual {v0, v3}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_0

    .line 72
    const-string v3, "quickpay"

    invoke-virtual {v0, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 73
    invoke-static {v0}, Lcom/alipay/sdk/encrypt/a;->a(Ljava/lang/String;)[B

    move-result-object v0

    .line 75
    :try_start_0
    invoke-static {v0}, Lcom/alipay/sdk/data/b;->a([B)[B

    move-result-object v0

    .line 76
    invoke-static {v0}, Lcom/alipay/sdk/encrypt/c;->a([B)Ljava/lang/String;

    move-result-object v3

    .line 77
    const-string v4, "md5"

    invoke-virtual {v2, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 78
    invoke-static {v3, v4}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_0

    .line 79
    new-instance v3, Ljava/lang/String;

    const-string v4, "utf-8"

    invoke-direct {v3, v0, v4}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    .line 80
    const-string v0, "form"

    new-instance v4, Lorg/json/JSONObject;

    invoke-direct {v4, v3}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_2

    .line 88
    :cond_0
    :goto_0
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v3, "responsestring decoded "

    invoke-direct {v0, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    .line 89
    new-instance v0, Lcom/alipay/sdk/protocol/c;

    invoke-direct {v0, p2, v1}, Lcom/alipay/sdk/protocol/c;-><init>(Lcom/alipay/sdk/data/e;Lcom/alipay/sdk/data/f;)V

    .line 90
    invoke-virtual {v0, v2}, Lcom/alipay/sdk/protocol/c;->a(Lorg/json/JSONObject;)V

    .line 91
    if-eqz p3, :cond_2

    .line 94
    :goto_1
    return-object v0

    .line 86
    :cond_1
    const/4 v0, 0x0

    iput-boolean v0, v1, Lcom/alipay/sdk/data/f;->k:Z

    goto :goto_0

    .line 93
    :cond_2
    new-instance v1, Lcom/alipay/sdk/protocol/e;

    invoke-direct {v1}, Lcom/alipay/sdk/protocol/e;-><init>()V

    invoke-static {v0}, Lcom/alipay/sdk/protocol/e;->a(Lcom/alipay/sdk/protocol/c;)Lcom/alipay/sdk/protocol/g;

    move-result-object v1

    if-nez v1, :cond_a

    :goto_2
    iget-object v2, v0, Lcom/alipay/sdk/protocol/c;->b:Lcom/alipay/sdk/data/f;

    iget-object v3, v0, Lcom/alipay/sdk/protocol/c;->c:Lorg/json/JSONObject;

    iget-object v1, v0, Lcom/alipay/sdk/protocol/c;->a:Lcom/alipay/sdk/data/e;

    iget-object v1, v1, Lcom/alipay/sdk/data/e;->a:Lcom/alipay/sdk/data/a;

    iget-object v4, v0, Lcom/alipay/sdk/protocol/c;->b:Lcom/alipay/sdk/data/f;

    iget-object v4, v4, Lcom/alipay/sdk/data/f;->l:Lcom/alipay/sdk/data/a;

    iget-object v5, v4, Lcom/alipay/sdk/data/a;->c:Ljava/lang/String;

    invoke-static {v5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    if-eqz v5, :cond_3

    iget-object v5, v1, Lcom/alipay/sdk/data/a;->c:Ljava/lang/String;

    iput-object v5, v4, Lcom/alipay/sdk/data/a;->c:Ljava/lang/String;

    :cond_3
    iget-object v5, v4, Lcom/alipay/sdk/data/a;->d:Ljava/lang/String;

    invoke-static {v5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    if-eqz v5, :cond_4

    iget-object v5, v1, Lcom/alipay/sdk/data/a;->d:Ljava/lang/String;

    iput-object v5, v4, Lcom/alipay/sdk/data/a;->d:Ljava/lang/String;

    :cond_4
    iget-object v5, v4, Lcom/alipay/sdk/data/a;->b:Ljava/lang/String;

    invoke-static {v5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    if-eqz v5, :cond_5

    iget-object v5, v1, Lcom/alipay/sdk/data/a;->b:Ljava/lang/String;

    iput-object v5, v4, Lcom/alipay/sdk/data/a;->b:Ljava/lang/String;

    :cond_5
    iget-object v5, v4, Lcom/alipay/sdk/data/a;->a:Ljava/lang/String;

    invoke-static {v5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    if-eqz v5, :cond_6

    iget-object v1, v1, Lcom/alipay/sdk/data/a;->a:Ljava/lang/String;

    iput-object v1, v4, Lcom/alipay/sdk/data/a;->a:Ljava/lang/String;

    :cond_6
    const-string v1, "session"

    const-string v4, "reflected_data"

    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v4

    if-eqz v4, :cond_8

    new-instance v5, Ljava/lang/StringBuilder;

    const-string v6, "session = "

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v6, ""

    invoke-virtual {v4, v1, v6}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, v0, Lcom/alipay/sdk/protocol/c;->b:Lcom/alipay/sdk/data/f;

    iput-object v4, v1, Lcom/alipay/sdk/data/f;->i:Lorg/json/JSONObject;

    :cond_7
    :goto_3
    const-string v1, "end_code"

    const-string v4, "0"

    invoke-virtual {v3, v1, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v2, Lcom/alipay/sdk/data/f;->f:Ljava/lang/String;

    const-string v1, "user_id"

    const-string v4, ""

    invoke-virtual {v3, v1, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v2, Lcom/alipay/sdk/data/f;->j:Ljava/lang/String;

    const-string v1, "result"

    invoke-virtual {v3, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    :try_start_1
    const-string v4, "result"

    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string v5, "UTF-8"

    invoke-static {v4, v5}, Ljava/net/URLDecoder;->decode(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    :try_end_1
    .catch Ljava/io/UnsupportedEncodingException; {:try_start_1 .. :try_end_1} :catch_1

    move-result-object v1

    :goto_4
    iput-object v1, v2, Lcom/alipay/sdk/data/f;->g:Ljava/lang/String;

    const-string v1, "memo"

    const-string v4, ""

    invoke-virtual {v3, v1, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v2, Lcom/alipay/sdk/data/f;->h:Ljava/lang/String;

    goto/16 :goto_1

    :cond_8
    invoke-virtual {v3, v1}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_7

    new-instance v4, Lorg/json/JSONObject;

    invoke-direct {v4}, Lorg/json/JSONObject;-><init>()V

    :try_start_2
    invoke-virtual {v3, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v1, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    invoke-static {}, Lcom/alipay/sdk/tid/b;->a()Lcom/alipay/sdk/tid/b;

    move-result-object v1

    iget-object v1, v1, Lcom/alipay/sdk/tid/b;->a:Ljava/lang/String;

    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    if-nez v5, :cond_9

    const-string v5, "tid"

    invoke-virtual {v4, v5, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    :cond_9
    iput-object v4, v2, Lcom/alipay/sdk/data/f;->i:Lorg/json/JSONObject;
    :try_end_2
    .catch Lorg/json/JSONException; {:try_start_2 .. :try_end_2} :catch_0

    goto :goto_3

    :catch_0
    move-exception v1

    goto :goto_3

    :catch_1
    move-exception v4

    goto :goto_4

    :catch_2
    move-exception v0

    goto/16 :goto_0

    :cond_a
    move-object v0, v1

    goto/16 :goto_2
.end method
