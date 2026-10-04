.class public Lcom/alipay/sdk/app/PayTask;
.super Ljava/lang/Object;


# static fields
.field static final a:Ljava/lang/Object;


# instance fields
.field private b:Landroid/app/Activity;

.field private c:Ljava/lang/String;

.field private d:Z


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const-class v0, Lcom/alipay/sdk/util/g;

    sput-object v0, Lcom/alipay/sdk/app/PayTask;->a:Ljava/lang/Object;

    return-void
.end method

.method public constructor <init>(Landroid/app/Activity;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/alipay/sdk/app/PayTask;->b:Landroid/app/Activity;

    return-void
.end method

.method private a()Ljava/lang/String;
    .locals 3

    new-instance v0, Lcom/alipay/sdk/util/g;

    iget-object v1, p0, Lcom/alipay/sdk/app/PayTask;->b:Landroid/app/Activity;

    invoke-direct {v0, v1}, Lcom/alipay/sdk/util/g;-><init>(Landroid/app/Activity;)V

    iget-object v1, p0, Lcom/alipay/sdk/app/PayTask;->c:Ljava/lang/String;

    const-string v2, "bizcontext="

    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_0

    iget-object v1, p0, Lcom/alipay/sdk/app/PayTask;->c:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lcom/alipay/sdk/util/g;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :goto_0
    return-object v0

    :cond_0
    iget-object v1, p0, Lcom/alipay/sdk/app/PayTask;->c:Ljava/lang/String;

    const-string v2, "\""

    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_1

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Lcom/alipay/sdk/app/PayTask;->c:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "&bizcontext=\"{\"appkey\":\"2014052600006128\"}\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/sdk/util/g;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :cond_1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Lcom/alipay/sdk/app/PayTask;->c:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "&bizcontext={\"appkey\":\"2014052600006128\"}"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/sdk/util/g;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0
.end method

.method private a(Lcom/alipay/sdk/protocol/a;)Ljava/lang/String;
    .locals 5

    invoke-virtual {p1}, Lcom/alipay/sdk/protocol/a;->e()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/sdk/util/a;->a(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    new-instance v1, Landroid/content/Intent;

    iget-object v2, p0, Lcom/alipay/sdk/app/PayTask;->b:Landroid/app/Activity;

    const-class v3, Lcom/alipay/sdk/app/H5PayActivity;

    invoke-direct {v1, v2, v3}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    new-instance v2, Landroid/os/Bundle;

    invoke-direct {v2}, Landroid/os/Bundle;-><init>()V

    const/4 v3, 0x0

    aget-object v3, v0, v3

    const-string v4, "url"

    invoke-virtual {v2, v4, v3}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    array-length v3, v0

    const/4 v4, 0x2

    if-ne v3, v4, :cond_0

    const/4 v3, 0x1

    aget-object v0, v0, v3

    const-string v3, "cookie"

    invoke-virtual {v2, v3, v0}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    :cond_0
    invoke-virtual {v1, v2}, Landroid/content/Intent;->putExtras(Landroid/os/Bundle;)Landroid/content/Intent;

    iget-object v0, p0, Lcom/alipay/sdk/app/PayTask;->b:Landroid/app/Activity;

    invoke-virtual {v0, v1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    sget-object v1, Lcom/alipay/sdk/app/PayTask;->a:Ljava/lang/Object;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcom/alipay/sdk/app/PayTask;->a:Ljava/lang/Object;

    invoke-virtual {v0}, Ljava/lang/Object;->wait()V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :goto_0
    :try_start_1
    monitor-exit v1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    sget-object v0, Lcom/alipay/sdk/app/ab;->a:Ljava/lang/String;

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-static {}, Lcom/alipay/sdk/app/ab;->a()Ljava/lang/String;

    move-result-object v0

    :cond_1
    return-object v0

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0

    :catch_0
    move-exception v0

    goto :goto_0
.end method

.method private b()Ljava/lang/String;
    .locals 11

    const/4 v1, 0x0

    const/4 v2, 0x0

    :try_start_0
    iget-object v0, p0, Lcom/alipay/sdk/app/PayTask;->b:Landroid/app/Activity;

    if-eqz v0, :cond_b

    iget-object v0, p0, Lcom/alipay/sdk/app/PayTask;->b:Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/app/Activity;->isFinishing()Z

    move-result v0

    if-nez v0, :cond_b

    new-instance v0, Lcom/alipay/sdk/widget/a;

    iget-object v3, p0, Lcom/alipay/sdk/app/PayTask;->b:Landroid/app/Activity;

    invoke-direct {v0, v3}, Lcom/alipay/sdk/widget/a;-><init>(Landroid/app/Activity;)V

    invoke-virtual {v0}, Lcom/alipay/sdk/widget/a;->b()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :goto_0
    new-instance v3, Lcom/alipay/sdk/data/c;

    invoke-direct {v3}, Lcom/alipay/sdk/data/c;-><init>()V

    iget-object v4, p0, Lcom/alipay/sdk/app/PayTask;->c:Ljava/lang/String;

    new-instance v5, Lorg/json/JSONObject;

    invoke-direct {v5}, Lorg/json/JSONObject;-><init>()V

    invoke-static {v3, v4, v5}, Lcom/alipay/sdk/data/b;->a(Lcom/alipay/sdk/data/c;Ljava/lang/String;Lorg/json/JSONObject;)Lcom/alipay/sdk/data/e;

    move-result-object v3

    new-instance v4, Lcom/alipay/sdk/net/d;

    new-instance v5, Lcom/alipay/sdk/data/c;

    invoke-direct {v5}, Lcom/alipay/sdk/data/c;-><init>()V

    invoke-direct {v4, v5}, Lcom/alipay/sdk/net/d;-><init>(Lcom/alipay/sdk/data/c;)V

    :try_start_1
    iget-object v5, p0, Lcom/alipay/sdk/app/PayTask;->b:Landroid/app/Activity;

    const/4 v6, 0x0

    invoke-virtual {v4, v5, v3, v6}, Lcom/alipay/sdk/net/d;->a(Landroid/content/Context;Lcom/alipay/sdk/data/e;Z)Lcom/alipay/sdk/protocol/c;

    move-result-object v3

    iget-object v3, v3, Lcom/alipay/sdk/protocol/c;->c:Lorg/json/JSONObject;

    const-string v4, "form"

    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v3

    const-string v4, "onload"

    invoke-static {v3, v4}, Lcom/alipay/sdk/protocol/b;->a(Lorg/json/JSONObject;Ljava/lang/String;)Lcom/alipay/sdk/protocol/b;

    move-result-object v3

    invoke-static {v3}, Lcom/alipay/sdk/protocol/a;->a(Lcom/alipay/sdk/protocol/b;)[Lcom/alipay/sdk/protocol/a;

    move-result-object v4

    array-length v5, v4

    move v3, v2

    :goto_1
    if-ge v3, v5, :cond_4

    aget-object v6, v4, v3

    sget-object v7, Lcom/alipay/sdk/protocol/a;->f:Lcom/alipay/sdk/protocol/a;

    if-ne v6, v7, :cond_0

    invoke-virtual {v6}, Lcom/alipay/sdk/protocol/a;->e()Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Lcom/alipay/sdk/util/a;->a(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v6

    array-length v7, v6

    const/4 v8, 0x3

    if-ne v7, v8, :cond_0

    const-string v7, "tid"

    const/4 v8, 0x0

    aget-object v8, v6, v8

    invoke-static {v7, v8}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v7

    if-eqz v7, :cond_0

    invoke-static {}, Lcom/alipay/sdk/sys/a;->a()Lcom/alipay/sdk/sys/a;

    move-result-object v7

    iget-object v7, v7, Lcom/alipay/sdk/sys/a;->a:Landroid/content/Context;

    invoke-static {}, Lcom/alipay/sdk/tid/b;->a()Lcom/alipay/sdk/tid/b;

    move-result-object v8

    const/4 v9, 0x1

    aget-object v9, v6, v9

    invoke-static {v9}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v9

    if-nez v9, :cond_0

    const/4 v9, 0x2

    aget-object v9, v6, v9

    invoke-static {v9}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v9

    if-eqz v9, :cond_1

    :cond_0
    :goto_2
    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    :catch_0
    move-exception v0

    move-object v0, v1

    goto :goto_0

    :cond_1
    const/4 v9, 0x1

    aget-object v9, v6, v9

    iput-object v9, v8, Lcom/alipay/sdk/tid/b;->a:Ljava/lang/String;

    const/4 v9, 0x2

    aget-object v6, v6, v9

    iput-object v6, v8, Lcom/alipay/sdk/tid/b;->b:Ljava/lang/String;

    new-instance v6, Lcom/alipay/sdk/tid/a;

    invoke-direct {v6, v7}, Lcom/alipay/sdk/tid/a;-><init>(Landroid/content/Context;)V
    :try_end_1
    .catch Lcom/alipay/sdk/exception/NetErrorException; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_3
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    :try_start_2
    invoke-static {v7}, Lcom/alipay/sdk/util/c;->a(Landroid/content/Context;)Lcom/alipay/sdk/util/c;

    move-result-object v9

    invoke-virtual {v9}, Lcom/alipay/sdk/util/c;->a()Ljava/lang/String;

    move-result-object v9

    invoke-static {v7}, Lcom/alipay/sdk/util/c;->a(Landroid/content/Context;)Lcom/alipay/sdk/util/c;

    move-result-object v7

    invoke-virtual {v7}, Lcom/alipay/sdk/util/c;->b()Ljava/lang/String;

    move-result-object v7

    iget-object v10, v8, Lcom/alipay/sdk/tid/b;->a:Ljava/lang/String;

    iget-object v8, v8, Lcom/alipay/sdk/tid/b;->b:Ljava/lang/String;

    invoke-virtual {v6, v9, v7, v10, v8}, Lcom/alipay/sdk/tid/a;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    :try_start_3
    invoke-virtual {v6}, Lcom/alipay/sdk/tid/a;->close()V
    :try_end_3
    .catch Lcom/alipay/sdk/exception/NetErrorException; {:try_start_3 .. :try_end_3} :catch_1
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    goto :goto_2

    :catch_1
    move-exception v1

    :try_start_4
    sget-object v1, Lcom/alipay/sdk/app/ac;->d:Lcom/alipay/sdk/app/ac;

    invoke-virtual {v1}, Lcom/alipay/sdk/app/ac;->a()I

    move-result v1

    invoke-static {v1}, Lcom/alipay/sdk/app/ac;->a(I)Lcom/alipay/sdk/app/ac;
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    move-result-object v1

    if-eqz v0, :cond_a

    invoke-virtual {v0}, Lcom/alipay/sdk/widget/a;->c()V

    move-object v0, v1

    :goto_3
    if-nez v0, :cond_2

    sget-object v0, Lcom/alipay/sdk/app/ac;->b:Lcom/alipay/sdk/app/ac;

    invoke-virtual {v0}, Lcom/alipay/sdk/app/ac;->a()I

    move-result v0

    invoke-static {v0}, Lcom/alipay/sdk/app/ac;->a(I)Lcom/alipay/sdk/app/ac;

    move-result-object v0

    :cond_2
    invoke-virtual {v0}, Lcom/alipay/sdk/app/ac;->a()I

    move-result v1

    invoke-virtual {v0}, Lcom/alipay/sdk/app/ac;->b()Ljava/lang/String;

    move-result-object v0

    const-string v2, ""

    invoke-static {v1, v0, v2}, Lcom/alipay/sdk/app/ab;->a(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :goto_4
    return-object v0

    :catch_2
    move-exception v7

    :try_start_5
    invoke-virtual {v6}, Lcom/alipay/sdk/tid/a;->close()V
    :try_end_5
    .catch Lcom/alipay/sdk/exception/NetErrorException; {:try_start_5 .. :try_end_5} :catch_1
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_3
    .catchall {:try_start_5 .. :try_end_5} :catchall_1

    goto :goto_2

    :catch_3
    move-exception v2

    if-eqz v0, :cond_9

    invoke-virtual {v0}, Lcom/alipay/sdk/widget/a;->c()V

    move-object v0, v1

    goto :goto_3

    :catchall_0
    move-exception v2

    :try_start_6
    invoke-virtual {v6}, Lcom/alipay/sdk/tid/a;->close()V

    throw v2
    :try_end_6
    .catch Lcom/alipay/sdk/exception/NetErrorException; {:try_start_6 .. :try_end_6} :catch_1
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_6} :catch_3
    .catchall {:try_start_6 .. :try_end_6} :catchall_1

    :catchall_1
    move-exception v1

    if-eqz v0, :cond_3

    invoke-virtual {v0}, Lcom/alipay/sdk/widget/a;->c()V

    :cond_3
    throw v1

    :cond_4
    if-eqz v0, :cond_5

    :try_start_7
    invoke-virtual {v0}, Lcom/alipay/sdk/widget/a;->c()V

    :cond_5
    array-length v3, v4

    :goto_5
    if-ge v2, v3, :cond_8

    aget-object v5, v4, v2

    sget-object v6, Lcom/alipay/sdk/protocol/a;->a:Lcom/alipay/sdk/protocol/a;

    if-ne v5, v6, :cond_7

    invoke-direct {p0, v5}, Lcom/alipay/sdk/app/PayTask;->a(Lcom/alipay/sdk/protocol/a;)Ljava/lang/String;
    :try_end_7
    .catch Lcom/alipay/sdk/exception/NetErrorException; {:try_start_7 .. :try_end_7} :catch_1
    .catch Ljava/lang/Exception; {:try_start_7 .. :try_end_7} :catch_3
    .catchall {:try_start_7 .. :try_end_7} :catchall_1

    move-result-object v1

    if-eqz v0, :cond_6

    invoke-virtual {v0}, Lcom/alipay/sdk/widget/a;->c()V

    :cond_6
    move-object v0, v1

    goto :goto_4

    :cond_7
    add-int/lit8 v2, v2, 0x1

    goto :goto_5

    :cond_8
    if-eqz v0, :cond_9

    invoke-virtual {v0}, Lcom/alipay/sdk/widget/a;->c()V

    move-object v0, v1

    goto :goto_3

    :cond_9
    move-object v0, v1

    goto :goto_3

    :cond_a
    move-object v0, v1

    goto :goto_3

    :cond_b
    move-object v0, v1

    goto/16 :goto_0
.end method


# virtual methods
.method public checkAccountIfExist()Z
    .locals 5

    const/4 v0, 0x0

    invoke-static {}, Lcom/alipay/sdk/data/b;->a()Lcom/alipay/sdk/data/e;

    move-result-object v1

    :try_start_0
    new-instance v2, Lcom/alipay/sdk/net/d;

    invoke-direct {v2}, Lcom/alipay/sdk/net/d;-><init>()V

    iget-object v3, p0, Lcom/alipay/sdk/app/PayTask;->b:Landroid/app/Activity;

    const/4 v4, 0x1

    invoke-virtual {v2, v3, v1, v4}, Lcom/alipay/sdk/net/d;->a(Landroid/content/Context;Lcom/alipay/sdk/data/e;Z)Lcom/alipay/sdk/protocol/c;

    move-result-object v1

    iget-object v1, v1, Lcom/alipay/sdk/protocol/c;->c:Lorg/json/JSONObject;

    const-string v2, "hasAccount"

    const/4 v3, 0x0

    invoke-virtual {v1, v2, v3}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result v0

    :goto_0
    return v0

    :catch_0
    move-exception v1

    goto :goto_0
.end method

.method public getVersion()Ljava/lang/String;
    .locals 1

    const-string v0, "9.2.1"

    return-object v0
.end method

.method public declared-synchronized pay(Ljava/lang/String;)Ljava/lang/String;
    .locals 3

    monitor-enter p0

    :try_start_0
    iput-object p1, p0, Lcom/alipay/sdk/app/PayTask;->c:Ljava/lang/String;

    invoke-static {}, Lcom/alipay/sdk/sys/a;->a()Lcom/alipay/sdk/sys/a;

    move-result-object v0

    iget-object v1, p0, Lcom/alipay/sdk/app/PayTask;->b:Landroid/app/Activity;

    invoke-static {}, Lcom/alipay/sdk/data/d;->a()Lcom/alipay/sdk/data/d;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lcom/alipay/sdk/sys/a;->a(Landroid/content/Context;Lcom/alipay/sdk/data/d;)V

    const-string v0, "paymethod=\"expressGateway\""

    invoke-virtual {p1, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-direct {p0}, Lcom/alipay/sdk/app/PayTask;->b()Ljava/lang/String;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move-result-object v0

    :cond_0
    :goto_0
    monitor-exit p0

    return-object v0

    :cond_1
    :try_start_1
    iget-object v0, p0, Lcom/alipay/sdk/app/PayTask;->b:Landroid/app/Activity;

    invoke-static {v0}, Lcom/alipay/sdk/util/j;->b(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_8

    iget-object v0, p0, Lcom/alipay/sdk/app/PayTask;->b:Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/app/Activity;->getRequestedOrientation()I

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/alipay/sdk/app/PayTask;->b:Landroid/app/Activity;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/app/Activity;->setRequestedOrientation(I)V

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/alipay/sdk/app/PayTask;->d:Z

    :cond_2
    new-instance v0, Lcom/alipay/sdk/util/g;

    iget-object v1, p0, Lcom/alipay/sdk/app/PayTask;->b:Landroid/app/Activity;

    invoke-direct {v0, v1}, Lcom/alipay/sdk/util/g;-><init>(Landroid/app/Activity;)V

    iget-object v1, p0, Lcom/alipay/sdk/app/PayTask;->c:Ljava/lang/String;

    const-string v2, "bizcontext="

    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_4

    iget-object v1, p0, Lcom/alipay/sdk/app/PayTask;->c:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lcom/alipay/sdk/util/g;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :goto_1
    const-string v1, "failed"

    invoke-static {v0, v1}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_6

    iget-boolean v0, p0, Lcom/alipay/sdk/app/PayTask;->d:Z

    if-eqz v0, :cond_3

    iget-object v0, p0, Lcom/alipay/sdk/app/PayTask;->b:Landroid/app/Activity;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/app/Activity;->setRequestedOrientation(I)V

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/alipay/sdk/app/PayTask;->d:Z

    :cond_3
    invoke-direct {p0}, Lcom/alipay/sdk/app/PayTask;->b()Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :cond_4
    iget-object v1, p0, Lcom/alipay/sdk/app/PayTask;->c:Ljava/lang/String;

    const-string v2, "\""

    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_5

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Lcom/alipay/sdk/app/PayTask;->c:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "&bizcontext=\"{\"appkey\":\"2014052600006128\"}\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/sdk/util/g;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    goto :goto_1

    :cond_5
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Lcom/alipay/sdk/app/PayTask;->c:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "&bizcontext={\"appkey\":\"2014052600006128\"}"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/alipay/sdk/util/g;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    goto :goto_1

    :cond_6
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_7

    invoke-static {}, Lcom/alipay/sdk/app/ab;->a()Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_0

    :cond_7
    iget-boolean v1, p0, Lcom/alipay/sdk/app/PayTask;->d:Z

    if-eqz v1, :cond_0

    iget-object v1, p0, Lcom/alipay/sdk/app/PayTask;->b:Landroid/app/Activity;

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/app/Activity;->setRequestedOrientation(I)V

    const/4 v1, 0x0

    iput-boolean v1, p0, Lcom/alipay/sdk/app/PayTask;->d:Z
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto/16 :goto_0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0

    :cond_8
    :try_start_2
    invoke-direct {p0}, Lcom/alipay/sdk/app/PayTask;->b()Ljava/lang/String;
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    move-result-object v0

    goto/16 :goto_0
.end method
