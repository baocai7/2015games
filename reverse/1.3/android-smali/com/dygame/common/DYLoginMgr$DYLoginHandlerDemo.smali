.class Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;
.super Ljava/lang/Object;
.source "DYLoginMgr.java"

# interfaces
.implements Lcom/dygame/common/DYLoginMgr$DYLoginHandler;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/dygame/common/DYLoginMgr;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "DYLoginHandlerDemo"
.end annotation


# static fields
.field private static mInstance:Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;


# instance fields
.field private mListener:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 77
    const/4 v0, 0x0

    sput-object v0, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;->mInstance:Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;

    return-void
.end method

.method private constructor <init>()V
    .locals 1

    .prologue
    .line 76
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 85
    const/4 v0, -0x1

    iput v0, p0, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;->mListener:I

    return-void
.end method

.method public static getInstance()Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;
    .locals 1

    .prologue
    .line 79
    sget-object v0, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;->mInstance:Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;

    if-nez v0, :cond_0

    .line 80
    new-instance v0, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;

    invoke-direct {v0}, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;-><init>()V

    sput-object v0, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;->mInstance:Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;

    .line 82
    :cond_0
    sget-object v0, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;->mInstance:Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;

    return-object v0
.end method


# virtual methods
.method public doEnter(Ljava/lang/String;)V
    .locals 0
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 128
    return-void
.end method

.method public doInit(Ljava/lang/String;)V
    .locals 1
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 101
    iget v0, p0, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;->mListener:I

    invoke-static {p1, v0}, Lcom/dygame/common/DYLoginMgr;->onInitSucc(Ljava/lang/String;I)V

    .line 102
    const/4 v0, -0x1

    iput v0, p0, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;->mListener:I

    .line 103
    return-void
.end method

.method public doLogin(Ljava/lang/String;)V
    .locals 1
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 118
    iget v0, p0, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;->mListener:I

    invoke-static {p1, v0}, Lcom/dygame/common/DYLoginMgr;->onLoginSucc(Ljava/lang/String;I)V

    .line 119
    const/4 v0, -0x1

    iput v0, p0, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;->mListener:I

    .line 120
    return-void
.end method

.method public doLogout(Ljava/lang/String;)V
    .locals 0
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 136
    return-void
.end method

.method public doUpdateEvent(Ljava/lang/String;)V
    .locals 0
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 146
    return-void
.end method

.method public enter(Ljava/lang/String;I)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 124
    sget-object v0, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;->mInstance:Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;

    const-string v1, "doEnter"

    invoke-static {v0, v1, p1}, Lcom/dygame/common/DYThreadHelper;->runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    .line 125
    return-void
.end method

.method public init(Ljava/lang/String;I)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 89
    iget v0, p0, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;->mListener:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    .line 90
    invoke-static {p1, p2}, Lcom/dygame/common/DYLoginMgr;->onInitFail(Ljava/lang/String;I)V

    .line 96
    :goto_0
    return-void

    .line 94
    :cond_0
    iput p2, p0, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;->mListener:I

    .line 95
    sget-object v0, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;->mInstance:Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;

    const-string v1, "doInit"

    invoke-static {v0, v1, p1}, Lcom/dygame/common/DYThreadHelper;->runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0
.end method

.method public login(Ljava/lang/String;I)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 108
    iget v0, p0, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;->mListener:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    .line 109
    invoke-static {p1, p2}, Lcom/dygame/common/DYLoginMgr;->onLoginFail(Ljava/lang/String;I)V

    .line 115
    :goto_0
    return-void

    .line 113
    :cond_0
    iput p2, p0, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;->mListener:I

    .line 114
    sget-object v0, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;->mInstance:Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;

    const-string v1, "doLogin"

    invoke-static {v0, v1, p1}, Lcom/dygame/common/DYThreadHelper;->runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0
.end method

.method public logout(Ljava/lang/String;I)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 132
    sget-object v0, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;->mInstance:Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;

    const-string v1, "doLogout"

    invoke-static {v0, v1, p1}, Lcom/dygame/common/DYThreadHelper;->runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    .line 133
    return-void
.end method

.method public updateEvent(Ljava/lang/String;I)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 142
    sget-object v0, Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;->mInstance:Lcom/dygame/common/DYLoginMgr$DYLoginHandlerDemo;

    const-string v1, "doUpdateEvent"

    invoke-static {v0, v1, p1}, Lcom/dygame/common/DYThreadHelper;->runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    .line 143
    return-void
.end method
