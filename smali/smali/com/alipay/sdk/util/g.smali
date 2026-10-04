.class public Lcom/alipay/sdk/util/g;
.super Ljava/lang/Object;


# static fields
.field public static final a:Ljava/lang/String; = "failed"


# instance fields
.field private b:Landroid/app/Activity;

.field private c:Lcom/alipay/android/app/IAlixPay;

.field private d:Ljava/lang/Object;

.field private e:Z

.field private f:Landroid/content/ServiceConnection;

.field private g:Lcom/alipay/android/app/IRemoteServiceCallback;


# direct methods
.method public constructor <init>(Landroid/app/Activity;)V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const-class v0, Lcom/alipay/android/app/IAlixPay;

    iput-object v0, p0, Lcom/alipay/sdk/util/g;->d:Ljava/lang/Object;

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/alipay/sdk/util/g;->e:Z

    new-instance v0, Lcom/alipay/sdk/util/h;

    invoke-direct {v0, p0}, Lcom/alipay/sdk/util/h;-><init>(Lcom/alipay/sdk/util/g;)V

    iput-object v0, p0, Lcom/alipay/sdk/util/g;->f:Landroid/content/ServiceConnection;

    new-instance v0, Lcom/alipay/sdk/util/i;

    invoke-direct {v0, p0}, Lcom/alipay/sdk/util/i;-><init>(Lcom/alipay/sdk/util/g;)V

    iput-object v0, p0, Lcom/alipay/sdk/util/g;->g:Lcom/alipay/android/app/IRemoteServiceCallback;

    iput-object p1, p0, Lcom/alipay/sdk/util/g;->b:Landroid/app/Activity;

    return-void
.end method

.method static synthetic a(Lcom/alipay/sdk/util/g;Lcom/alipay/android/app/IAlixPay;)Lcom/alipay/android/app/IAlixPay;
    .locals 0

    iput-object p1, p0, Lcom/alipay/sdk/util/g;->c:Lcom/alipay/android/app/IAlixPay;

    return-object p1
.end method

.method static synthetic a(Lcom/alipay/sdk/util/g;)Ljava/lang/Object;
    .locals 1

    iget-object v0, p0, Lcom/alipay/sdk/util/g;->d:Ljava/lang/Object;

    return-object v0
.end method

.method private a(Ljava/lang/String;Landroid/content/Intent;)Ljava/lang/String;
    .locals 6

    const/4 v3, 0x1

    const/4 v5, 0x0

    const/4 v1, 0x0

    iget-boolean v0, p0, Lcom/alipay/sdk/util/g;->e:Z

    if-eqz v0, :cond_0

    const-string v0, ""

    :goto_0
    return-object v0

    :cond_0
    iput-boolean v3, p0, Lcom/alipay/sdk/util/g;->e:Z

    iget-object v0, p0, Lcom/alipay/sdk/util/g;->c:Lcom/alipay/android/app/IAlixPay;

    if-nez v0, :cond_1

    iget-object v0, p0, Lcom/alipay/sdk/util/g;->b:Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    iget-object v2, p0, Lcom/alipay/sdk/util/g;->f:Landroid/content/ServiceConnection;

    invoke-virtual {v0, p2, v2, v3}, Landroid/content/Context;->bindService(Landroid/content/Intent;Landroid/content/ServiceConnection;I)Z

    :cond_1
    :try_start_0
    iget-object v2, p0, Lcom/alipay/sdk/util/g;->d:Ljava/lang/Object;

    monitor-enter v2
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    :try_start_1
    iget-object v0, p0, Lcom/alipay/sdk/util/g;->c:Lcom/alipay/android/app/IAlixPay;

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/alipay/sdk/util/g;->d:Ljava/lang/Object;

    const-wide/16 v3, 0xbb8

    invoke-virtual {v0, v3, v4}, Ljava/lang/Object;->wait(J)V

    :cond_2
    monitor-exit v2
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :try_start_2
    iget-object v0, p0, Lcom/alipay/sdk/util/g;->c:Lcom/alipay/android/app/IAlixPay;

    if-nez v0, :cond_3

    const-string v0, "failed"
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    :try_start_3
    iget-object v2, p0, Lcom/alipay/sdk/util/g;->b:Landroid/app/Activity;

    iget-object v3, p0, Lcom/alipay/sdk/util/g;->f:Landroid/content/ServiceConnection;

    invoke-virtual {v2, v3}, Landroid/app/Activity;->unbindService(Landroid/content/ServiceConnection;)V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_1

    :goto_1
    iput-boolean v5, p0, Lcom/alipay/sdk/util/g;->e:Z

    goto :goto_0

    :catchall_0
    move-exception v0

    :try_start_4
    monitor-exit v2

    throw v0
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_0
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    :catch_0
    move-exception v0

    move-object v0, v1

    :goto_2
    :try_start_5
    iget-object v2, p0, Lcom/alipay/sdk/util/g;->b:Landroid/app/Activity;

    iget-object v3, p0, Lcom/alipay/sdk/util/g;->f:Landroid/content/ServiceConnection;

    invoke-virtual {v2, v3}, Landroid/app/Activity;->unbindService(Landroid/content/ServiceConnection;)V
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_3

    :goto_3
    iput-boolean v5, p0, Lcom/alipay/sdk/util/g;->e:Z

    goto :goto_0

    :catch_1
    move-exception v2

    iput-object v1, p0, Lcom/alipay/sdk/util/g;->c:Lcom/alipay/android/app/IAlixPay;

    goto :goto_1

    :cond_3
    :try_start_6
    iget-object v0, p0, Lcom/alipay/sdk/util/g;->c:Lcom/alipay/android/app/IAlixPay;

    iget-object v2, p0, Lcom/alipay/sdk/util/g;->g:Lcom/alipay/android/app/IRemoteServiceCallback;

    invoke-interface {v0, v2}, Lcom/alipay/android/app/IAlixPay;->registerCallback(Lcom/alipay/android/app/IRemoteServiceCallback;)V

    iget-object v0, p0, Lcom/alipay/sdk/util/g;->c:Lcom/alipay/android/app/IAlixPay;

    invoke-interface {v0, p1}, Lcom/alipay/android/app/IAlixPay;->Pay(Ljava/lang/String;)Ljava/lang/String;
    :try_end_6
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_6} :catch_0
    .catchall {:try_start_6 .. :try_end_6} :catchall_1

    move-result-object v0

    :try_start_7
    iget-object v2, p0, Lcom/alipay/sdk/util/g;->c:Lcom/alipay/android/app/IAlixPay;

    iget-object v3, p0, Lcom/alipay/sdk/util/g;->g:Lcom/alipay/android/app/IRemoteServiceCallback;

    invoke-interface {v2, v3}, Lcom/alipay/android/app/IAlixPay;->unregisterCallback(Lcom/alipay/android/app/IRemoteServiceCallback;)V

    const/4 v2, 0x0

    iput-object v2, p0, Lcom/alipay/sdk/util/g;->c:Lcom/alipay/android/app/IAlixPay;
    :try_end_7
    .catch Ljava/lang/Exception; {:try_start_7 .. :try_end_7} :catch_5
    .catchall {:try_start_7 .. :try_end_7} :catchall_1

    :try_start_8
    iget-object v2, p0, Lcom/alipay/sdk/util/g;->b:Landroid/app/Activity;

    iget-object v3, p0, Lcom/alipay/sdk/util/g;->f:Landroid/content/ServiceConnection;

    invoke-virtual {v2, v3}, Landroid/app/Activity;->unbindService(Landroid/content/ServiceConnection;)V
    :try_end_8
    .catch Ljava/lang/Exception; {:try_start_8 .. :try_end_8} :catch_2

    :goto_4
    iput-boolean v5, p0, Lcom/alipay/sdk/util/g;->e:Z

    goto :goto_0

    :catch_2
    move-exception v2

    iput-object v1, p0, Lcom/alipay/sdk/util/g;->c:Lcom/alipay/android/app/IAlixPay;

    goto :goto_4

    :catch_3
    move-exception v2

    iput-object v1, p0, Lcom/alipay/sdk/util/g;->c:Lcom/alipay/android/app/IAlixPay;

    goto :goto_3

    :catchall_1
    move-exception v0

    :try_start_9
    iget-object v2, p0, Lcom/alipay/sdk/util/g;->b:Landroid/app/Activity;

    iget-object v3, p0, Lcom/alipay/sdk/util/g;->f:Landroid/content/ServiceConnection;

    invoke-virtual {v2, v3}, Landroid/app/Activity;->unbindService(Landroid/content/ServiceConnection;)V
    :try_end_9
    .catch Ljava/lang/Exception; {:try_start_9 .. :try_end_9} :catch_4

    :goto_5
    iput-boolean v5, p0, Lcom/alipay/sdk/util/g;->e:Z

    throw v0

    :catch_4
    move-exception v2

    iput-object v1, p0, Lcom/alipay/sdk/util/g;->c:Lcom/alipay/android/app/IAlixPay;

    goto :goto_5

    :catch_5
    move-exception v2

    goto :goto_2
