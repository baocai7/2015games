.class Lorg/cocos2dx/lua/AppActivity$1;
.super Ljava/lang/Object;
.source "AppActivity.java"

# interfaces
.implements Lcn/uc/gamesdk/UCCallbackListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lorg/cocos2dx/lua/AppActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Lcn/uc/gamesdk/UCCallbackListener",
        "<",
        "Lcn/uc/gamesdk/info/OrderInfo;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .prologue
    .line 536
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 1
    return-void
.end method


# virtual methods
.method public callback(ILcn/uc/gamesdk/info/OrderInfo;)V
    .locals 7
    .param p1, "statudcode"    # I
    .param p2, "orderInfo"    # Lcn/uc/gamesdk/info/OrderInfo;

    .prologue
    .line 544
    if-nez p1, :cond_0

    .line 547
    if-eqz p2, :cond_0

    .line 549
    const/4 v4, 0x1

    sput v4, Lorg/cocos2dx/lua/AppActivity;->mIsPaymentOK:I

    .line 551
    invoke-virtual {p2}, Lcn/uc/gamesdk/info/OrderInfo;->getOrderId()Ljava/lang/String;

    move-result-object v1

    .line 552
    .local v1, "ordereId":Ljava/lang/String;
    invoke-virtual {p2}, Lcn/uc/gamesdk/info/OrderInfo;->getOrderAmount()F

    move-result v0

    .line 553
    .local v0, "orderAmount":F
    invoke-virtual {p2}, Lcn/uc/gamesdk/info/OrderInfo;->getPayWay()I

    move-result v2

    .line 554
    .local v2, "payWay":I
    invoke-virtual {p2}, Lcn/uc/gamesdk/info/OrderInfo;->getPayWayName()Ljava/lang/String;

    move-result-object v3

    .line 555
    .local v3, "payWayName":Ljava/lang/String;
    sget-object v4, Ljava/lang/System;->out:Ljava/io/PrintStream;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-static {v1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v6

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v6, ","

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, ","

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    .line 556
    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, ","

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    .line 555
    invoke-virtual {v4, v5}, Ljava/io/PrintStream;->print(Ljava/lang/String;)V

    .line 562
    .end local v0    # "orderAmount":F
    .end local v1    # "ordereId":Ljava/lang/String;
    .end local v2    # "payWay":I
    .end local v3    # "payWayName":Ljava/lang/String;
    :cond_0
    return-void
.end method

.method public bridge synthetic callback(ILjava/lang/Object;)V
    .locals 0

    .prologue
    .line 1
    check-cast p2, Lcn/uc/gamesdk/info/OrderInfo;

    invoke-virtual {p0, p1, p2}, Lorg/cocos2dx/lua/AppActivity$1;->callback(ILcn/uc/gamesdk/info/OrderInfo;)V

    return-void
.end method
