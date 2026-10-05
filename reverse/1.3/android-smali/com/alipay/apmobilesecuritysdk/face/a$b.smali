.class public final Lcom/alipay/apmobilesecuritysdk/face/a$b;
.super Ljava/lang/Object;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/alipay/apmobilesecuritysdk/face/a;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "b"
.end annotation


# instance fields
.field a:I

.field b:Ljava/lang/String;

.field c:Ljava/lang/String;

.field d:Ljava/lang/String;

.field e:Lcom/alipay/apmobilesecuritysdk/face/a$a;

.field final synthetic f:Lcom/alipay/apmobilesecuritysdk/face/a;


# direct methods
.method public constructor <init>(Lcom/alipay/apmobilesecuritysdk/face/a;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    iput-object p1, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->f:Lcom/alipay/apmobilesecuritysdk/face/a;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    iput v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->a:I

    iput-object p4, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->d:Ljava/lang/String;

    invoke-static {p2}, Lcom/alipay/security/mobile/module/commonutils/a;->a(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-static {p1}, Lcom/alipay/apmobilesecuritysdk/face/a;->c(Lcom/alipay/apmobilesecuritysdk/face/a;)Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/apmobilesecuritysdk/d/b;->a(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->b:Ljava/lang/String;

    :goto_0
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "Utdid = "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->b:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iput-object p3, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->c:Ljava/lang/String;

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->e:Lcom/alipay/apmobilesecuritysdk/face/a$a;

    return-void

    :cond_0
    iput-object p2, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->b:Ljava/lang/String;

    goto :goto_0
.end method

.method private a()V
    .locals 4

    const/4 v3, 0x0

    iget-object v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->f:Lcom/alipay/apmobilesecuritysdk/face/a;

    invoke-static {v0}, Lcom/alipay/apmobilesecuritysdk/face/a;->d(Lcom/alipay/apmobilesecuritysdk/face/a;)Z

    move-result v0

    if-eqz v0, :cond_0

    :goto_0
    return-void

    :cond_0
    iget-object v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->f:Lcom/alipay/apmobilesecuritysdk/face/a;

    const/4 v1, 0x1

    invoke-static {v0, v1}, Lcom/alipay/apmobilesecuritysdk/face/a;->a(Lcom/alipay/apmobilesecuritysdk/face/a;Z)Z

    :try_start_0
    iget-object v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->f:Lcom/alipay/apmobilesecuritysdk/face/a;

    invoke-static {v0}, Lcom/alipay/apmobilesecuritysdk/face/a;->c(Lcom/alipay/apmobilesecuritysdk/face/a;)Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/apmobilesecuritysdk/d/a;->a(Landroid/content/Context;)Lcom/alipay/apmobilesecuritysdk/d/a;

    iget v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->a:I

    invoke-static {}, Lcom/alipay/apmobilesecuritysdk/d/a;->b()Ljava/lang/String;

    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    const-string v1, "tid"

    iget-object v2, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->c:Ljava/lang/String;

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v1, "utdid"

    iget-object v2, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->b:Ljava/lang/String;

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v1, "umid"

    iget-object v2, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->f:Lcom/alipay/apmobilesecuritysdk/face/a;

    invoke-static {v2}, Lcom/alipay/apmobilesecuritysdk/face/a;->c(Lcom/alipay/apmobilesecuritysdk/face/a;)Landroid/content/Context;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/apmobilesecuritysdk/d/a;->a(Landroid/content/Context;)Lcom/alipay/apmobilesecuritysdk/d/a;

    invoke-static {}, Lcom/alipay/apmobilesecuritysdk/d/a;->a()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v1, "userId"

    iget-object v2, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->d:Ljava/lang/String;

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    iget-object v1, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->f:Lcom/alipay/apmobilesecuritysdk/face/a;

    invoke-static {v1}, Lcom/alipay/apmobilesecuritysdk/face/a;->c(Lcom/alipay/apmobilesecuritysdk/face/a;)Landroid/content/Context;

    move-result-object v1

    invoke-static {v1, v0}, Lcom/alipay/apmobilesecuritysdk/face/e;->a(Landroid/content/Context;Ljava/util/Map;)Ljava/lang/String;

    iget-object v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->e:Lcom/alipay/apmobilesecuritysdk/face/a$a;

    if-eqz v0, :cond_1

    new-instance v0, Lcom/alipay/apmobilesecuritysdk/face/a$c;

    iget-object v1, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->f:Lcom/alipay/apmobilesecuritysdk/face/a;

    invoke-direct {v0, v1}, Lcom/alipay/apmobilesecuritysdk/face/a$c;-><init>(Lcom/alipay/apmobilesecuritysdk/face/a;)V

    iget-object v1, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->f:Lcom/alipay/apmobilesecuritysdk/face/a;

    invoke-static {v1}, Lcom/alipay/apmobilesecuritysdk/face/a;->c(Lcom/alipay/apmobilesecuritysdk/face/a;)Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/apmobilesecuritysdk/a/a;->b(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/alipay/apmobilesecuritysdk/face/a$c;->c:Ljava/lang/String;

    iget-object v1, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->f:Lcom/alipay/apmobilesecuritysdk/face/a;

    invoke-static {v1}, Lcom/alipay/apmobilesecuritysdk/face/a;->c(Lcom/alipay/apmobilesecuritysdk/face/a;)Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/apmobilesecuritysdk/a/a;->a(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/alipay/apmobilesecuritysdk/face/a$c;->b:Ljava/lang/String;

    iget-object v1, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->f:Lcom/alipay/apmobilesecuritysdk/face/a;

    invoke-static {v1}, Lcom/alipay/apmobilesecuritysdk/face/a;->c(Lcom/alipay/apmobilesecuritysdk/face/a;)Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/apmobilesecuritysdk/d/a;->a(Landroid/content/Context;)Lcom/alipay/apmobilesecuritysdk/d/a;

    invoke-static {}, Lcom/alipay/apmobilesecuritysdk/d/a;->a()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/alipay/apmobilesecuritysdk/face/a$c;->a:Ljava/lang/String;

    iget-object v1, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->f:Lcom/alipay/apmobilesecuritysdk/face/a;

    invoke-static {v1}, Lcom/alipay/apmobilesecuritysdk/face/a;->c(Lcom/alipay/apmobilesecuritysdk/face/a;)Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/alipay/apmobilesecuritysdk/f/b;->a(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/alipay/apmobilesecuritysdk/face/a$c;->d:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "[*]result.apdid     = "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v2, v0, Lcom/alipay/apmobilesecuritysdk/face/a$c;->c:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "[*]result.token     = "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v2, v0, Lcom/alipay/apmobilesecuritysdk/face/a$c;->b:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "[*]result.umid      = "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v2, v0, Lcom/alipay/apmobilesecuritysdk/face/a$c;->a:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "[*]result.clientKey = "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, v0, Lcom/alipay/apmobilesecuritysdk/face/a$c;->d:Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->e:Lcom/alipay/apmobilesecuritysdk/face/a$a;
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :cond_1
    iget-object v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->f:Lcom/alipay/apmobilesecuritysdk/face/a;

    invoke-static {v0, v3}, Lcom/alipay/apmobilesecuritysdk/face/a;->a(Lcom/alipay/apmobilesecuritysdk/face/a;Z)Z

    goto/16 :goto_0

    :catch_0
    move-exception v0

    iget-object v0, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->f:Lcom/alipay/apmobilesecuritysdk/face/a;

    invoke-static {v0, v3}, Lcom/alipay/apmobilesecuritysdk/face/a;->a(Lcom/alipay/apmobilesecuritysdk/face/a;Z)Z

    goto/16 :goto_0

    :catchall_0
    move-exception v0

    iget-object v1, p0, Lcom/alipay/apmobilesecuritysdk/face/a$b;->f:Lcom/alipay/apmobilesecuritysdk/face/a;

    invoke-static {v1, v3}, Lcom/alipay/apmobilesecuritysdk/face/a;->a(Lcom/alipay/apmobilesecuritysdk/face/a;Z)Z

    throw v0
.end method
