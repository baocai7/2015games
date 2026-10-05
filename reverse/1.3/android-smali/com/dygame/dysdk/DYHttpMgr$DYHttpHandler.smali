.class public Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;
.super Landroid/os/Handler;
.source "DYHttpMgr.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/dygame/dysdk/DYHttpMgr;
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
    .line 27
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    .line 28
    const-string v0, ""

    iput-object v0, p0, Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;->mRespData:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public getRespData()Ljava/lang/String;
    .locals 1

    .prologue
    .line 33
    iget-object v0, p0, Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;->mRespData:Ljava/lang/String;

    return-object v0
.end method

.method public setRespData(Ljava/lang/String;)V
    .locals 0
    .param p1, "data"    # Ljava/lang/String;

    .prologue
    .line 30
    iput-object p1, p0, Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;->mRespData:Ljava/lang/String;

    .line 31
    return-void
.end method
