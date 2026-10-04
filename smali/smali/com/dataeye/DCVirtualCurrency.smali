.class public Lcom/dataeye/DCVirtualCurrency;
.super Ljava/lang/Object;


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static a(Ljava/lang/String;DLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 13

    invoke-static {}, Lcom/dataeye/c/a;->g()Lcom/dataeye/a/a;

    move-result-object v1

    if-nez v1, :cond_0

    const-string v1, "Invoke DCVirtualCurrency.paymentSuccess() fail , DataEye SDK need init first!"

    invoke-static {v1}, Lcom/dataeye/c/t;->c(Ljava/lang/String;)V

    :goto_0
    return-void

    :cond_0
    const-wide/16 v1, 0x0

    cmpg-double v1, p1, v1

    if-gtz v1, :cond_1

    const-string v1, "Invoke DCVirtualCurrency.paymentSuccess() fail\uff0creason: currencyAmount<0 "

    invoke-static {v1}, Lcom/dataeye/c/t;->c(Ljava/lang/String;)V

    const-string v1, "pay"

    const-string v2, "paymentSuccess"

    const-string v3, "fail"

    const/4 v4, 0x5

    new-array v4, v4, [Ljava/lang/Object;

    const/4 v5, 0x0

    aput-object p0, v4, v5

    const/4 v5, 0x1

    invoke-static {p1, p2}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v6

    aput-object v6, v4, v5

    const/4 v5, 0x2

    aput-object p3, v4, v5

    const/4 v5, 0x3

    const/4 v6, 0x0

    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    aput-object v6, v4, v5

    const/4 v5, 0x4

    aput-object p4, v4, v5

    invoke-static {v1, v2, v3, v4}, Lcom/dataeye/c/t;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Object;)V

    goto :goto_0

    :cond_1
    invoke-static {}, Lcom/dataeye/c/a;->g()Lcom/dataeye/a/a;

    move-result-object v1

    iget v10, v1, Lcom/dataeye/a/a;->g:I

    invoke-static {}, Lcom/dataeye/c/ab;->b()I

    move-result v1

    invoke-static {v1}, Lcom/dataeye/c/a;->g(I)V

    invoke-static/range {p3 .. p3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_4

    const-string v6, ""

    :goto_1
    invoke-static/range {p4 .. p4}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_5

    const-string v7, ""

    :goto_2
    new-instance v12, Ljava/util/HashMap;

    invoke-direct {v12}, Ljava/util/HashMap;-><init>()V

    invoke-static/range {p5 .. p5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_2

    const-string v1, "levelsId"

    move-object/from16 v0, p5

    invoke-virtual {v12, v1, v0}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_2
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_3

    const-string v1, "OrderId"

    invoke-virtual {v12, v1, p0}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_3
    new-instance v1, Lcom/dataeye/a/k;

    const-wide/16 v4, 0x0

    invoke-static {}, Lcom/dataeye/c/ab;->b()I

    move-result v8

    invoke-static {}, Lcom/dataeye/c/a;->e()Z

    move-result v11

    move-wide v2, p1

    move-object v9, p0

    invoke-direct/range {v1 .. v12}, Lcom/dataeye/a/k;-><init>(DDLjava/lang/String;Ljava/lang/String;ILjava/lang/String;IZLjava/util/Map;)V

    invoke-static {v1}, Lcom/dataeye/c/b;->a(Lcom/dataeye/a/k;)V

    const-string v1, "pay"

    const-string v2, "paymentSuccess"

    const-string v3, "succ"

    const/4 v4, 0x5

    new-array v4, v4, [Ljava/lang/Object;

    const/4 v5, 0x0

    aput-object p0, v4, v5

    const/4 v5, 0x1

    invoke-static {p1, p2}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v8

    aput-object v8, v4, v5

    const/4 v5, 0x2

    aput-object v6, v4, v5

    const/4 v5, 0x3

    const/4 v6, 0x0

    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    aput-object v6, v4, v5

    const/4 v5, 0x4

    aput-object v7, v4, v5

    invoke-static {v1, v2, v3, v4}, Lcom/dataeye/c/t;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Object;)V

    const/4 v1, 0x0

    invoke-static {v1}, Lcom/dataeye/c/b;->a(Z)V

    goto/16 :goto_0

    :cond_4
    move-object/from16 v6, p3

    goto :goto_1

    :cond_5
    move-object/from16 v7, p4

    goto :goto_2
.end method

.method public static paymentSuccess(DLjava/lang/String;Ljava/lang/String;)V
    .locals 1
    .param p0, "currencyAmount"    # D
    .param p2, "currencyType"    # Ljava/lang/String;
    .param p3, "paymentType"    # Ljava/lang/String;

    .prologue
    const-string v0, ""

    invoke-static {v0, p0, p1, p2, p3}, Lcom/dataeye/DCVirtualCurrency;->paymentSuccess(Ljava/lang/String;DLjava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static paymentSuccess(Ljava/lang/String;DLjava/lang/String;Ljava/lang/String;)V
    .locals 6
    .param p0, "orderId"    # Ljava/lang/String;
    .param p1, "currencyAmount"    # D
    .param p3, "currencyType"    # Ljava/lang/String;
    .param p4, "paymentType"    # Ljava/lang/String;

    .prologue
    const/4 v5, 0x0

    move-object v0, p0

    move-wide v1, p1

    move-object v3, p3

    move-object v4, p4

    invoke-static/range {v0 .. v5}, Lcom/dataeye/DCVirtualCurrency;->a(Ljava/lang/String;DLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    sget-boolean v0, Lcom/dataeye/c/b;->b:Z

    if-eqz v0, :cond_0

    const-string v0, "DCVirtualCurrency_paymentSuccess"

    invoke-static {v0}, Lcom/dataeye/c/s;->a(Ljava/lang/String;)V

    :cond_0
    return-void
.end method

.method public static paymentSuccessInLevel(DLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 6
    .param p0, "currencyAmount"    # D
    .param p2, "currencyType"    # Ljava/lang/String;
    .param p3, "paymentType"    # Ljava/lang/String;
    .param p4, "levelId"    # Ljava/lang/String;

    .prologue
    const-string v0, ""

    move-wide v1, p0

    move-object v3, p2

    move-object v4, p3

    move-object v5, p4

    invoke-static/range {v0 .. v5}, Lcom/dataeye/DCVirtualCurrency;->paymentSuccessInLevel(Ljava/lang/String;DLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static paymentSuccessInLevel(Ljava/lang/String;DLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 1
    .param p0, "orderId"    # Ljava/lang/String;
    .param p1, "currencyAmount"    # D
    .param p3, "currencyType"    # Ljava/lang/String;
    .param p4, "paymentType"    # Ljava/lang/String;
    .param p5, "levelId"    # Ljava/lang/String;

    .prologue
    invoke-static/range {p0 .. p5}, Lcom/dataeye/DCVirtualCurrency;->a(Ljava/lang/String;DLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    sget-boolean v0, Lcom/dataeye/c/b;->b:Z

    if-eqz v0, :cond_0

    const-string v0, "DCVirtualCurrency_paymentSuccessInLevel"

    invoke-static {v0}, Lcom/dataeye/c/s;->a(Ljava/lang/String;)V

    :cond_0
    return-void
.end method
