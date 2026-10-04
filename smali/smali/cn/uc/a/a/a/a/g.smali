.class public Lcn/uc/a/a/a/a/g;
.super Ljava/lang/Object;


# static fields
.field private static final a:Ljava/lang/String; = "SdkHttpWorker"


# instance fields
.field private b:Lcn/uc/a/a/a/a/b/b;


# direct methods
.method public constructor <init>()V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    iput-object v0, p0, Lcn/uc/a/a/a/a/g;->b:Lcn/uc/a/a/a/a/b/b;

    new-instance v0, Lcn/uc/a/a/a/a/b/b;

    invoke-direct {v0}, Lcn/uc/a/a/a/a/b/b;-><init>()V

    iput-object v0, p0, Lcn/uc/a/a/a/a/g;->b:Lcn/uc/a/a/a/a/b/b;

    return-void
.end method

.method public static a(Ljava/lang/String;Lcn/uc/a/a/a/a/c;Ljava/lang/String;)Lcn/uc/a/a/a/a/j;
    .locals 3

    new-instance v0, Lcn/uc/a/a/a/a/e;

    invoke-direct {v0, p0, p2}, Lcn/uc/a/a/a/a/e;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Lcn/uc/a/a/a/a/e;->a(Lcn/uc/a/a/a/a/c;)V

    new-instance v1, Lcn/uc/a/a/a/a/g;

    invoke-direct {v1}, Lcn/uc/a/a/a/a/g;-><init>()V

    const/4 v2, 0x0

    invoke-virtual {v0}, Lcn/uc/a/a/a/a/e;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v1, v2, v0, p0}, Lcn/uc/a/a/a/a/g;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Lcn/uc/a/a/a/a/j;

    move-result-object v0

    return-object v0
.end method

.method public static a(Ljava/lang/String;Ljava/lang/String;Lcn/uc/a/a/a/a/c;Ljava/lang/String;)Lcn/uc/a/a/a/a/j;
    .locals 2

    new-instance v0, Lcn/uc/a/a/a/a/e;

    invoke-direct {v0, p1, p3}, Lcn/uc/a/a/a/a/e;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v0, p2}, Lcn/uc/a/a/a/a/e;->a(Lcn/uc/a/a/a/a/c;)V

    new-instance v1, Lcn/uc/a/a/a/a/g;

    invoke-direct {v1}, Lcn/uc/a/a/a/a/g;-><init>()V

    invoke-virtual {v0}, Lcn/uc/a/a/a/a/e;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v1, p0, v0, p1}, Lcn/uc/a/a/a/a/g;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Lcn/uc/a/a/a/a/j;

    move-result-object v0

    return-object v0
.end method

.method public static a(Ljava/lang/String;Ljava/lang/String;Lcn/uc/a/a/a/a/c;ZLjava/lang/String;)Lcn/uc/a/a/a/a/j;
    .locals 2

    new-instance v0, Lcn/uc/a/a/a/a/e;

    invoke-direct {v0, p1, p3, p4}, Lcn/uc/a/a/a/a/e;-><init>(Ljava/lang/String;ZLjava/lang/String;)V

    invoke-virtual {v0, p2}, Lcn/uc/a/a/a/a/e;->a(Lcn/uc/a/a/a/a/c;)V

    new-instance v1, Lcn/uc/a/a/a/a/g;

    invoke-direct {v1}, Lcn/uc/a/a/a/a/g;-><init>()V

    invoke-virtual {v0}, Lcn/uc/a/a/a/a/e;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v1, p0, v0, p1}, Lcn/uc/a/a/a/a/g;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Lcn/uc/a/a/a/a/j;

    move-result-object v0

    return-object v0
.end method

