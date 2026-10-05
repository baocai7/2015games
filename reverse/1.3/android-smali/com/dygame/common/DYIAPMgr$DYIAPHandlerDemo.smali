.class Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;
.super Ljava/lang/Object;
.source "DYIAPMgr.java"

# interfaces
.implements Lcom/dygame/common/DYIAPMgr$DYIAPHandler;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/dygame/common/DYIAPMgr;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "DYIAPHandlerDemo"
.end annotation


# static fields
.field private static mInstance:Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;


# instance fields
.field private mListener:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 74
    const/4 v0, 0x0

    sput-object v0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mInstance:Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;

    return-void
.end method

.method private constructor <init>()V
    .locals 1

    .prologue
    .line 73
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 82
    const/4 v0, -0x1

    iput v0, p0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mListener:I

    return-void
.end method

.method public static getInstance()Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;
    .locals 1

    .prologue
    .line 76
    sget-object v0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mInstance:Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;

    if-nez v0, :cond_0

    .line 77
    new-instance v0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;

    invoke-direct {v0}, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;-><init>()V

    sput-object v0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mInstance:Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;

    .line 79
    :cond_0
    sget-object v0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mInstance:Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;

    return-object v0
.end method


# virtual methods
.method public doInit(Ljava/lang/String;)V
    .locals 1
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 98
    iget v0, p0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mListener:I

    invoke-static {p1, v0}, Lcom/dygame/common/DYIAPMgr;->onInitSucc(Ljava/lang/String;I)V

    .line 99
    const/4 v0, -0x1

    iput v0, p0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mListener:I

    .line 100
    return-void
.end method

.method public doPay(Ljava/lang/String;)V
    .locals 1
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 115
    iget v0, p0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mListener:I

    invoke-static {p1, v0}, Lcom/dygame/common/DYIAPMgr;->onPaySucc(Ljava/lang/String;I)V

    .line 116
    const/4 v0, -0x1

    iput v0, p0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mListener:I

    .line 117
    return-void
.end method

.method public doQuery(Ljava/lang/String;)V
    .locals 1
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 132
    iget v0, p0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mListener:I

    invoke-static {p1, v0}, Lcom/dygame/common/DYIAPMgr;->onQuerySucc(Ljava/lang/String;I)V

    .line 133
    const/4 v0, -0x1

    iput v0, p0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mListener:I

    .line 134
    return-void
.end method

.method public doRefund(Ljava/lang/String;)V
    .locals 1
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 148
    iget v0, p0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mListener:I

    invoke-static {p1, v0}, Lcom/dygame/common/DYIAPMgr;->onRefundSucc(Ljava/lang/String;I)V

    .line 149
    const/4 v0, -0x1

    iput v0, p0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mListener:I

    .line 150
    return-void
.end method

.method public init(Ljava/lang/String;I)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 86
    iget v0, p0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mListener:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    .line 87
    invoke-static {p1, p2}, Lcom/dygame/common/DYIAPMgr;->onInitFail(Ljava/lang/String;I)V

    .line 93
    :goto_0
    return-void

    .line 91
    :cond_0
    iput p2, p0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mListener:I

    .line 92
    sget-object v0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mInstance:Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;

    const-string v1, "doInit"

    invoke-static {v0, v1, p1}, Lcom/dygame/common/DYThreadHelper;->runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0
.end method

.method public pay(Ljava/lang/String;I)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 105
    iget v0, p0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mListener:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    .line 106
    invoke-static {p1, p2}, Lcom/dygame/common/DYIAPMgr;->onPayFail(Ljava/lang/String;I)V

    .line 112
    :goto_0
    return-void

    .line 110
    :cond_0
    iput p2, p0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mListener:I

    .line 111
    sget-object v0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mInstance:Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;

    const-string v1, "doPay"

    invoke-static {v0, v1, p1}, Lcom/dygame/common/DYThreadHelper;->runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0
.end method

.method public query(Ljava/lang/String;I)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 122
    iget v0, p0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mListener:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    .line 123
    invoke-static {p1, p2}, Lcom/dygame/common/DYIAPMgr;->onQueryFail(Ljava/lang/String;I)V

    .line 129
    :goto_0
    return-void

    .line 127
    :cond_0
    iput p2, p0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mListener:I

    .line 128
    sget-object v0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mInstance:Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;

    const-string v1, "doQuery"

    invoke-static {v0, v1, p1}, Lcom/dygame/common/DYThreadHelper;->runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0
.end method

.method public refund(Ljava/lang/String;I)V
    .locals 2
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 138
    iget v0, p0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mListener:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    .line 139
    invoke-static {p1, p2}, Lcom/dygame/common/DYIAPMgr;->onRefundFail(Ljava/lang/String;I)V

    .line 145
    :goto_0
    return-void

    .line 143
    :cond_0
    iput p2, p0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mListener:I

    .line 144
    sget-object v0, Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;->mInstance:Lcom/dygame/common/DYIAPMgr$DYIAPHandlerDemo;

    const-string v1, "doRefund"

    invoke-static {v0, v1, p1}, Lcom/dygame/common/DYThreadHelper;->runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0
.end method
