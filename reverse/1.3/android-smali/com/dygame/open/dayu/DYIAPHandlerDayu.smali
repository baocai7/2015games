.class public Lcom/dygame/open/dayu/DYIAPHandlerDayu;
.super Ljava/lang/Object;
.source "DYIAPHandlerDayu.java"

# interfaces
.implements Lcom/dygame/common/DYIAPMgr$DYIAPHandler;


# static fields
.field private static mInstance:Lcom/dygame/open/dayu/DYIAPHandlerDayu;


# instance fields
.field private mListener:I

.field private mPayParam:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 12
    const/4 v0, 0x0

    sput-object v0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->mInstance:Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .prologue
    .line 11
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 20
    const/4 v0, -0x1

    iput v0, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->mListener:I

    .line 21
    const-string v0, ""

    iput-object v0, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->mPayParam:Ljava/lang/String;

    return-void
.end method

.method static synthetic access$000(Lcom/dygame/open/dayu/DYIAPHandlerDayu;)Ljava/lang/String;
    .locals 1
    .param p0, "x0"    # Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    .prologue
    .line 11
    iget-object v0, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->mPayParam:Ljava/lang/String;

    return-object v0
.end method

.method static synthetic access$100(Lcom/dygame/open/dayu/DYIAPHandlerDayu;)I
    .locals 1
    .param p0, "x0"    # Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    .prologue
    .line 11
    iget v0, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->mListener:I

    return v0
.end method

.method static synthetic access$102(Lcom/dygame/open/dayu/DYIAPHandlerDayu;I)I
    .locals 0
    .param p0, "x0"    # Lcom/dygame/open/dayu/DYIAPHandlerDayu;
    .param p1, "x1"    # I

    .prologue
    .line 11
    iput p1, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->mListener:I

    return p1
.end method

.method public static getInstance()Lcom/dygame/open/dayu/DYIAPHandlerDayu;
    .locals 1

    .prologue
    .line 14
    sget-object v0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->mInstance:Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    if-nez v0, :cond_0

    .line 15
    new-instance v0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    invoke-direct {v0}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;-><init>()V

    sput-object v0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->mInstance:Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    .line 17
    :cond_0
    sget-object v0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->mInstance:Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    return-object v0
.end method


# virtual methods
.method public afterPay(Z)V
    .locals 4
    .param p1, "bSucc"    # Z
    .annotation build Landroid/annotation/SuppressLint;
        value = {
            "HandlerLeak"
        }
    .end annotation

    .prologue
    .line 74
    iget v1, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->mListener:I

    const/4 v2, -0x1

    if-ne v1, v2, :cond_0

    .line 91
    :goto_0
    return-void

    .line 78
    :cond_0
    new-instance v0, Lcom/dygame/open/dayu/DYIAPHandlerDayu$1;

    invoke-direct {v0, p0, p1}, Lcom/dygame/open/dayu/DYIAPHandlerDayu$1;-><init>(Lcom/dygame/open/dayu/DYIAPHandlerDayu;Z)V

    .line 90
    .local v0, "h":Landroid/os/Handler;
    const/4 v1, 0x0

    const-wide/16 v2, 0xc8

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    goto :goto_0
.end method

.method public doInit(Ljava/lang/String;)V
    .locals 1
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 37
    invoke-static {}, Lcom/dygame/open/dayu/DYAlipayHelper;->getInstance()Lcom/dygame/open/dayu/DYAlipayHelper;

    .line 38
    invoke-static {}, Lcom/dygame/open/dayu/DYWxpayHelper;->getInstance()Lcom/dygame/open/dayu/DYWxpayHelper;

    .line 40
    iget v0, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->mListener:I

    invoke-static {p1, v0}, Lcom/dygame/common/DYIAPMgr;->onInitSucc(Ljava/lang/String;I)V

    .line 41
    const/4 v0, -0x1

    iput v0, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->mListener:I

    .line 42
    return-void
.end method

.method public doPay(Ljava/lang/String;)V
    .locals 0
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 61
    invoke-static {p1}, Lcom/dygame/open/dayu/DYPayMainDlg;->tryPay(Ljava/lang/String;)V

    .line 62
    return-void
.end method

.method public init(Ljava/lang/String;I)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 25
    iget v0, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->mListener:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    .line 26
    invoke-static {p1, p2}, Lcom/dygame/common/DYIAPMgr;->onInitFail(Ljava/lang/String;I)V

    .line 32
    :goto_0
    return-void

    .line 30
    :cond_0
    iput p2, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->mListener:I

    .line 31
    sget-object v0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->mInstance:Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    const-string v1, "doInit"

    invoke-static {v0, v1, p1}, Lcom/dygame/common/DYThreadHelper;->runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0
.end method

.method public pay(Ljava/lang/String;I)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 46
    iget v0, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->mListener:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    .line 47
    invoke-static {p1, p2}, Lcom/dygame/common/DYIAPMgr;->onPayFail(Ljava/lang/String;I)V

    .line 54
    :goto_0
    return-void

    .line 51
    :cond_0
    iput p2, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->mListener:I

    .line 52
    iput-object p1, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->mPayParam:Ljava/lang/String;

    .line 53
    sget-object v0, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->mInstance:Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    const-string v1, "doPay"

    invoke-static {v0, v1, p1}, Lcom/dygame/common/DYThreadHelper;->runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0
.end method

.method public query(Ljava/lang/String;I)V
    .locals 0
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 66
    return-void
.end method

.method public refund(Ljava/lang/String;I)V
    .locals 0
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 69
    return-void
.end method
