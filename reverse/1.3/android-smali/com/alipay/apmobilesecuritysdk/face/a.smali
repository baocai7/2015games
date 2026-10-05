.class public final Lcom/alipay/apmobilesecuritysdk/face/a;
.super Ljava/lang/Object;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/alipay/apmobilesecuritysdk/face/a$b;,
        Lcom/alipay/apmobilesecuritysdk/face/a$a;,
        Lcom/alipay/apmobilesecuritysdk/face/a$c;
    }
.end annotation


# static fields
.field private static c:Lcom/alipay/apmobilesecuritysdk/face/a;

.field private static d:Ljava/lang/Object;


# instance fields
.field public a:Ljava/lang/Thread;

.field public b:Ljava/util/LinkedList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/LinkedList",
            "<",
            "Lcom/alipay/apmobilesecuritysdk/face/a$b;",
            ">;"
        }
    .end annotation
.end field

.field private e:Landroid/content/Context;

.field private volatile f:Z


# direct methods
.method static constructor <clinit>()V
    .locals 1

    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/alipay/apmobilesecuritysdk/face/a;->d:Ljava/lang/Object;

    return-void
.end method

.method private constructor <init>(Landroid/content/Context;)V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a;->f:Z

    new-instance v0, Ljava/util/LinkedList;

    invoke-direct {v0}, Ljava/util/LinkedList;-><init>()V

    iput-object v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a;->b:Ljava/util/LinkedList;

    iput-object p1, p0, Lcom/alipay/apmobilesecuritysdk/face/a;->e:Landroid/content/Context;

    return-void
.end method

