.class public final Lcom/alipay/sdk/util/d;
.super Ljava/lang/Object;
.source "SourceFile"


# static fields
.field private static a:Ljava/util/concurrent/ThreadPoolExecutor;

.field private static b:Ljava/lang/Object;

.field private static c:Lorg/apache/http/client/methods/HttpPost;


# direct methods
.method static constructor <clinit>()V
    .locals 8

    .prologue
    const/4 v2, 0x5

    .line 27
    new-instance v1, Ljava/util/concurrent/ThreadPoolExecutor;

    const-wide/16 v4, 0x3c

    sget-object v6, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    new-instance v7, Ljava/util/concurrent/LinkedBlockingQueue;

    const/16 v0, 0x14

    invoke-direct {v7, v0}, Ljava/util/concurrent/LinkedBlockingQueue;-><init>(I)V

    move v3, v2

    invoke-direct/range {v1 .. v7}, Ljava/util/concurrent/ThreadPoolExecutor;-><init>(IIJLjava/util/concurrent/TimeUnit;Ljava/util/concurrent/BlockingQueue;)V

    sput-object v1, Lcom/alipay/sdk/util/d;->a:Ljava/util/concurrent/ThreadPoolExecutor;

    .line 29
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/alipay/sdk/util/d;->b:Ljava/lang/Object;

    .line 30
    new-instance v0, Lorg/apache/http/client/methods/HttpPost;

    const-string v1, "https://mclient.alipay.com/sdkErrorlog.do"

    invoke-direct {v0, v1}, Lorg/apache/http/client/methods/HttpPost;-><init>(Ljava/lang/String;)V

    sput-object v0, Lcom/alipay/sdk/util/d;->c:Lorg/apache/http/client/methods/HttpPost;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 26
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic a()Ljava/lang/Object;
    .locals 1

    .prologue
    .line 26
    sget-object v0, Lcom/alipay/sdk/util/d;->b:Ljava/lang/Object;

    return-object v0
.end method

.method public static a(Ljava/lang/String;)V
    .locals 2

    .prologue
    .line 40
    sget-object v0, Lcom/alipay/sdk/util/d;->a:Ljava/util/concurrent/ThreadPoolExecutor;

    new-instance v1, Lcom/alipay/sdk/util/e;

    invoke-direct {v1, p0}, Lcom/alipay/sdk/util/e;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Ljava/util/concurrent/ThreadPoolExecutor;->execute(Ljava/lang/Runnable;)V

    .line 64
    return-void
.end method

.method static synthetic b()Lorg/apache/http/client/methods/HttpPost;
    .locals 1

    .prologue
    .line 26
    sget-object v0, Lcom/alipay/sdk/util/d;->c:Lorg/apache/http/client/methods/HttpPost;

    return-object v0
.end method
