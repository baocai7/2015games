.class public Lcom/dygame/common/DYIAPMgr;
.super Ljava/lang/Object;
.source "DYIAPMgr.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;,
        Lcom/dygame/common/DYIAPMgr$DYIAPHandler;
    }
.end annotation


# static fields
.field private static mIapHandler:Lcom/dygame/common/DYIAPMgr$DYIAPHandler;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 67
    invoke-static {}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->getInstance()Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    move-result-object v0

    sput-object v0, Lcom/dygame/common/DYIAPMgr;->mIapHandler:Lcom/dygame/common/DYIAPMgr$DYIAPHandler;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 6
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 72
    return-void
.end method

.method public static init(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 10
    sget-object v0, Lcom/dygame/common/DYIAPMgr;->mIapHandler:Lcom/dygame/common/DYIAPMgr$DYIAPHandler;

    if-eqz v0, :cond_0

    .line 11
    sget-object v0, Lcom/dygame/common/DYIAPMgr;->mIapHandler:Lcom/dygame/common/DYIAPMgr$DYIAPHandler;

    invoke-interface {v0, p0, p1}, Lcom/dygame/common/DYIAPMgr$DYIAPHandler;->init(Ljava/lang/String;I)V

    .line 13
    :cond_0
    return-void
.end method

.method public static onInitFail(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 38
    const-string v0, "EVENT_INIT_FAIL"

    invoke-static {v0, p0, p1}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 39
    return-void
.end method

.method public static onInitSucc(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 35
    const-string v0, "EVENT_INIT_SUCC"

    invoke-static {v0, p0, p1}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 36
    return-void
.end method

.method public static onPayFail(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 44
    const-string v0, "EVENT_PAY_FAIL"

    invoke-static {v0, p0, p1}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 45
    return-void
.end method

.method public static onPaySucc(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 41
    const-string v0, "EVENT_PAY_SUCC"

    invoke-static {v0, p0, p1}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 42
    return-void
.end method

.method public static onQueryFail(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 50
    const-string v0, "EVENT_QUERY_FAIL"

    invoke-static {v0, p0, p1}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 51
    return-void
.end method

.method public static onQuerySucc(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 47
    const-string v0, "EVENT_QUERY_SUCC"

    invoke-static {v0, p0, p1}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 48
    return-void
.end method

.method public static onRefundFail(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 56
    const-string v0, "EVENT_REFUND_FAIL"

    invoke-static {v0, p0, p1}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 57
    return-void
.end method

.method public static onRefundSucc(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 53
    const-string v0, "EVENT_REFUND_SUCC"

    invoke-static {v0, p0, p1}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 54
    return-void
.end method

.method public static pay(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 16
    sget-object v0, Lcom/dygame/common/DYIAPMgr;->mIapHandler:Lcom/dygame/common/DYIAPMgr$DYIAPHandler;

    if-eqz v0, :cond_0

    .line 17
    sget-object v0, Lcom/dygame/common/DYIAPMgr;->mIapHandler:Lcom/dygame/common/DYIAPMgr$DYIAPHandler;

    invoke-interface {v0, p0, p1}, Lcom/dygame/common/DYIAPMgr$DYIAPHandler;->pay(Ljava/lang/String;I)V

    .line 19
    :cond_0
    return-void
.end method

.method public static query(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 22
    sget-object v0, Lcom/dygame/common/DYIAPMgr;->mIapHandler:Lcom/dygame/common/DYIAPMgr$DYIAPHandler;

    if-eqz v0, :cond_0

    .line 23
    sget-object v0, Lcom/dygame/common/DYIAPMgr;->mIapHandler:Lcom/dygame/common/DYIAPMgr$DYIAPHandler;

    invoke-interface {v0, p0, p1}, Lcom/dygame/common/DYIAPMgr$DYIAPHandler;->query(Ljava/lang/String;I)V

    .line 25
    :cond_0
    return-void
.end method

.method public static refund(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 28
    sget-object v0, Lcom/dygame/common/DYIAPMgr;->mIapHandler:Lcom/dygame/common/DYIAPMgr$DYIAPHandler;

    if-eqz v0, :cond_0

    .line 29
    sget-object v0, Lcom/dygame/common/DYIAPMgr;->mIapHandler:Lcom/dygame/common/DYIAPMgr$DYIAPHandler;

    invoke-interface {v0, p0, p1}, Lcom/dygame/common/DYIAPMgr$DYIAPHandler;->refund(Ljava/lang/String;I)V

    .line 31
    :cond_0
    return-void
.end method
