.class public abstract Lcn/uc/gamesdk/iface/Dispatcher;
.super Ljava/lang/Object;

# interfaces
.implements Lcn/uc/gamesdk/iface/IDispatcher;


# instance fields
.field protected context:Landroid/content/Context;

.field protected dispatcherMap:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap",
            "<",
            "Lcn/uc/gamesdk/iface/Commands;",
            "Lcn/uc/gamesdk/iface/IDispatcher;",
            ">;"
        }
    .end annotation
.end field

.field protected listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener",
            "<",
            "Landroid/os/Bundle;",
            "Landroid/os/Bundle;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 1

    const/4 v0, 0x0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object v0, p0, Lcn/uc/gamesdk/iface/Dispatcher;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    iput-object v0, p0, Lcn/uc/gamesdk/iface/Dispatcher;->context:Landroid/content/Context;

    iput-object v0, p0, Lcn/uc/gamesdk/iface/Dispatcher;->dispatcherMap:Ljava/util/HashMap;

    return-void
.end method


# virtual methods
.method public getContext()Landroid/content/Context;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/iface/Dispatcher;->context:Landroid/content/Context;

    return-object v0
.end method

.method public getDispatcher(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/iface/Dispatcher;->dispatcherMap:Ljava/util/HashMap;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcn/uc/gamesdk/iface/Dispatcher;->dispatcherMap:Ljava/util/HashMap;

    invoke-virtual {v0, p1}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcn/uc/gamesdk/iface/Dispatcher;->dispatcherMap:Ljava/util/HashMap;

    invoke-virtual {v0, p1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcn/uc/gamesdk/iface/IDispatcher;

    :goto_0
    return-object v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public getSdkCallbackListener()Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener",
            "<",
            "Landroid/os/Bundle;",
            "Landroid/os/Bundle;",
            ">;"
        }
    .end annotation

    iget-object v0, p0, Lcn/uc/gamesdk/iface/Dispatcher;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    return-object v0
.end method

.method public abstract invoke(Lcn/uc/gamesdk/iface/Commands;Landroid/os/Bundle;Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)Landroid/os/Bundle;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcn/uc/gamesdk/iface/Commands;",
            "Landroid/os/Bundle;",
            "Landroid/app/Activity;",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<*>;)",
            "Landroid/os/Bundle;"
        }
    .end annotation
.end method

.method public register(Landroid/content/Context;Ljava/lang/String;Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;Ljava/util/HashMap;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/lang/String;",
            "Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener",
            "<",
            "Landroid/os/Bundle;",
            "Landroid/os/Bundle;",
            ">;",
            "Ljava/util/HashMap",
            "<",
            "Lcn/uc/gamesdk/iface/Commands;",
            "Lcn/uc/gamesdk/iface/IDispatcher;",
            ">;)V"
        }
    .end annotation

    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    iput-object v0, p0, Lcn/uc/gamesdk/iface/Dispatcher;->context:Landroid/content/Context;

    iput-object p3, p0, Lcn/uc/gamesdk/iface/Dispatcher;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    iput-object p4, p0, Lcn/uc/gamesdk/iface/Dispatcher;->dispatcherMap:Ljava/util/HashMap;

    return-void
.end method
