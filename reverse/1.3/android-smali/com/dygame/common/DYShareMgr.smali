.class public Lcom/dygame/common/DYShareMgr;
.super Ljava/lang/Object;
.source "DYShareMgr.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;,
        Lcom/dygame/common/DYShareMgr$DYShareHandler;
    }
.end annotation


# static fields
.field private static mShareHandler:Lcom/dygame/common/DYShareMgr$DYShareHandler;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 56
    invoke-static {}, Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;->getInstance()Lcom/dygame/common/DYShareMgr$DYShareHandlerDemo;

    move-result-object v0

    sput-object v0, Lcom/dygame/common/DYShareMgr;->mShareHandler:Lcom/dygame/common/DYShareMgr$DYShareHandler;

    .line 55
    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 19
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 58
    return-void
.end method

.method public static init(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 21
    sget-object v0, Lcom/dygame/common/DYShareMgr;->mShareHandler:Lcom/dygame/common/DYShareMgr$DYShareHandler;

    if-eqz v0, :cond_0

    .line 22
    sget-object v0, Lcom/dygame/common/DYShareMgr;->mShareHandler:Lcom/dygame/common/DYShareMgr$DYShareHandler;

    invoke-interface {v0, p0, p1}, Lcom/dygame/common/DYShareMgr$DYShareHandler;->init(Ljava/lang/String;I)V

    .line 24
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
    .line 34
    const-string v0, "EVENT_INIT_SUCC"

    invoke-static {v0, p0, p1}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 35
    return-void
.end method

.method public static onShareFail(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 46
    const-string v0, "EVENT_SHARE_FAIL"

    invoke-static {v0, p0, p1}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 47
    return-void
.end method

.method public static onShareSucc(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 42
    const-string v0, "EVENT_SHARE_SUCC"

    invoke-static {v0, p0, p1}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 43
    return-void
.end method

.method public static share(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 27
    sget-object v0, Lcom/dygame/common/DYShareMgr;->mShareHandler:Lcom/dygame/common/DYShareMgr$DYShareHandler;

    if-eqz v0, :cond_0

    .line 28
    sget-object v0, Lcom/dygame/common/DYShareMgr;->mShareHandler:Lcom/dygame/common/DYShareMgr$DYShareHandler;

    invoke-interface {v0, p0, p1}, Lcom/dygame/common/DYShareMgr$DYShareHandler;->share(Ljava/lang/String;I)V

    .line 30
    :cond_0
    return-void
.end method
