.class public interface abstract Lcn/uc/gamesdk/iface/IDispatcher;
.super Ljava/lang/Object;


# virtual methods
.method public abstract getContext()Landroid/content/Context;
.end method

.method public abstract getDispatcher(Lcn/uc/gamesdk/iface/Commands;)Lcn/uc/gamesdk/iface/IDispatcher;
.end method

.method public abstract getSdkCallbackListener()Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;
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

.method public abstract register(Landroid/content/Context;Ljava/lang/String;Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;Ljava/util/HashMap;)V
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
.end method