.method private declared-synchronized a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Lcn/uc/a/a/a/a/j;
    .locals 6

    monitor-enter p0

    :try_start_0
    const-string v0, "SdkHttpWorker"

    const-string v1, "syncPostInternal"

    const-string v2, "enter"

    const-string v3, ""

    invoke-static {v0, v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {p1}, Lcn/uc/a/a/a/b/j;->k(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-static {p3}, Lcn/uc/a/a/a/a/k;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " url="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ",service="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ",errorMsg="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    invoke-static {p1}, Lcn/uc/a/a/a/b/j;->k(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string v0, "SdkHttpWorker"

    const-string v1, "syncPostInternal"

    const-string v2, "cost"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Service:"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, ",\u8bf7\u6c42sdkserver\u7684url\u4e3a\u7a7a!"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v0, v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {p3}, Lcn/uc/a/a/a/a/j;->a(Ljava/lang/String;)Lcn/uc/a/a/a/a/j;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move-result-object v0

    :goto_0
    monitor-exit p0

    return-object v0

    :cond_1
    const/4 v0, 0x1

    :try_start_1
    invoke-direct {p0, p1, p2, p3, v0}, Lcn/uc/a/a/a/a/g;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)Lcn/uc/a/a/a/a/j;

    move-result-object v0

    if-nez v0, :cond_2

    invoke-static {p3}, Lcn/uc/a/a/a/a/j;->a(Ljava/lang/String;)Lcn/uc/a/a/a/a/j;

    move-result-object v0

    :cond_2
    const-string v1, "SdkHttpWorker"

    const-string v2, "syncPostInternal"

    const-string v3, "cost"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Service:"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v1, v2, v3, v4}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public static a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Lcn/uc/a/a/a/a/j;
    .locals 2

    new-instance v0, Lcn/uc/a/a/a/a/e;

    invoke-direct {v0, p1, p3}, Lcn/uc/a/a/a/a/e;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v0, p2}, Lcn/uc/a/a/a/a/e;->a(Ljava/lang/String;)V

    new-instance v1, Lcn/uc/a/a/a/a/g;

    invoke-direct {v1}, Lcn/uc/a/a/a/a/g;-><init>()V

    invoke-virtual {v0}, Lcn/uc/a/a/a/a/e;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v1, p0, v0, p1}, Lcn/uc/a/a/a/a/g;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Lcn/uc/a/a/a/a/j;

    move-result-object v0

    return-object v0
.end method