.method public static a(Landroid/content/Context;)Lcom/alipay/apmobilesecuritysdk/face/a;
    .locals 2

    sget-object v1, Lcom/alipay/apmobilesecuritysdk/face/a;->d:Ljava/lang/Object;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcom/alipay/apmobilesecuritysdk/face/a;->c:Lcom/alipay/apmobilesecuritysdk/face/a;

    if-nez v0, :cond_0

    new-instance v0, Lcom/alipay/apmobilesecuritysdk/face/a;

    invoke-direct {v0, p0}, Lcom/alipay/apmobilesecuritysdk/face/a;-><init>(Landroid/content/Context;)V

    sput-object v0, Lcom/alipay/apmobilesecuritysdk/face/a;->c:Lcom/alipay/apmobilesecuritysdk/face/a;

    :cond_0
    sget-object v0, Lcom/alipay/apmobilesecuritysdk/face/a;->c:Lcom/alipay/apmobilesecuritysdk/face/a;

    monitor-exit v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-object v0

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method private a()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a;->e:Landroid/content/Context;

    invoke-static {v0}, Lcom/alipay/apmobilesecuritysdk/a/a;->a(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method static synthetic a(Lcom/alipay/apmobilesecuritysdk/face/a;)Ljava/util/LinkedList;
    .locals 1

    iget-object v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a;->b:Ljava/util/LinkedList;

    return-object v0
.end method

.method private a(Ljava/util/Map;)V
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    const-string v0, "utdid"

    const-string v1, ""

    invoke-static {p1, v0, v1}, Lcom/alipay/security/mobile/module/commonutils/a;->a(Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "tid"

    const-string v2, ""

    invoke-static {p1, v1, v2}, Lcom/alipay/security/mobile/module/commonutils/a;->a(Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "userId"

    const-string v3, ""

    invoke-static {p1, v2, v3}, Lcom/alipay/security/mobile/module/commonutils/a;->a(Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const-string v3, "https://mobilegw.alipay.com/mgw.htm"

    invoke-static {v3}, Lcom/alipay/security/mobile/module/a/a/a;->a(Ljava/lang/String;)V

    iget-object v3, p0, Lcom/alipay/apmobilesecuritysdk/face/a;->b:Ljava/util/LinkedList;

    new-instance v4, Lcom/alipay/apmobilesecuritysdk/face/a$b;

    invoke-direct {v4, p0, v0, v1, v2}, Lcom/alipay/apmobilesecuritysdk/face/a$b;-><init>(Lcom/alipay/apmobilesecuritysdk/face/a;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v3, v4}, Ljava/util/LinkedList;->addLast(Ljava/lang/Object;)V

    iget-object v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a;->a:Ljava/lang/Thread;

    if-nez v0, :cond_0

    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/alipay/apmobilesecuritysdk/face/b;

    invoke-direct {v1, p0}, Lcom/alipay/apmobilesecuritysdk/face/b;-><init>(Lcom/alipay/apmobilesecuritysdk/face/a;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    iput-object v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a;->a:Ljava/lang/Thread;

    iget-object v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a;->a:Ljava/lang/Thread;

    new-instance v1, Lcom/alipay/apmobilesecuritysdk/face/c;

    invoke-direct {v1, p0}, Lcom/alipay/apmobilesecuritysdk/face/c;-><init>(Lcom/alipay/apmobilesecuritysdk/face/a;)V

    invoke-virtual {v0, v1}, Ljava/lang/Thread;->setUncaughtExceptionHandler(Ljava/lang/Thread$UncaughtExceptionHandler;)V

    iget-object v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a;->a:Ljava/lang/Thread;

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    :cond_0
    return-void
.end method

.method static synthetic a(Lcom/alipay/apmobilesecuritysdk/face/a;Z)Z
    .locals 0

    iput-boolean p1, p0, Lcom/alipay/apmobilesecuritysdk/face/a;->f:Z

    return p1
.end method

.method private b()Lcom/alipay/apmobilesecuritysdk/face/a$c;
    .locals 6

    new-instance v0, Lcom/alipay/apmobilesecuritysdk/face/a$c;

    invoke-direct {v0, p0}, Lcom/alipay/apmobilesecuritysdk/face/a$c;-><init>(Lcom/alipay/apmobilesecuritysdk/face/a;)V

    :try_start_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    iget-object v1, p0, Lcom/alipay/apmobilesecuritysdk/face/a;->e:Landroid/content/Context;

    invoke-static {v1}, Lcom/alipay/apmobilesecuritysdk/a/a;->a(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/alipay/apmobilesecuritysdk/face/a$c;->b:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v4, "getLocalApdidToken spend "

    invoke-direct {v1, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    sub-long v2, v4, v2

    invoke-virtual {v1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " ms"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/alipay/apmobilesecuritysdk/face/a;->e:Landroid/content/Context;

    invoke-static {v1}, Lcom/alipay/apmobilesecuritysdk/a/a;->b(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/alipay/apmobilesecuritysdk/face/a$c;->c:Ljava/lang/String;

    iget-object v1, p0, Lcom/alipay/apmobilesecuritysdk/face/a;->e:Landroid/content/Context;

    invoke-static {v1}, Lcom/alipay/apmobilesecuritysdk/d/a;->a(Landroid/content/Context;)Lcom/alipay/apmobilesecuritysdk/d/a;

    invoke-static {}, Lcom/alipay/apmobilesecuritysdk/d/a;->a()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/alipay/apmobilesecuritysdk/face/a$c;->a:Ljava/lang/String;

    iget-object v1, p0, Lcom/alipay/apmobilesecuritysdk/face/a;->e:Landroid/content/Context;

    invoke-static {v1}, Lcom/alipay/apmobilesecuritysdk/f/b;->a(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/alipay/apmobilesecuritysdk/face/a$c;->d:Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_0
    return-object v0

    :catch_0
    move-exception v1

    goto :goto_0
.end method

.method static synthetic b(Lcom/alipay/apmobilesecuritysdk/face/a;)Ljava/lang/Thread;
    .locals 1

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a;->a:Ljava/lang/Thread;

    return-object v0
.end method

.method static synthetic c(Lcom/alipay/apmobilesecuritysdk/face/a;)Landroid/content/Context;
    .locals 1

    iget-object v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a;->e:Landroid/content/Context;

    return-object v0
.end method

.method static synthetic d(Lcom/alipay/apmobilesecuritysdk/face/a;)Z
    .locals 1

    iget-boolean v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a;->f:Z

    return v0
.end method
