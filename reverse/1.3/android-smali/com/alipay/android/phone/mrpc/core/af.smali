.class public final Lcom/alipay/android/phone/mrpc/core/af;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/reflect/InvocationHandler;


# instance fields
.field protected a:Lcom/alipay/android/phone/mrpc/core/n;

.field protected b:Ljava/lang/Class;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/Class",
            "<*>;"
        }
    .end annotation
.end field

.field protected c:Lcom/alipay/android/phone/mrpc/core/ag;


# direct methods
.method public constructor <init>(Lcom/alipay/android/phone/mrpc/core/n;Ljava/lang/Class;Lcom/alipay/android/phone/mrpc/core/ag;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/alipay/android/phone/mrpc/core/n;",
            "Ljava/lang/Class",
            "<*>;",
            "Lcom/alipay/android/phone/mrpc/core/ag;",
            ")V"
        }
    .end annotation

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/alipay/android/phone/mrpc/core/af;->a:Lcom/alipay/android/phone/mrpc/core/n;

    iput-object p2, p0, Lcom/alipay/android/phone/mrpc/core/af;->b:Ljava/lang/Class;

    iput-object p3, p0, Lcom/alipay/android/phone/mrpc/core/af;->c:Lcom/alipay/android/phone/mrpc/core/ag;

    return-void
.end method


# virtual methods
.method public final invoke(Ljava/lang/Object;Ljava/lang/reflect/Method;[Ljava/lang/Object;)Ljava/lang/Object;
    .locals 2

    iget-object v0, p0, Lcom/alipay/android/phone/mrpc/core/af;->c:Lcom/alipay/android/phone/mrpc/core/ag;

    iget-object v1, p0, Lcom/alipay/android/phone/mrpc/core/af;->b:Ljava/lang/Class;

    invoke-virtual {v0, p2, p3}, Lcom/alipay/android/phone/mrpc/core/ag;->a(Ljava/lang/reflect/Method;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    return-object v0
.end method
