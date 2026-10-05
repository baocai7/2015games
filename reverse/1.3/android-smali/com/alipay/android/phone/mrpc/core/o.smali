.class public final Lcom/alipay/android/phone/mrpc/core/o;
.super Lcom/alipay/android/phone/mrpc/core/ad;


# instance fields
.field a:Landroid/content/Context;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 0

    invoke-direct {p0}, Lcom/alipay/android/phone/mrpc/core/ad;-><init>()V

    iput-object p1, p0, Lcom/alipay/android/phone/mrpc/core/o;->a:Landroid/content/Context;

    return-void
.end method

.method private static synthetic a(Lcom/alipay/android/phone/mrpc/core/o;)Landroid/content/Context;
    .locals 1

    iget-object v0, p0, Lcom/alipay/android/phone/mrpc/core/o;->a:Landroid/content/Context;

    return-object v0
.end method


# virtual methods
.method public final a(Ljava/lang/Class;Lcom/alipay/android/phone/mrpc/core/e;)Ljava/lang/Object;
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(",
            "Ljava/lang/Class",
            "<TT;>;",
            "Lcom/alipay/android/phone/mrpc/core/e;",
            ")TT;"
        }
    .end annotation

    new-instance v0, Lcom/alipay/android/phone/mrpc/core/ae;

    new-instance v1, Lcom/alipay/android/phone/mrpc/core/p;

    invoke-direct {v1, p0, p2}, Lcom/alipay/android/phone/mrpc/core/p;-><init>(Lcom/alipay/android/phone/mrpc/core/o;Lcom/alipay/android/phone/mrpc/core/e;)V

    invoke-direct {v0, v1}, Lcom/alipay/android/phone/mrpc/core/ae;-><init>(Lcom/alipay/android/phone/mrpc/core/n;)V

    invoke-virtual {p1}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/Class;

    const/4 v3, 0x0

    aput-object p1, v2, v3

    new-instance v3, Lcom/alipay/android/phone/mrpc/core/af;

    iget-object v4, v0, Lcom/alipay/android/phone/mrpc/core/ae;->a:Lcom/alipay/android/phone/mrpc/core/n;

    iget-object v0, v0, Lcom/alipay/android/phone/mrpc/core/ae;->b:Lcom/alipay/android/phone/mrpc/core/ag;

    invoke-direct {v3, v4, p1, v0}, Lcom/alipay/android/phone/mrpc/core/af;-><init>(Lcom/alipay/android/phone/mrpc/core/n;Ljava/lang/Class;Lcom/alipay/android/phone/mrpc/core/ag;)V

    invoke-static {v1, v2, v3}, Ljava/lang/reflect/Proxy;->newProxyInstance(Ljava/lang/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)Ljava/lang/Object;

    move-result-object v0

    return-object v0
.end method