.method private a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)Lcn/uc/a/a/a/a/j;
    .locals 10

    const/4 v5, 0x2

    const/4 v9, -0x1

    const/4 v7, 0x0

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " url="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ",service="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ",errorMsg="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v0, "\"password\":\""

    invoke-virtual {p2, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_2

    const-string v0, "\"password\":\".*?\""

    const-string v2, "\"password\":\"*\""

    invoke-virtual {p2, v0, v2}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :goto_0
    const-string v2, "SdkHttpWorker"

    const-string v4, "parsePost"

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "request:"

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v8, ",content="

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v4, v0}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {p2}, Lcn/uc/a/a/a/a/a/g;->b(Ljava/lang/String;)[B

    move-result-object v0

    :try_start_0
    iget-object v2, p0, Lcn/uc/a/a/a/a/g;->b:Lcn/uc/a/a/a/a/b/b;

    invoke-virtual {v2, p1, v0}, Lcn/uc/a/a/a/a/b/b;->a(Ljava/lang/String;[B)[B

    move-result-object v2

    const-string v0, ""

    iget-object v0, p0, Lcn/uc/a/a/a/a/g;->b:Lcn/uc/a/a/a/a/b/b;

    invoke-virtual {v0}, Lcn/uc/a/a/a/a/b/b;->a()I

    move-result v0

    invoke-static {v2}, Lcn/uc/a/a/a/a/a/d;->a([B)Z

    move-result v4

    if-eqz v4, :cond_4

    invoke-static {v2}, Lcn/uc/a/a/a/a/a/g;->b([B)Ljava/lang/String;

    move-result-object v2

    const-string v0, "\"password\":\""

    invoke-virtual {v2, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_3

    const-string v0, "\"password\":\".*?\""

    const-string v4, "\"password\":\"*\""

    invoke-virtual {v2, v0, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :goto_1
    const-string v4, "SdkHttpWorker"

    const-string v6, "parsePost"

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "response:"

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    invoke-virtual {v8, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v8, ",content="

    invoke-virtual {v3, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v4, v6, v0}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    new-instance v0, Lcn/uc/a/a/a/a/j;

    invoke-direct {v0, p3, v2}, Lcn/uc/a/a/a/a/j;-><init>(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_0
    .catch Lorg/apache/http/conn/ConnectTimeoutException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/lang/IllegalStateException; {:try_start_0 .. :try_end_0} :catch_3
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_4

    :goto_2
    if-nez v0, :cond_0

    invoke-static {p3}, Lcn/uc/a/a/a/a/j;->a(Ljava/lang/String;)Lcn/uc/a/a/a/a/j;

    move-result-object v0

    :cond_0
    if-nez p4, :cond_1

    invoke-virtual {v0}, Lcn/uc/a/a/a/a/j;->k()Z

    move-result v1

    if-eqz v1, :cond_13

    const-string v1, "netRetrySucc"

    const-string v2, "S"

    const-string v3, ""

    invoke-static {v1, v2, v3}, Lcn/uc/a/a/a/i;->f(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_1
    :goto_3
    iput-object v7, p0, Lcn/uc/a/a/a/a/g;->b:Lcn/uc/a/a/a/a/b/b;

    return-object v0

    :cond_2
    move-object v0, p2

    goto/16 :goto_0

    :cond_3
    move-object v0, v2

    goto :goto_1

    :cond_4
    const/4 v4, -0x4

    if-ne v0, v4, :cond_5

    :try_start_1
    const-string v0, "SdkHttpWorker"

    const-string v2, "parsePost"

    const-string v3, "\u7528\u6237\u4e3b\u52a8\u65ad\u5f00HTTP\u8fde\u63a5"

    invoke-static {v0, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/16 v0, -0xb

    const-string v2, ""

    invoke-static {v0, v2}, Lcn/uc/a/a/a/a/j;->a(ILjava/lang/String;)Lcn/uc/a/a/a/a/j;

    move-result-object v0

    goto :goto_2

    :cond_5
    const-string v4, ""

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, ",responseCode="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, ",errorMsg="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    if-ne v0, v9, :cond_7

    const-string v0, "client not network"

    const-string v3, "SdkHttpWorker"

    const-string v4, "parsePost"

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v6, ",content="

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    if-eqz v2, :cond_6

    new-instance v0, Ljava/lang/String;

    invoke-direct {v0, v2}, Ljava/lang/String;-><init>([B)V

    :goto_4
    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v4, v0}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    move-object v0, v7

    goto/16 :goto_2

    :cond_6
    move-object v0, v7

    goto :goto_4

    :cond_7
    const-string v0, "response m9decode failed"

    new-instance v3, Ljava/lang/String;

    invoke-direct {v3, v2}, Ljava/lang/String;-><init>([B)V

    invoke-virtual {v3}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v3

    if-eqz v3, :cond_12

    const-string v4, "<html"

    invoke-virtual {v3, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v4

    if-ne v4, v9, :cond_8

    const-string v4, "<?xml"

    invoke-virtual {v3, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v4

    if-eq v4, v9, :cond_e

    :cond_8
    const-string v4, "wlan"

    invoke-virtual {v3, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v4

    if-eq v4, v9, :cond_a

    const-string v3, "SdkHttpWorker"

    const-string v4, "parsePost"

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v6, "\uff0ccategory = wlan\uff0c content="

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    if-eqz v2, :cond_9

    new-instance v0, Ljava/lang/String;

    invoke-direct {v0, v2}, Ljava/lang/String;-><init>([B)V

    :goto_5
    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v4, v0}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    move-object v0, v7

    goto/16 :goto_2

    :cond_9
    move-object v0, v7

    goto :goto_5

    :cond_a
    const-string v4, "authentication is required"

    invoke-virtual {v3, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v3

    if-eq v3, v9, :cond_c

    const-string v3, "SdkHttpWorker"

    const-string v4, "parsePost"

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v6, "\uff0ccategory = Authentication is required\uff0c content="

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    if-eqz v2, :cond_b

    new-instance v0, Ljava/lang/String;

    invoke-direct {v0, v2}, Ljava/lang/String;-><init>([B)V

    :goto_6
    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v4, v0}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    move-object v0, v7

    goto/16 :goto_2

    :cond_b
    move-object v0, v7

    goto :goto_6

    :cond_c
    if-eqz p4, :cond_12

    const-string v3, "SdkHttpWorker"

    const-string v4, "parsePost"

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v6, ",content="

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    if-eqz v2, :cond_d

    new-instance v0, Ljava/lang/String;

    invoke-direct {v0, v2}, Ljava/lang/String;-><init>([B)V

    :goto_7
    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v4, v0}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x0

    invoke-direct {p0, p1, p2, p3, v0}, Lcn/uc/a/a/a/a/g;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)Lcn/uc/a/a/a/a/j;

    move-result-object v0

    goto/16 :goto_2

    :cond_d
    move-object v0, v7

    goto :goto_7

    :cond_e
    const-string v4, "auth"

    invoke-virtual {v3, v4}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v3

    if-eq v3, v9, :cond_10

    const-string v3, "SdkHttpWorker"

    const-string v4, "parsePost"

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v6, "\uff0ccategory = auth\uff0c content="

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    if-eqz v2, :cond_f

    new-instance v0, Ljava/lang/String;

    invoke-direct {v0, v2}, Ljava/lang/String;-><init>([B)V

    :goto_8
    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v4, v0}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    move-object v0, v7

    goto/16 :goto_2

    :cond_f
    move-object v0, v7

    goto :goto_8

    :cond_10
    if-eqz p4, :cond_12

    const-string v3, "SdkHttpWorker"

    const-string v4, "parsePost"

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v6, ",content="

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    if-eqz v2, :cond_11

    new-instance v0, Ljava/lang/String;

    invoke-direct {v0, v2}, Ljava/lang/String;-><init>([B)V

    :goto_9
    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v4, v0}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x0

    invoke-direct {p0, p1, p2, p3, v0}, Lcn/uc/a/a/a/a/g;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)Lcn/uc/a/a/a/a/j;
    :try_end_1
    .catch Lorg/apache/http/conn/ConnectTimeoutException; {:try_start_1 .. :try_end_1} :catch_0
    .catch Lorg/apache/http/client/ClientProtocolException; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_2
    .catch Ljava/lang/IllegalStateException; {:try_start_1 .. :try_end_1} :catch_3
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_4

    move-result-object v0

    goto/16 :goto_2

    :cond_11
    move-object v0, v7

    goto :goto_9

    :catch_0
    move-exception v0

    const-string v2, "SdkHttpWorker"

    const-string v3, "parsePost"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v0}, Lorg/apache/http/conn/ConnectTimeoutException;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v3, v0}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    move-object v0, v7

    goto/16 :goto_2

    :catch_1
    move-exception v0

    const-string v2, "SdkHttpWorker"

    const-string v3, "parsePost"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v0}, Lorg/apache/http/client/ClientProtocolException;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v3, v0}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    move-object v0, v7

    goto/16 :goto_2

    :catch_2
    move-exception v0

    const-string v2, "SdkHttpWorker"

    const-string v3, "parsePost"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v0}, Ljava/io/IOException;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v3, v0}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    move-object v0, v7

    goto/16 :goto_2

    :catch_3
    move-exception v4

    move-object v3, v1

    const-string v0, "SdkHttpWorker"

    const-string v1, "parsePost"

    const-string v2, "network"

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v4}, Ljava/lang/IllegalStateException;->getMessage()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v6, "key_mve"

    invoke-static {v6}, Lcn/uc/a/a/a/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V

    move-object v0, v7

    goto/16 :goto_2

    :catch_4
    move-exception v4

    move-object v3, v1

    const-string v0, "SdkHttpWorker"

    const-string v1, "parsePost"

    const-string v2, "network"

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v4}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v6, "key_mve"

    invoke-static {v6}, Lcn/uc/a/a/a/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V

    :cond_12
    move-object v0, v7

    goto/16 :goto_2

    :cond_13
    const-string v1, "netRetryFail"

    const-string v2, "S"

    const-string v3, ""

    invoke-static {v1, v2, v3}, Lcn/uc/a/a/a/i;->f(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto/16 :goto_3
.end method

.method public static a(Ljava/lang/String;Lcn/uc/a/a/a/a/c;Lcn/uc/a/a/a/a/h;Ljava/lang/String;)V
    .locals 2

    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcn/uc/a/a/a/a/g$1;

    invoke-direct {v1, p0, p1, p3, p2}, Lcn/uc/a/a/a/a/g$1;-><init>(Ljava/lang/String;Lcn/uc/a/a/a/a/c;Ljava/lang/String;Lcn/uc/a/a/a/a/h;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method


# virtual methods
.method public a()V
    .locals 1

    iget-object v0, p0, Lcn/uc/a/a/a/a/g;->b:Lcn/uc/a/a/a/a/b/b;

    invoke-virtual {v0}, Lcn/uc/a/a/a/a/b/b;->g()V

    return-void
.end method

.method public b(Ljava/lang/String;Lcn/uc/a/a/a/a/c;Ljava/lang/String;)Lcn/uc/a/a/a/a/j;
    .locals 2

    new-instance v0, Lcn/uc/a/a/a/a/e;

    invoke-direct {v0, p1, p3}, Lcn/uc/a/a/a/a/e;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v0, p2}, Lcn/uc/a/a/a/a/e;->a(Lcn/uc/a/a/a/a/c;)V

    const/4 v1, 0x0

    invoke-virtual {v0}, Lcn/uc/a/a/a/a/e;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v1, v0, p1}, Lcn/uc/a/a/a/a/g;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Lcn/uc/a/a/a/a/j;

    move-result-object v0

    return-object v0
.end method
