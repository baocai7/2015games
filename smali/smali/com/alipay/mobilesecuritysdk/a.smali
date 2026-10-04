.class public final Lcom/alipay/mobilesecuritysdk/a;
.super Ljava/lang/Object;


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static a(Landroid/content/Context;Ljava/util/List;Z)I
    .locals 12
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/util/List",
            "<",
            "Ljava/lang/String;",
            ">;Z)I"
        }
    .end annotation

    const/4 v1, 0x0

    const/4 v0, 0x1

    if-nez p2, :cond_1

    :cond_0
    :goto_0
    return v0

    :cond_1
    new-instance v2, Lcom/alipay/mobilesecuritysdk/model/b;

    invoke-direct {v2}, Lcom/alipay/mobilesecuritysdk/model/b;-><init>()V

    new-instance v2, Lcom/alipay/mobilesecuritysdk/model/d;

    invoke-direct {v2, p0}, Lcom/alipay/mobilesecuritysdk/model/d;-><init>(Landroid/content/Context;)V

    new-instance v3, Lcom/alipay/mobilesecuritysdk/datainfo/e;

    invoke-direct {v3}, Lcom/alipay/mobilesecuritysdk/datainfo/e;-><init>()V

    new-instance v4, Lcom/alipay/mobilesecuritysdk/model/a;

    invoke-direct {v4}, Lcom/alipay/mobilesecuritysdk/model/a;-><init>()V

    :try_start_0
    invoke-static {p1}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/util/List;)Z

    move-result v4

    if-eqz v4, :cond_2

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->isDebug()Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "ALP"

    const-string v2, "tid is empty, quit!"

    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :catch_0
    move-exception v1

    goto :goto_0

    :cond_2
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v6

    invoke-virtual {v6}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Lcom/alipay/mobilesecuritysdk/model/b;->a(Ljava/lang/String;)Lcom/alipay/mobilesecuritysdk/datainfo/d;

    move-result-object v6

    if-nez v6, :cond_3

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->isDebug()Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "ALP"

    const-string v2, "loadConfig is null"

    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :cond_3
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/Thread;->isInterrupted()Z

    move-result v7

    if-nez v7, :cond_0

    invoke-virtual {v6}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->b()J

    move-result-wide v7

    const-wide/32 v9, 0x5265c00

    invoke-virtual {v6}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->d()I

    move-result v11

    invoke-static {v7, v8, v9, v10, v11}, Lcom/alipay/mobilesecuritysdk/util/a;->a(JJI)Z

    move-result v7

    if-eqz v7, :cond_6

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/model/d;->a()Lcom/alipay/mobilesecuritysdk/datainfo/b;

    move-result-object v7

    if-eqz v7, :cond_6

    iget-boolean v8, v7, Lcom/alipay/mobilesecuritysdk/datainfo/b;->a:Z

    if-eqz v8, :cond_6

    iget-object v8, v7, Lcom/alipay/mobilesecuritysdk/datainfo/b;->b:Ljava/lang/String;

    invoke-static {v8}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v8

    if-nez v8, :cond_5

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->isDebug()Z

    move-result v8

    if-eqz v8, :cond_4

    const-string v8, "ALP"

    const-string v9, "main switch updated."

    invoke-static {v8, v9}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_4
    iget-object v7, v7, Lcom/alipay/mobilesecuritysdk/datainfo/b;->b:Ljava/lang/String;

    const-string v8, "on"

    invoke-static {v7, v8}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_8

    const-string v7, "on"

    invoke-virtual {v6, v7}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->a(Ljava/lang/String;)V

    :cond_5
    :goto_1
    invoke-virtual {v6, v4, v5}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->a(J)V

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v8

    invoke-virtual {v8}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v8

    invoke-static {v8}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v8

    invoke-direct {v7, v8}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v8, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    const-string v8, "seccliconfig.xml"

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-static {v6, v7}, Lcom/alipay/mobilesecuritysdk/model/b;->a(Lcom/alipay/mobilesecuritysdk/datainfo/d;Ljava/lang/String;)V

    :cond_6
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/Thread;->isInterrupted()Z

    move-result v7

    if-nez v7, :cond_0

    const-string v7, "on"

    invoke-virtual {v6}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->c()Ljava/lang/String;

    move-result-object v8

    invoke-static {v7, v8}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v7

    if-nez v7, :cond_9

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->isDebug()Z

    move-result v2

    if-eqz v2, :cond_7

    const-string v2, "ALP"

    const-string v3, "main switch is off, quit!"

    invoke-static {v2, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_7
    move v0, v1

    goto/16 :goto_0

    :cond_8
    const-string v7, "off"

    invoke-virtual {v6, v7}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->a(Ljava/lang/String;)V

    goto :goto_1

    :cond_9
    invoke-virtual {v6}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->e()J

    move-result-wide v7

    const-wide/32 v9, 0xea60

    invoke-virtual {v6}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->f()I

    move-result v11

    invoke-static {v7, v8, v9, v10, v11}, Lcom/alipay/mobilesecuritysdk/util/a;->a(JJI)Z

    move-result v7

    if-eqz v7, :cond_b

    invoke-static {p0}, Lcom/alipay/mobilesecuritysdk/model/a;->a(Landroid/content/Context;)Ljava/util/List;

    move-result-object v7

    if-eqz v7, :cond_b

    invoke-interface {v7}, Ljava/util/List;->size()I

    move-result v8

    if-lez v8, :cond_b

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->isDebug()Z

    move-result v8

    if-eqz v8, :cond_a

    const-string v8, "ALP"

    const-string v9, "location collected."

    invoke-static {v8, v9}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_a
    iput-object v7, v3, Lcom/alipay/mobilesecuritysdk/datainfo/e;->a:Ljava/util/List;

    invoke-virtual {v6, v4, v5}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->b(J)V

    :cond_b
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/Thread;->isInterrupted()Z

    move-result v7

    if-nez v7, :cond_0

    invoke-virtual {v6}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->g()J

    move-result-wide v7

    const-wide/32 v9, 0x5265c00

    invoke-virtual {v6}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->h()I

    move-result v11

    invoke-static {v7, v8, v9, v10, v11}, Lcom/alipay/mobilesecuritysdk/util/a;->a(JJI)Z

    move-result v7

    if-eqz v7, :cond_d

    invoke-static {p0}, Lcom/alipay/mobilesecuritysdk/model/a;->b(Landroid/content/Context;)Ljava/util/List;

    move-result-object v7

    if-eqz v7, :cond_d

    invoke-interface {v7}, Ljava/util/List;->size()I

    move-result v8

    if-lez v8, :cond_d

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->isDebug()Z

    move-result v8

    if-eqz v8, :cond_c

    const-string v8, "ALP"

    const-string v9, "app info collected."

    invoke-static {v8, v9}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_c
    iput-object v7, v3, Lcom/alipay/mobilesecuritysdk/datainfo/e;->b:Ljava/util/List;

    invoke-virtual {v6, v4, v5}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->c(J)V

    :cond_d
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Thread;->isInterrupted()Z

    move-result v4

    if-nez v4, :cond_0

    iput-object v3, v2, Lcom/alipay/mobilesecuritysdk/model/d;->a:Lcom/alipay/mobilesecuritysdk/datainfo/e;

    invoke-virtual {v2, p1}, Lcom/alipay/mobilesecuritysdk/model/d;->a(Ljava/util/List;)Lcom/alipay/mobilesecuritysdk/datainfo/b;

    move-result-object v2

    if-eqz v2, :cond_13

    iget-boolean v3, v2, Lcom/alipay/mobilesecuritysdk/datainfo/b;->a:Z

    if-eqz v3, :cond_13

    invoke-static {}, Lcom/alipay/mobilesecuritysdk/face/SecurityClientMobile;->isDebug()Z

    move-result v3

    if-eqz v3, :cond_e

    const-string v3, "ALP"

    const-string v4, "data have been upload."

    invoke-static {v3, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_e
    iget v3, v2, Lcom/alipay/mobilesecuritysdk/datainfo/b;->c:I

    if-lez v3, :cond_f

    iget v3, v2, Lcom/alipay/mobilesecuritysdk/datainfo/b;->c:I

    invoke-virtual {v6, v3}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->a(I)V

    :cond_f
    iget v3, v2, Lcom/alipay/mobilesecuritysdk/datainfo/b;->d:I

    if-lez v3, :cond_10

    iget v3, v2, Lcom/alipay/mobilesecuritysdk/datainfo/b;->d:I

    invoke-virtual {v6, v3}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->b(I)V

    :cond_10
    iget v3, v2, Lcom/alipay/mobilesecuritysdk/datainfo/b;->e:I

    if-lez v3, :cond_11

    iget v3, v2, Lcom/alipay/mobilesecuritysdk/datainfo/b;->e:I

    invoke-virtual {v6, v3}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->c(I)V

    :cond_11
    iget v3, v2, Lcom/alipay/mobilesecuritysdk/datainfo/b;->f:I

    if-lez v3, :cond_12

    iget v2, v2, Lcom/alipay/mobilesecuritysdk/datainfo/b;->f:I

    invoke-virtual {v6, v2}, Lcom/alipay/mobilesecuritysdk/datainfo/d;->d(I)V

    :cond_12
    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v2

    invoke-virtual {v2}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/alipay/mobilesecuritysdk/model/b;->c(Ljava/lang/String;)V

    :cond_13
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v3

    invoke-virtual {v3}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v3, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "seccliconfig.xml"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v6, v2}, Lcom/alipay/mobilesecuritysdk/model/b;->a(Lcom/alipay/mobilesecuritysdk/datainfo/d;Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move v0, v1

    goto/16 :goto_0
.end method
