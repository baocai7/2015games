.class public Lcom/alipay/sdk/app/AuthTask;
.super Ljava/lang/Object;


# instance fields
.field private a:Landroid/app/Activity;


# direct methods
.method public constructor <init>(Landroid/app/Activity;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/alipay/sdk/app/AuthTask;->a:Landroid/app/Activity;

    return-void
.end method


# virtual methods
.method public declared-synchronized auth(Ljava/lang/String;)Ljava/lang/String;
    .locals 3

    monitor-enter p0

    :try_start_0
    invoke-static {}, Lcom/alipay/sdk/sys/a;->a()Lcom/alipay/sdk/sys/a;

    move-result-object v0

    iget-object v1, p0, Lcom/alipay/sdk/app/AuthTask;->a:Landroid/app/Activity;

    invoke-static {}, Lcom/alipay/sdk/data/d;->a()Lcom/alipay/sdk/data/d;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lcom/alipay/sdk/sys/a;->a(Landroid/content/Context;Lcom/alipay/sdk/data/d;)V

    iget-object v0, p0, Lcom/alipay/sdk/app/AuthTask;->a:Landroid/app/Activity;

    invoke-static {v0, p1}, Lcom/alipay/sdk/util/b;->a(Landroid/app/Activity;Ljava/lang/String;)Ljava/lang/String;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move-result-object v0

    monitor-exit p0

    return-object v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method
