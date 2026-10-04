.class final Lcom/alipay/mobilesecuritysdk/face/a;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field private final synthetic a:Landroid/content/Context;

.field private final synthetic b:Ljava/util/List;

.field private final synthetic c:Z


# direct methods
.method constructor <init>(Landroid/content/Context;Ljava/util/List;Z)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/mobilesecuritysdk/face/a;->a:Landroid/content/Context;

    iput-object p2, p0, Lcom/alipay/mobilesecuritysdk/face/a;->b:Ljava/util/List;

    iput-boolean p3, p0, Lcom/alipay/mobilesecuritysdk/face/a;->c:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 4

    :try_start_0
    new-instance v0, Lcom/alipay/mobilesecuritysdk/a;

    invoke-direct {v0}, Lcom/alipay/mobilesecuritysdk/a;-><init>()V

    iget-object v0, p0, Lcom/alipay/mobilesecuritysdk/face/a;->a:Landroid/content/Context;

    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/face/a;->b:Ljava/util/List;

    iget-boolean v2, p0, Lcom/alipay/mobilesecuritysdk/face/a;->c:Z

    invoke-static {v0, v1, v2}, Lcom/alipay/mobilesecuritysdk/a;->a(Landroid/content/Context;Ljava/util/List;Z)I
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :cond_0
    :goto_0
    return-void

    :catch_0
    move-exception v0

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->access$0()Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "ALP"

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "mainThread error :"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method
