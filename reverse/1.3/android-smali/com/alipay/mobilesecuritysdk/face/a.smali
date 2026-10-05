.class public final Lcom/alipay/mobilesecuritysdk/face/a;
.super Ljava/lang/Object;


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static declared-synchronized a(Landroid/content/Context;Ljava/util/Map;)Ljava/lang/String;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/util/Map",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)",
            "Ljava/lang/String;"
        }
    .end annotation

    const-class v1, Lcom/alipay/mobilesecuritysdk/face/a;

    monitor-enter v1

    :try_start_0
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    const-string v2, "utdid"

    const-string v3, "utdid"

    const-string v4, ""

    invoke-static {p1, v3, v4}, Lcom/alipay/security/mobile/module/commonutils/a;->a(Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v0, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v2, "tid"

    const-string v3, "tid"

    const-string v4, ""

    invoke-static {p1, v3, v4}, Lcom/alipay/security/mobile/module/commonutils/a;->a(Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v0, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v2, "userId"

    const-string v3, "userId"

    const-string v4, ""

    invoke-static {p1, v3, v4}, Lcom/alipay/security/mobile/module/commonutils/a;->a(Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v0, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    invoke-static {p0}, Lcom/alipay/apmobilesecuritysdk/face/a;->a(Landroid/content/Context;)Lcom/alipay/apmobilesecuritysdk/face/a;

    move-result-object v2

    const-string v3, "utdid"

    const-string v4, ""

    invoke-static {v0, v3, v4}, Lcom/alipay/security/mobile/module/commonutils/a;->a(Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    const-string v4, "tid"

    const-string v5, ""

    invoke-static {v0, v4, v5}, Lcom/alipay/security/mobile/module/commonutils/a;->a(Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string v5, "userId"

    const-string v6, ""

    invoke-static {v0, v5, v6}, Lcom/alipay/security/mobile/module/commonutils/a;->a(Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v5, "https://mobilegw.alipay.com/mgw.htm"

    invoke-static {v5}, Lcom/alipay/security/mobile/module/a/a/a;->a(Ljava/lang/String;)V

    iget-object v5, v2, Lcom/alipay/apmobilesecuritysdk/face/a;->b:Ljava/util/LinkedList;

    new-instance v6, Lcom/alipay/apmobilesecuritysdk/face/a$b;

    invoke-direct {v6, v2, v3, v4, v0}, Lcom/alipay/apmobilesecuritysdk/face/a$b;-><init>(Lcom/alipay/apmobilesecuritysdk/face/a;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v5, v6}, Ljava/util/LinkedList;->addLast(Ljava/lang/Object;)V

    iget-object v0, v2, Lcom/alipay/apmobilesecuritysdk/face/a;->a:Ljava/lang/Thread;

    if-nez v0, :cond_0

    new-instance v0, Ljava/lang/Thread;

    new-instance v3, Lcom/alipay/apmobilesecuritysdk/face/b;

    invoke-direct {v3, v2}, Lcom/alipay/apmobilesecuritysdk/face/b;-><init>(Lcom/alipay/apmobilesecuritysdk/face/a;)V

    invoke-direct {v0, v3}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    iput-object v0, v2, Lcom/alipay/apmobilesecuritysdk/face/a;->a:Ljava/lang/Thread;

    iget-object v0, v2, Lcom/alipay/apmobilesecuritysdk/face/a;->a:Ljava/lang/Thread;

    new-instance v3, Lcom/alipay/apmobilesecuritysdk/face/c;

    invoke-direct {v3, v2}, Lcom/alipay/apmobilesecuritysdk/face/c;-><init>(Lcom/alipay/apmobilesecuritysdk/face/a;)V

    invoke-virtual {v0, v3}, Ljava/lang/Thread;->setUncaughtExceptionHandler(Ljava/lang/Thread$UncaughtExceptionHandler;)V

    iget-object v0, v2, Lcom/alipay/apmobilesecuritysdk/face/a;->a:Ljava/lang/Thread;

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    :cond_0
    invoke-static {}, Lcom/alipay/apmobilesecuritysdk/e/f;->a()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/security/mobile/module/commonutils/a;->a(Ljava/lang/String;)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move-result v2

    if-nez v2, :cond_2

    :cond_1
    :goto_0
    monitor-exit v1

    return-object v0

    :cond_2
    :try_start_1
    invoke-static {p0}, Lcom/alipay/apmobilesecuritysdk/e/a;->a(Landroid/content/Context;)Lcom/alipay/apmobilesecuritysdk/e/b;

    move-result-object v0

    if-eqz v0, :cond_3

    iget-object v2, v0, Lcom/alipay/apmobilesecuritysdk/e/b;->a:Ljava/lang/String;

    invoke-static {v2}, Lcom/alipay/security/mobile/module/commonutils/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_3

    iget-object v0, v0, Lcom/alipay/apmobilesecuritysdk/e/b;->a:Ljava/lang/String;

    goto :goto_0

    :cond_3
    invoke-static {p0}, Lcom/alipay/apmobilesecuritysdk/a/a/a;->a(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/security/mobile/module/commonutils/a;->a(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-static {p0}, Lcom/alipay/apmobilesecuritysdk/f/b;->a(Landroid/content/Context;)Ljava/lang/String;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    move-result-object v0

    goto :goto_0

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method