.end method

.method static synthetic b(Lcom/alipay/sdk/util/g;)Landroid/app/Activity;
    .locals 1

    iget-object v0, p0, Lcom/alipay/sdk/util/g;->b:Landroid/app/Activity;

    return-object v0
.end method


# virtual methods
.method public final a(Ljava/lang/String;)Ljava/lang/String;
    .locals 4

    iget-object v0, p0, Lcom/alipay/sdk/util/g;->b:Landroid/app/Activity;

    const-string v1, "com.eg.android.AlipayGphone"

    invoke-virtual {v0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    const/16 v2, 0x40

    invoke-virtual {v0, v2}, Landroid/content/pm/PackageManager;->getInstalledPackages(I)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/content/pm/PackageInfo;

    iget-object v3, v0, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    invoke-virtual {v3, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_0

    iget-object v0, v0, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;

    const/4 v1, 0x0

    aget-object v0, v0, v1

    invoke-virtual {v0}, Landroid/content/pm/Signature;->toByteArray()[B

    move-result-object v0

    :goto_0
    invoke-static {v0}, Lcom/alipay/sdk/util/j;->a([B)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_2

    const-string v1, "b6cbad6cbd5ed0d209afc69ad3b7a617efaae9b3c47eabe0be42d924936fa78c8001b1fd74b079e5ff9690061dacfa4768e981a526b9ca77156ca36251cf2f906d105481374998a7e6e6e18f75ca98b8ed2eaf86ff402c874cca0a263053f22237858206867d210020daa38c48b20cc9dfd82b44a51aeb5db459b22794e2d649"

    invoke-static {v0, v1}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_2

    invoke-static {}, Lcom/alipay/sdk/app/ab;->b()Ljava/lang/String;

    move-result-object v0

    :goto_1
    return-object v0

    :cond_1
    const/4 v0, 0x0

    goto :goto_0

    :cond_2
    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0}, Landroid/content/Intent;-><init>()V

    const-string v1, "com.eg.android.AlipayGphone"

    const-string v2, "com.alipay.android.app.MspService"

    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->setClassName(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const-string v1, "com.eg.android.AlipayGphone.IAlixPay"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    invoke-direct {p0, p1, v0}, Lcom/alipay/sdk/util/g;->a(Ljava/lang/String;Landroid/content/Intent;)Ljava/lang/String;

    move-result-object v0

    goto :goto_1
.end method
