.class public Lcom/dygame/common/DYHttpMgr$DYHttpHandler;
.super Landroid/os/Handler;
.source "DYHttpMgr.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/dygame/common/DYHttpMgr;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "DYHttpHandler"
.end annotation


# instance fields
.field private mRespData:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 1

    .prologue
    .line 29
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    .line 30
    const-string v0, ""

    iput-object v0, p0, Lcom/dygame/common/DYHttpMgr$DYHttpHandler;->mRespData:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public getRespData()Ljava/lang/String;
    .locals 1

    .prologue
    .line 35
    iget-object v0, p0, Lcom/dygame/common/DYHttpMgr$DYHttpHandler;->mRespData:Ljava/lang/String;

    return-object v0
.end method

.method public setRespData(Ljava/lang/String;)V
    .locals 0
    .param p1, "data"    # Ljava/lang/String;

    .prologue
    .line 32
    iput-object p1, p0, Lcom/dygame/common/DYHttpMgr$DYHttpHandler;->mRespData:Ljava/lang/String;

    .line 33
    return-void
.end method
