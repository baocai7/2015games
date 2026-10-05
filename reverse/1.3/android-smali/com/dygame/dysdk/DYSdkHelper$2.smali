.class final Lcom/dygame/dysdk/DYSdkHelper$2;
.super Ljava/lang/Object;
.source "DYSdkHelper.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/dygame/dysdk/DYSdkHelper;->revokeLogoutResult(Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .prologue
    .line 83
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    .prologue
    .line 86
    sget-object v0, Lcom/dygame/dysdk/DYSdkHelper;->mLoginListener:Lcom/dygame/dysdk/DYSdkLoginListener;

    invoke-interface {v0}, Lcom/dygame/dysdk/DYSdkLoginListener;->onLogout()V

    .line 87
    return-void
.end method
