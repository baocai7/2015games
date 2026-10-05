.class final Lcom/alipay/android/phone/mrpc/core/p;
.super Ljava/lang/Object;

# interfaces
.implements Lcom/alipay/android/phone/mrpc/core/n;


# instance fields
.field final synthetic a:Lcom/alipay/android/phone/mrpc/core/e;

.field final synthetic b:Lcom/alipay/android/phone/mrpc/core/o;


# direct methods
.method constructor <init>(Lcom/alipay/android/phone/mrpc/core/o;Lcom/alipay/android/phone/mrpc/core/e;)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/android/phone/mrpc/core/p;->b:Lcom/alipay/android/phone/mrpc/core/o;

    iput-object p2, p0, Lcom/alipay/android/phone/mrpc/core/p;->a:Lcom/alipay/android/phone/mrpc/core/e;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final a()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcom/alipay/android/phone/mrpc/core/p;->a:Lcom/alipay/android/phone/mrpc/core/e;

    iget-object v0, v0, Lcom/alipay/android/phone/mrpc/core/e;->a:Ljava/lang/String;

    return-object v0
.end method

.method public final b()Lcom/alipay/android/phone/mrpc/core/f;
    .locals 1

    iget-object v0, p0, Lcom/alipay/android/phone/mrpc/core/p;->b:Lcom/alipay/android/phone/mrpc/core/o;

    iget-object v0, v0, Lcom/alipay/android/phone/mrpc/core/o;->a:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/android/phone/mrpc/core/s;->a(Landroid/content/Context;)Lcom/alipay/android/phone/mrpc/core/s;

    move-result-object v0

    return-object v0
.end method

.method public final c()Lcom/alipay/android/phone/mrpc/core/e;
    .locals 1

    iget-object v0, p0, Lcom/alipay/android/phone/mrpc/core/p;->a:Lcom/alipay/android/phone/mrpc/core/e;

    return-object v0
.end method

.method public final d()Z
    .locals 1

    iget-object v0, p0, Lcom/alipay/android/phone/mrpc/core/p;->a:Lcom/alipay/android/phone/mrpc/core/e;

    iget-boolean v0, v0, Lcom/alipay/android/phone/mrpc/core/e;->c:Z

    return v0
.end method
