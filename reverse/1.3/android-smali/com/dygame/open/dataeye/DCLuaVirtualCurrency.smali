.class public Lcom/dygame/open/dataeye/DCLuaVirtualCurrency;
.super Ljava/lang/Object;
.source "DCLuaVirtualCurrency.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 5
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static paymentSuccess(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 6
    .param p0, "orderId"    # Ljava/lang/String;
    .param p1, "iapId"    # Ljava/lang/String;
    .param p2, "currencyAmount"    # Ljava/lang/String;
    .param p3, "currencyType"    # Ljava/lang/String;
    .param p4, "paymentType"    # Ljava/lang/String;

    .prologue
    .line 7
    invoke-static {p2}, Ljava/lang/Double;->valueOf(Ljava/lang/String;)Ljava/lang/Double;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Double;->doubleValue()D

    move-result-wide v2

    move-object v0, p0

    move-object v1, p1

    move-object v4, p3

    move-object v5, p4

    invoke-static/range {v0 .. v5}, Lcom/dataeye/DCVirtualCurrency;->paymentSuccess(Ljava/lang/String;Ljava/lang/String;DLjava/lang/String;Ljava/lang/String;)V

    .line 8
    return-void
.end method

.method public static paymentSuccessInLevel(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 7
    .param p0, "orderId"    # Ljava/lang/String;
    .param p1, "iapId"    # Ljava/lang/String;
    .param p2, "currencyAmount"    # Ljava/lang/String;
    .param p3, "currencyType"    # Ljava/lang/String;
    .param p4, "paymentType"    # Ljava/lang/String;
    .param p5, "levelId"    # Ljava/lang/String;

    .prologue
    .line 11
    invoke-static {p2}, Ljava/lang/Double;->valueOf(Ljava/lang/String;)Ljava/lang/Double;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Double;->doubleValue()D

    move-result-wide v2

    move-object v0, p0

    move-object v1, p1

    move-object v4, p3

    move-object v5, p4

    move-object v6, p5

    invoke-static/range {v0 .. v6}, Lcom/dataeye/DCVirtualCurrency;->paymentSuccessInLevel(Ljava/lang/String;Ljava/lang/String;DLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 12
    return-void
.end method
