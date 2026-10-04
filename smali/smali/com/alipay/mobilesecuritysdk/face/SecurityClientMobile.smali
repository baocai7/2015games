.class public Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;
.super Ljava/lang/Object;


# static fields
.field private static a:Ljava/lang/Thread;

.field private static b:Z

.field private static c:Z


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const/4 v0, 0x0

    sput-boolean v0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->b:Z

    sput-boolean v0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->c:Z

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static declared-synchronized GetApdid(Landroid/content/Context;Ljava/util/Map;)Ljava/lang/String;
    .locals 2
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

    const-class v1, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;

    monitor-enter v1

    :try_start_0
    new-instance v0, Lcom/alipay/mobilesecuritysdk/deviceID/c;

    invoke-direct {v0, p0}, Lcom/alipay/mobilesecuritysdk/deviceID/c;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0, p1}, Lcom/alipay/mobilesecuritysdk/deviceID/c;->a(Ljava/util/Map;)Ljava/lang/String;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move-result-object v0

    monitor-exit v1

    return-object v0

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method static synthetic access$0()Z
    .locals 1

    sget-boolean v0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->c:Z

    return v0
.end method

.method public static isDebug()Z
    .locals 1

    sget-boolean v0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->c:Z

    return v0
.end method

.method public static setDebug(Z)V
    .locals 0

    sput-boolean p0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->c:Z

    return-void
.end method

.method public static setError(Z)V
    .locals 0

    sput-boolean p0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->b:Z

    return-void
.end method

.method public static declared-synchronized start(Landroid/content/Context;Ljava/util/List;Z)V
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/util/List",
            "<",
            "Ljava/lang/String;",
            ">;Z)V"
        }
    .end annotation

    const-class v1, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;

    monitor-enter v1

    :try_start_0
    sget-boolean v0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->c:Z

    if-eqz v0, :cond_0

    const-string v0, "ALP"

    const-string v2, "start have been called."

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    if-nez p0, :cond_2

    sget-boolean v0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->c:Z

    if-eqz v0, :cond_1

    const-string v0, "ALP"

    const-string v2, "Context is null."

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :cond_1
    :goto_0
    monitor-exit v1

    return-void

    :cond_2
    :try_start_1
    sget-object v0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->a:Ljava/lang/Thread;

    if-eqz v0, :cond_3

    sget-object v0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->a:Ljava/lang/Thread;

    invoke-virtual {v0}, Ljava/lang/Thread;->isAlive()Z

    move-result v0

    if-eqz v0, :cond_3

    sget-boolean v0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->c:Z

    if-eqz v0, :cond_1

    const-string v0, "ALP"

    const-string v2, "mainThread is working, quit."

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :catch_0
    move-exception v0

    goto :goto_0

    :cond_3
    const/4 v0, 0x0

    sput-object v0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->a:Ljava/lang/Thread;

    sget-boolean v0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->b:Z

    if-eqz v0, :cond_4

    sget-boolean v0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->c:Z

    if-eqz v0, :cond_1

    const-string v0, "ALP"

    const-string v2, "some error happend, quit."

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catch Ljava/lang/Throwable; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0

    :cond_4
    :try_start_2
    new-instance v0, Ljava/lang/Thread;

    new-instance v2, Lcom/alipay/mobilesecuritysdk/face/a;

    invoke-direct {v2, p0, p1, p2}, Lcom/alipay/mobilesecuritysdk/face/a;-><init>(Landroid/content/Context;Ljava/util/List;Z)V

    invoke-direct {v0, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    sput-object v0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->a:Ljava/lang/Thread;

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V
    :try_end_2
    .catch Ljava/lang/Throwable; {:try_start_2 .. :try_end_2} :catch_0
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto :goto_0
.end method

.method public static stop()V
    .locals 2

    :try_start_0
    sget-boolean v0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->c:Z

    if-eqz v0, :cond_0

    const-string v0, "ALP"

    const-string v1, "stop have been called."

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    sget-object v0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->a:Ljava/lang/Thread;

    if-eqz v0, :cond_1

    sget-object v0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->a:Ljava/lang/Thread;

    invoke-virtual {v0}, Ljava/lang/Thread;->isAlive()Z

    move-result v0

    if-nez v0, :cond_2

    :cond_1
    :goto_0
    return-void

    :cond_2
    sget-object v0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->a:Ljava/lang/Thread;

    invoke-virtual {v0}, Ljava/lang/Thread;->interrupt()V

    const/4 v0, 0x0

    sput-object v0, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->a:Ljava/lang/Thread;
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    goto :goto_0
.end method
