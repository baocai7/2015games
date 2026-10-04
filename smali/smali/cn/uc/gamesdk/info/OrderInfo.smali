.class public Lcn/uc/gamesdk/info/OrderInfo;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/io/Serializable;


# static fields
.field private static final a:J = 0x3fd90074cbb6b189L


# instance fields
.field private b:Ljava/lang/String;

.field private c:F

.field private d:Ljava/lang/String;

.field private e:I


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static Create(Lorg/json/JSONObject;)Lcn/uc/gamesdk/info/OrderInfo;
    .locals 9

    const/4 v4, 0x0

    new-instance v7, Lcn/uc/gamesdk/info/OrderInfo;

    invoke-direct {v7}, Lcn/uc/gamesdk/info/OrderInfo;-><init>()V

    const/4 v3, 0x0

    const-string v2, ""

    const-string v0, ""

    :try_start_0
    const-string v1, "orderAmount"

    invoke-virtual {p0, v1}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "orderAmount"

    invoke-virtual {p0, v1}, Lorg/json/JSONObject;->getDouble(Ljava/lang/String;)D

    move-result-wide v5

    :goto_0
    double-to-float v3, v5

    const-string v1, "orderId"

    invoke-virtual {p0, v1}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    const-string v1, "orderId"

    invoke-virtual {p0, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    :goto_1
    const-string v1, "payWay"

    invoke-virtual {p0, v1}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_2

    const-string v1, "payWay"

    invoke-virtual {p0, v1}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    move-result v1

    :goto_2
    :try_start_1
    const-string v4, "payWayName"

    invoke-virtual {p0, v4}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_3

    const-string v4, "payWayName"

    invoke-virtual {p0, v4}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    :try_end_1
    .catch Lorg/json/JSONException; {:try_start_1 .. :try_end_1} :catch_1

    move-result-object v0

    :goto_3
    invoke-virtual {v7, v3}, Lcn/uc/gamesdk/info/OrderInfo;->setOrderAmount(F)V

    invoke-virtual {v7, v2}, Lcn/uc/gamesdk/info/OrderInfo;->setOrderId(Ljava/lang/String;)V

    invoke-virtual {v7, v1}, Lcn/uc/gamesdk/info/OrderInfo;->setPayWay(I)V

    invoke-virtual {v7, v0}, Lcn/uc/gamesdk/info/OrderInfo;->setPayWayName(Ljava/lang/String;)V

    return-object v7

    :cond_0
    const-wide/16 v5, 0x0

    goto :goto_0

    :cond_1
    :try_start_2
    const-string v2, ""
    :try_end_2
    .catch Lorg/json/JSONException; {:try_start_2 .. :try_end_2} :catch_0

    goto :goto_1

    :cond_2
    move v1, v4

    goto :goto_2

    :cond_3
    :try_start_3
    const-string v0, ""
    :try_end_3
    .catch Lorg/json/JSONException; {:try_start_3 .. :try_end_3} :catch_1

    goto :goto_3

    :catch_0
    move-exception v1

    move-object v8, v1

    move v1, v4

    move-object v4, v8

    :goto_4
    invoke-virtual {v4}, Lorg/json/JSONException;->printStackTrace()V

    goto :goto_3

    :catch_1
    move-exception v4

    goto :goto_4
.end method


# virtual methods
.method public getAmount()F
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    iget v0, p0, Lcn/uc/gamesdk/info/OrderInfo;->c:F

    return v0
.end method

.method public getJsonObject()Lorg/json/JSONObject;
    .locals 4

    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    :try_start_0
    const-string v0, "orderId"

    iget-object v2, p0, Lcn/uc/gamesdk/info/OrderInfo;->b:Ljava/lang/String;

    invoke-virtual {v1, v0, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v0, "orderAmount"

    iget v2, p0, Lcn/uc/gamesdk/info/OrderInfo;->c:F

    float-to-double v2, v2

    invoke-virtual {v1, v0, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    const-string v0, "payWay"

    iget v2, p0, Lcn/uc/gamesdk/info/OrderInfo;->e:I

    invoke-virtual {v1, v0, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    const-string v0, "payWayName"

    iget-object v2, p0, Lcn/uc/gamesdk/info/OrderInfo;->d:Ljava/lang/String;

    invoke-virtual {v1, v0, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    :goto_0
    return-object v1

    :catch_0
    move-exception v0

    invoke-virtual {v0}, Lorg/json/JSONException;->printStackTrace()V

    goto :goto_0
.end method

.method public getOrderAmount()F
    .locals 1

    iget v0, p0, Lcn/uc/gamesdk/info/OrderInfo;->c:F

    return v0
.end method

.method public getOrderId()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/info/OrderInfo;->b:Ljava/lang/String;

    return-object v0
.end method

.method public getPayType()I
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    iget v0, p0, Lcn/uc/gamesdk/info/OrderInfo;->e:I

    return v0
.end method

.method public getPayTypeName()Ljava/lang/String;
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    iget-object v0, p0, Lcn/uc/gamesdk/info/OrderInfo;->d:Ljava/lang/String;

    return-object v0
.end method

.method public getPayWay()I
    .locals 1

    iget v0, p0, Lcn/uc/gamesdk/info/OrderInfo;->e:I

    return v0
.end method

.method public getPayWayName()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/info/OrderInfo;->d:Ljava/lang/String;

    return-object v0
.end method

.method public setAmount(F)V
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    iput p1, p0, Lcn/uc/gamesdk/info/OrderInfo;->c:F

    return-void
.end method

.method public setOrderAmount(F)V
    .locals 0

    iput p1, p0, Lcn/uc/gamesdk/info/OrderInfo;->c:F

    return-void
.end method

.method public setOrderId(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/info/OrderInfo;->b:Ljava/lang/String;

    return-void
.end method

.method public setPayType(I)V
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    iput p1, p0, Lcn/uc/gamesdk/info/OrderInfo;->e:I

    return-void
.end method

.method public setPayTypeName(Ljava/lang/String;)V
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    iput-object p1, p0, Lcn/uc/gamesdk/info/OrderInfo;->d:Ljava/lang/String;

    return-void
.end method

.method public setPayWay(I)V
    .locals 0

    iput p1, p0, Lcn/uc/gamesdk/info/OrderInfo;->e:I

    return-void
.end method

.method public setPayWayName(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/info/OrderInfo;->d:Ljava/lang/String;

    return-void
.end method
