.class public Lcom/dygame/open/dayu/DYLoginHandlerDayu;
.super Ljava/lang/Object;
.source "DYLoginHandlerDayu.java"

# interfaces
.implements Lcom/dygame/common/DYLoginMgr$DYLoginHandler;


# static fields
.field private static mInstance:Lcom/dygame/open/dayu/DYLoginHandlerDayu;


# instance fields
.field private mListener:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 15
    const/4 v0, 0x0

    sput-object v0, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->mInstance:Lcom/dygame/open/dayu/DYLoginHandlerDayu;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .prologue
    .line 14
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 23
    const/4 v0, -0x1

    iput v0, p0, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->mListener:I

    return-void
.end method

.method static synthetic access$000(Lcom/dygame/open/dayu/DYLoginHandlerDayu;)I
    .locals 1
    .param p0, "x0"    # Lcom/dygame/open/dayu/DYLoginHandlerDayu;

    .prologue
    .line 14
    iget v0, p0, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->mListener:I

    return v0
.end method

.method static synthetic access$002(Lcom/dygame/open/dayu/DYLoginHandlerDayu;I)I
    .locals 0
    .param p0, "x0"    # Lcom/dygame/open/dayu/DYLoginHandlerDayu;
    .param p1, "x1"    # I

    .prologue
    .line 14
    iput p1, p0, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->mListener:I

    return p1
.end method

.method public static getInstance()Lcom/dygame/open/dayu/DYLoginHandlerDayu;
    .locals 1

    .prologue
    .line 17
    sget-object v0, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->mInstance:Lcom/dygame/open/dayu/DYLoginHandlerDayu;

    if-nez v0, :cond_0

    .line 18
    new-instance v0, Lcom/dygame/open/dayu/DYLoginHandlerDayu;

    invoke-direct {v0}, Lcom/dygame/open/dayu/DYLoginHandlerDayu;-><init>()V

    sput-object v0, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->mInstance:Lcom/dygame/open/dayu/DYLoginHandlerDayu;

    .line 20
    :cond_0
    sget-object v0, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->mInstance:Lcom/dygame/open/dayu/DYLoginHandlerDayu;

    return-object v0
.end method

.method private sdkInit(Ljava/lang/String;)V
    .locals 1
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 82
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    invoke-static {v0}, Lcom/dygame/dysdk/DYSdkHelper;->init(Landroid/content/Context;)V

    .line 84
    iget v0, p0, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->mListener:I

    invoke-static {p1, v0}, Lcom/dygame/common/DYLoginMgr;->onInitSucc(Ljava/lang/String;I)V

    .line 85
    const/4 v0, -0x1

    iput v0, p0, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->mListener:I

    .line 86
    return-void
.end method

.method private sdkLogin(Ljava/lang/String;)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 89
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    new-instance v1, Lcom/dygame/open/dayu/DYLoginHandlerDayu$1;

    invoke-direct {v1, p0}, Lcom/dygame/open/dayu/DYLoginHandlerDayu$1;-><init>(Lcom/dygame/open/dayu/DYLoginHandlerDayu;)V

    invoke-static {v0, v1}, Lcom/dygame/dysdk/DYSdkHelper;->login(Landroid/app/Activity;Lcom/dygame/dysdk/DYSdkLoginListener;)V

    .line 120
    return-void
.end method

.method private sdkLogout()V
    .locals 2

    .prologue
    .line 123
    const-string v0, ""

    const/4 v1, -0x1

    invoke-static {v0, v1}, Lcom/dygame/common/DYLoginMgr;->onLogoutSucc(Ljava/lang/String;I)V

    .line 124
    return-void
.end method


# virtual methods
.method public doInit(Ljava/lang/String;)V
    .locals 0
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 37
    invoke-direct {p0, p1}, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->sdkInit(Ljava/lang/String;)V

    .line 40
    return-void
.end method

.method public doLogin(Ljava/lang/String;)V
    .locals 0
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 55
    invoke-direct {p0, p1}, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->sdkLogin(Ljava/lang/String;)V

    .line 56
    return-void
.end method

.method public doLogout(Ljava/lang/String;)V
    .locals 0
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 76
    invoke-direct {p0}, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->sdkLogout()V

    .line 77
    return-void
.end method

.method public enter(Ljava/lang/String;I)V
    .locals 0
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 63
    return-void
.end method

.method public init(Ljava/lang/String;I)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 26
    iget v0, p0, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->mListener:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    .line 27
    invoke-static {p1, p2}, Lcom/dygame/common/DYLoginMgr;->onInitFail(Ljava/lang/String;I)V

    .line 33
    :goto_0
    return-void

    .line 31
    :cond_0
    iput p2, p0, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->mListener:I

    .line 32
    sget-object v0, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->mInstance:Lcom/dygame/open/dayu/DYLoginHandlerDayu;

    const-string v1, "doInit"

    invoke-static {v0, v1, p1}, Lcom/dygame/common/DYThreadHelper;->runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0
.end method

.method public login(Ljava/lang/String;I)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 44
    iget v0, p0, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->mListener:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    .line 45
    invoke-static {p1, p2}, Lcom/dygame/common/DYLoginMgr;->onLoginFail(Ljava/lang/String;I)V

    .line 51
    :goto_0
    return-void

    .line 49
    :cond_0
    iput p2, p0, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->mListener:I

    .line 50
    sget-object v0, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->mInstance:Lcom/dygame/open/dayu/DYLoginHandlerDayu;

    const-string v1, "doLogin"

    invoke-static {v0, v1, p1}, Lcom/dygame/common/DYThreadHelper;->runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0
.end method

.method public logout(Ljava/lang/String;I)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 73
    sget-object v0, Lcom/dygame/open/dayu/DYLoginHandlerDayu;->mInstance:Lcom/dygame/open/dayu/DYLoginHandlerDayu;

    const-string v1, "doLogout"

    invoke-static {v0, v1, p1}, Lcom/dygame/common/DYThreadHelper;->runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    .line 74
    return-void
.end method

.method public updateEvent(Ljava/lang/String;I)V
    .locals 0
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 69
    return-void
.end method
