.class Lcn/uc/gamesdk/UCGameSDK$1;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcn/uc/gamesdk/UCGameSDK;->initSDK(Landroid/app/Activity;Lcn/uc/gamesdk/UCLogLevel;ZLcn/uc/gamesdk/info/GameParamInfo;Lcn/uc/gamesdk/UCCallbackListener;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic a:Landroid/app/Activity;

.field final synthetic b:Lcn/uc/gamesdk/info/GameParamInfo;

.field final synthetic c:Z

.field final synthetic d:Lcn/uc/gamesdk/UCLogLevel;

.field final synthetic e:Lcn/uc/gamesdk/UCCallbackListener;

.field final synthetic f:Landroid/app/ProgressDialog;

.field final synthetic g:Lcn/uc/gamesdk/UCGameSDK;


# direct methods
.method constructor <init>(Lcn/uc/gamesdk/UCGameSDK;Landroid/app/Activity;Lcn/uc/gamesdk/info/GameParamInfo;ZLcn/uc/gamesdk/UCLogLevel;Lcn/uc/gamesdk/UCCallbackListener;Landroid/app/ProgressDialog;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/UCGameSDK$1;->g:Lcn/uc/gamesdk/UCGameSDK;

    iput-object p2, p0, Lcn/uc/gamesdk/UCGameSDK$1;->a:Landroid/app/Activity;

    iput-object p3, p0, Lcn/uc/gamesdk/UCGameSDK$1;->b:Lcn/uc/gamesdk/info/GameParamInfo;

    iput-boolean p4, p0, Lcn/uc/gamesdk/UCGameSDK$1;->c:Z

    iput-object p5, p0, Lcn/uc/gamesdk/UCGameSDK$1;->d:Lcn/uc/gamesdk/UCLogLevel;

    iput-object p6, p0, Lcn/uc/gamesdk/UCGameSDK$1;->e:Lcn/uc/gamesdk/UCCallbackListener;

    iput-object p7, p0, Lcn/uc/gamesdk/UCGameSDK$1;->f:Landroid/app/ProgressDialog;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    invoke-static {}, Lcn/uc/gamesdk/b/a;->a()Lcn/uc/gamesdk/b/a;

    move-result-object v0

    invoke-virtual {v0}, Lcn/uc/gamesdk/b/a;->c()Ljava/util/Map;

    move-result-object v0

    if-eqz v0, :cond_1

    invoke-static {}, Lcn/uc/gamesdk/a;->a()Lcn/uc/gamesdk/a;

    move-result-object v0

    iget-object v1, p0, Lcn/uc/gamesdk/UCGameSDK$1;->a:Landroid/app/Activity;

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/a;->a(Landroid/content/Context;)Lcn/uc/gamesdk/a;

    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    iget-object v1, p0, Lcn/uc/gamesdk/UCGameSDK$1;->b:Lcn/uc/gamesdk/info/GameParamInfo;

    invoke-static {}, Lcn/uc/gamesdk/UCGameSDK;->a()Landroid/os/Bundle;

    move-result-object v2

    invoke-virtual {v1, v2}, Lcn/uc/gamesdk/info/GameParamInfo;->setDebugConfig(Landroid/os/Bundle;)V

    const-string v1, "gameParam"

    iget-object v2, p0, Lcn/uc/gamesdk/UCGameSDK$1;->b:Lcn/uc/gamesdk/info/GameParamInfo;

    invoke-virtual {v2}, Lcn/uc/gamesdk/info/GameParamInfo;->toBundleObject()Landroid/os/Bundle;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBundle(Ljava/lang/String;Landroid/os/Bundle;)V

    const-string v1, "debugMode"

    iget-boolean v2, p0, Lcn/uc/gamesdk/UCGameSDK$1;->c:Z

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    const-string v1, "orientation"

    invoke-static {}, Lcn/uc/gamesdk/UCGameSDK;->b()Lcn/uc/gamesdk/UCOrientation;

    move-result-object v2

    invoke-virtual {v2}, Lcn/uc/gamesdk/UCOrientation;->ordinal()I

    move-result v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    const-string v1, "loginUISwitchByCp"

    iget-object v2, p0, Lcn/uc/gamesdk/UCGameSDK$1;->g:Lcn/uc/gamesdk/UCGameSDK;

    invoke-static {v2}, Lcn/uc/gamesdk/UCGameSDK;->a(Lcn/uc/gamesdk/UCGameSDK;)Lcn/uc/gamesdk/UCLoginFaceType;

    move-result-object v2

    invoke-virtual {v2}, Lcn/uc/gamesdk/UCLoginFaceType;->ordinal()I

    move-result v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    iget-object v1, p0, Lcn/uc/gamesdk/UCGameSDK$1;->g:Lcn/uc/gamesdk/UCGameSDK;

    invoke-static {v1}, Lcn/uc/gamesdk/UCGameSDK;->b(Lcn/uc/gamesdk/UCGameSDK;)Lcn/uc/gamesdk/UCLogLevel;

    move-result-object v1

    if-nez v1, :cond_0

    const-string v1, "logLevel"

    iget-object v2, p0, Lcn/uc/gamesdk/UCGameSDK$1;->d:Lcn/uc/gamesdk/UCLogLevel;

    invoke-virtual {v2}, Lcn/uc/gamesdk/UCLogLevel;->ordinal()I

    move-result v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    :goto_0
    sget-object v1, Lcn/uc/gamesdk/a/d;->a:Landroid/os/Handler;

    new-instance v2, Lcn/uc/gamesdk/UCGameSDK$1$1;

    invoke-direct {v2, p0, v0}, Lcn/uc/gamesdk/UCGameSDK$1$1;-><init>(Lcn/uc/gamesdk/UCGameSDK$1;Landroid/os/Bundle;)V

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    :goto_1
    return-void

    :cond_0
    const-string v1, "logLevel"

    iget-object v2, p0, Lcn/uc/gamesdk/UCGameSDK$1;->g:Lcn/uc/gamesdk/UCGameSDK;

    invoke-static {v2}, Lcn/uc/gamesdk/UCGameSDK;->b(Lcn/uc/gamesdk/UCGameSDK;)Lcn/uc/gamesdk/UCLogLevel;

    move-result-object v2

    invoke-virtual {v2}, Lcn/uc/gamesdk/UCLogLevel;->ordinal()I

    move-result v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    goto :goto_0

    :cond_1
    sget-object v0, Lcn/uc/gamesdk/a/d;->a:Landroid/os/Handler;

    new-instance v1, Lcn/uc/gamesdk/UCGameSDK$1$2;

    invoke-direct {v1, p0}, Lcn/uc/gamesdk/UCGameSDK$1$2;-><init>(Lcn/uc/gamesdk/UCGameSDK$1;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    goto :goto_1
.end method
