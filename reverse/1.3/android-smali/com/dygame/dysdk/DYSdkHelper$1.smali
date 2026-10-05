.class final Lcom/dygame/dysdk/DYSdkHelper$1;
.super Ljava/lang/Object;
.source "DYSdkHelper.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/dygame/dysdk/DYSdkHelper;->revokeLoginResult(ZLcom/dygame/dysdk/DYSdkLoginResult;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic val$bSucc:Z

.field final synthetic val$result:Lcom/dygame/dysdk/DYSdkLoginResult;


# direct methods
.method constructor <init>(ZLcom/dygame/dysdk/DYSdkLoginResult;)V
    .locals 0

    .prologue
    .line 66
    iput-boolean p1, p0, Lcom/dygame/dysdk/DYSdkHelper$1;->val$bSucc:Z

    iput-object p2, p0, Lcom/dygame/dysdk/DYSdkHelper$1;->val$result:Lcom/dygame/dysdk/DYSdkLoginResult;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .prologue
    .line 69
    iget-boolean v0, p0, Lcom/dygame/dysdk/DYSdkHelper$1;->val$bSucc:Z

    if-eqz v0, :cond_0

    .line 70
    sget-object v0, Lcom/dygame/dysdk/DYSdkHelper;->mLoginListener:Lcom/dygame/dysdk/DYSdkLoginListener;

    iget-object v1, p0, Lcom/dygame/dysdk/DYSdkHelper$1;->val$result:Lcom/dygame/dysdk/DYSdkLoginResult;

    invoke-interface {v0, v1}, Lcom/dygame/dysdk/DYSdkLoginListener;->onLoginSuccess(Lcom/dygame/dysdk/DYSdkLoginResult;)V

    .line 74
    :goto_0
    return-void

    .line 72
    :cond_0
    sget-object v0, Lcom/dygame/dysdk/DYSdkHelper;->mLoginListener:Lcom/dygame/dysdk/DYSdkLoginListener;

    invoke-interface {v0}, Lcom/dygame/dysdk/DYSdkLoginListener;->onLoginFailed()V

    goto :goto_0
.end method
