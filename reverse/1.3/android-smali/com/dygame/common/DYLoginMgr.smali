.class public Lcom/dygame/common/DYLoginMgr;
.super Ljava/lang/Object;
.source "DYLoginMgr.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;,
        Lcom/dygame/common/DYLoginMgr$DYLoginHandler;
    }
.end annotation


# static fields
.field private static mLoginHandler:Lcom/dygame/common/DYLoginMgr$DYLoginHandler;

.field private static mLogoutListener:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 8
    const/4 v0, -0x1

    sput v0, Lcom/dygame/common/DYLoginMgr;->mLogoutListener:I

    .line 70
    invoke-static {}, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->getInstance()Lcom/dygame/open/dayu/DYLoginHandlerDayu;

    move-result-object v0

    sput-object v0, Lcom/dygame/common/DYLoginMgr;->mLoginHandler:Lcom/dygame/common/DYLoginMgr$DYLoginHandler;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 75
    return-void
.end method

.method public static enter(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 22
    sget-object v0, Lcom/dygame/common/DYLoginMgr;->mLoginHandler:Lcom/dygame/common/DYLoginMgr$DYLoginHandler;

    if-eqz v0, :cond_0

    .line 23
    sget-object v0, Lcom/dygame/common/DYLoginMgr;->mLoginHandler:Lcom/dygame/common/DYLoginMgr$DYLoginHandler;

    invoke-interface {v0, p0, p1}, Lcom/dygame/common/DYLoginMgr$DYLoginHandler;->enter(Ljava/lang/String;I)V

    .line 25
    :cond_0
    return-void
.end method

.method public static init(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 11
    sget-object v0, Lcom/dygame/common/DYLoginMgr;->mLoginHandler:Lcom/dygame/common/DYLoginMgr$DYLoginHandler;

    if-eqz v0, :cond_0

    .line 12
    sget-object v0, Lcom/dygame/common/DYLoginMgr;->mLoginHandler:Lcom/dygame/common/DYLoginMgr$DYLoginHandler;

    invoke-interface {v0, p0, p1}, Lcom/dygame/common/DYLoginMgr$DYLoginHandler;->init(Ljava/lang/String;I)V

    .line 14
    :cond_0
    return-void
.end method

.method public static login(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 17
    sget-object v0, Lcom/dygame/common/DYLoginMgr;->mLoginHandler:Lcom/dygame/common/DYLoginMgr$DYLoginHandler;

    if-eqz v0, :cond_0

    .line 18
    sget-object v0, Lcom/dygame/common/DYLoginMgr;->mLoginHandler:Lcom/dygame/common/DYLoginMgr$DYLoginHandler;

    invoke-interface {v0, p0, p1}, Lcom/dygame/common/DYLoginMgr$DYLoginHandler;->login(Ljava/lang/String;I)V

    .line 20
    :cond_0
    return-void
.end method

.method public static logout(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 30
    sget-object v0, Lcom/dygame/common/DYLoginMgr;->mLoginHandler:Lcom/dygame/common/DYLoginMgr$DYLoginHandler;

    if-eqz v0, :cond_0

    .line 31
    sget-object v0, Lcom/dygame/common/DYLoginMgr;->mLoginHandler:Lcom/dygame/common/DYLoginMgr$DYLoginHandler;

    invoke-interface {v0, p0, p1}, Lcom/dygame/common/DYLoginMgr$DYLoginHandler;->logout(Ljava/lang/String;I)V

    .line 33
    :cond_0
    return-void
.end method

.method public static onInitFail(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 45
    const-string v0, "EVENT_INIT_FAIL"

    invoke-static {v0, p0, p1}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 46
    return-void
.end method

.method public static onInitSucc(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 42
    const-string v0, "EVENT_INIT_SUCC"

    invoke-static {v0, p0, p1}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 43
    return-void
.end method

.method public static onLoginFail(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 51
    const-string v0, "EVENT_LOGIN_FAIL"

    invoke-static {v0, p0, p1}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 52
    return-void
.end method

.method public static onLoginSucc(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 48
    const-string v0, "EVENT_LOGIN_SUCC"

    invoke-static {v0, p0, p1}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 49
    return-void
.end method

.method public static onLogoutFail(Ljava/lang/String;I)V
    .locals 2
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 57
    const-string v0, "EVENT_LOGOUT_FAIL"

    sget v1, Lcom/dygame/common/DYLoginMgr;->mLogoutListener:I

    invoke-static {v0, p0, v1}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 58
    return-void
.end method

.method public static onLogoutSucc(Ljava/lang/String;I)V
    .locals 2
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 54
    const-string v0, "EVENT_LOGOUT_SUCC"

    sget v1, Lcom/dygame/common/DYLoginMgr;->mLogoutListener:I

    invoke-static {v0, p0, v1}, Lcom/dygame/common/DYCommon;->notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V

    .line 55
    return-void
.end method

.method public static regLogout(Ljava/lang/String;I)V
    .locals 0
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 27
    sput p1, Lcom/dygame/common/DYLoginMgr;->mLogoutListener:I

    .line 28
    return-void
.end method

.method public static updateEvent(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 35
    sget-object v0, Lcom/dygame/common/DYLoginMgr;->mLoginHandler:Lcom/dygame/common/DYLoginMgr$DYLoginHandler;

    if-eqz v0, :cond_0

    .line 36
    sget-object v0, Lcom/dygame/common/DYLoginMgr;->mLoginHandler:Lcom/dygame/common/DYLoginMgr$DYLoginHandler;

    invoke-interface {v0, p0, p1}, Lcom/dygame/common/DYLoginMgr$DYLoginHandler;->updateEvent(Ljava/lang/String;I)V

    .line 38
    :cond_0
    return-void
.end method
