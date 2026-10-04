.class Lcn/uc/gamesdk/UCGameSDK$1$1;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcn/uc/gamesdk/UCGameSDK$1;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic a:Landroid/os/Bundle;

.field final synthetic b:Lcn/uc/gamesdk/UCGameSDK$1;


# direct methods
.method constructor <init>(Lcn/uc/gamesdk/UCGameSDK$1;Landroid/os/Bundle;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/UCGameSDK$1$1;->b:Lcn/uc/gamesdk/UCGameSDK$1;

    iput-object p2, p0, Lcn/uc/gamesdk/UCGameSDK$1$1;->a:Landroid/os/Bundle;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 7

    const/4 v6, 0x1

    const/16 v5, -0x64

    const-string v0, "UCGameSDK"

    const-string v1, "initSDK"

    const-string v2, "==initSDK=="

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {}, Lcn/uc/gamesdk/b/a;->a()Lcn/uc/gamesdk/b/a;

    move-result-object v0

    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->InitSdk:Lcn/uc/gamesdk/iface/Commands;

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/b/a;->a(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;

    move-result-object v0

    if-nez v0, :cond_0

    const-string v0, "dexSDKInit"

    const-string v1, "A"

    const-string v2, "Get Dispatcher fail"

    invoke-static {v0, v1, v2, v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V

    iget-object v0, p0, Lcn/uc/gamesdk/UCGameSDK$1$1;->b:Lcn/uc/gamesdk/UCGameSDK$1;

    iget-object v0, v0, Lcn/uc/gamesdk/UCGameSDK$1;->e:Lcn/uc/gamesdk/UCCallbackListener;

    const-string v1, "\u521d\u59cb\u5316\u5931\u8d25"

    invoke-interface {v0, v5, v1}, Lcn/uc/gamesdk/UCCallbackListener;->callback(ILjava/lang/Object;)V

    iget-object v0, p0, Lcn/uc/gamesdk/UCGameSDK$1$1;->b:Lcn/uc/gamesdk/UCGameSDK$1;

    iget-object v0, v0, Lcn/uc/gamesdk/UCGameSDK$1;->f:Landroid/app/ProgressDialog;

    invoke-virtual {v0}, Landroid/app/ProgressDialog;->dismiss()V

    :goto_0
    return-void

    :cond_0
    sget-object v1, Lcn/uc/gamesdk/iface/Commands;->InitSdk:Lcn/uc/gamesdk/iface/Commands;

    iget-object v2, p0, Lcn/uc/gamesdk/UCGameSDK$1$1;->a:Landroid/os/Bundle;

    const/4 v3, 0x0

    iget-object v4, p0, Lcn/uc/gamesdk/UCGameSDK$1$1;->b:Lcn/uc/gamesdk/UCGameSDK$1;

    iget-object v4, v4, Lcn/uc/gamesdk/UCGameSDK$1;->e:Lcn/uc/gamesdk/UCCallbackListener;

    invoke-interface {v0, v1, v2, v3, v4}, Lcn/uc/gamesdk/iface/IDispatcher;->invoke(Lcn/uc/gamesdk/iface/Commands;Landroid/os/Bundle;Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)Landroid/os/Bundle;

    move-result-object v0

    if-eqz v0, :cond_1

    const-string v1, "status"

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getInt(Ljava/lang/String;)I

    move-result v0

    packed-switch v0, :pswitch_data_0

    :cond_1
    :goto_1
    iget-object v0, p0, Lcn/uc/gamesdk/UCGameSDK$1$1;->b:Lcn/uc/gamesdk/UCGameSDK$1;

    iget-object v0, v0, Lcn/uc/gamesdk/UCGameSDK$1;->f:Landroid/app/ProgressDialog;

    invoke-virtual {v0}, Landroid/app/ProgressDialog;->dismiss()V

    goto :goto_0

    :pswitch_0
    const-string v0, "dexSDKInit"

    const-string v1, "A"

    const-string v2, "Dispatcher invoke fail"

    invoke-static {v0, v1, v2, v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V

    iget-object v0, p0, Lcn/uc/gamesdk/UCGameSDK$1$1;->b:Lcn/uc/gamesdk/UCGameSDK$1;

    iget-object v0, v0, Lcn/uc/gamesdk/UCGameSDK$1;->e:Lcn/uc/gamesdk/UCCallbackListener;

    const-string v1, "\u521d\u59cb\u5316\u5931\u8d25"

    invoke-interface {v0, v5, v1}, Lcn/uc/gamesdk/UCCallbackListener;->callback(ILjava/lang/Object;)V

    goto :goto_1

    nop

    :pswitch_data_0
    .packed-switch -0x2
        :pswitch_0
    .end packed-switch
.end method
