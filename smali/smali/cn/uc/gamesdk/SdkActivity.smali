.class public Lcn/uc/gamesdk/SdkActivity;
.super Landroid/app/Activity;

# interfaces
.implements Lcn/uc/gamesdk/iface/IActivityControl;


# static fields
.field private static final CLASS_NAME:Ljava/lang/String; = "SdkActivity"


# instance fields
.field private listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener",
            "<",
            "Ljava/lang/Boolean;",
            "Landroid/os/Bundle;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 1

    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    const/4 v0, 0x0

    iput-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    return-void
.end method


# virtual methods
.method public finish()V
    .locals 3

    const/4 v2, 0x0

    const-string v0, "SdkActivity"

    const-string v1, "==finish=="

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    iget-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    const/4 v1, 0x6

    invoke-interface {v0, v1, v2}, Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;->callback(ILjava/lang/Object;)Ljava/lang/Object;

    iput-object v2, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    :cond_0
    invoke-super {p0}, Landroid/app/Activity;->finish()V

    return-void
.end method

.method protected onActivityResult(IILandroid/content/Intent;)V
    .locals 3

    const-string v0, "SdkActivity"

    const-string v1, "==onActivityResult=="

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    const-string v1, "requestCode"

    invoke-virtual {v0, v1, p1}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    const-string v1, "resultCode"

    invoke-virtual {v0, v1, p2}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    const-string v1, "data"

    invoke-virtual {v0, v1, p3}, Landroid/os/Bundle;->putParcelable(Ljava/lang/String;Landroid/os/Parcelable;)V

    iget-object v1, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    if-eqz v1, :cond_0

    iget-object v1, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    const/16 v2, 0xd

    invoke-interface {v1, v2, v0}, Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;->callback(ILjava/lang/Object;)Ljava/lang/Object;

    :cond_0
    invoke-super {p0, p1, p2, p3}, Landroid/app/Activity;->onActivityResult(IILandroid/content/Intent;)V

    return-void
.end method

.method public onConfigurationChanged(Landroid/content/res/Configuration;)V
    .locals 3

    const-string v0, "SdkActivity"

    const-string v1, "==onConfigurtionChanged=="

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    invoke-super {p0, p1}, Landroid/app/Activity;->onConfigurationChanged(Landroid/content/res/Configuration;)V

    iget-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    if-eqz v0, :cond_0

    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    const-string v1, "configuratin"

    invoke-virtual {v0, v1, p1}, Landroid/os/Bundle;->putParcelable(Ljava/lang/String;Landroid/os/Parcelable;)V

    iget-object v1, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    const/16 v2, 0xc

    invoke-interface {v1, v2, v0}, Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;->callback(ILjava/lang/Object;)Ljava/lang/Object;

    :cond_0
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 4

    const/4 v2, 0x1

    const-string v0, "SdkActivity"

    const-string v1, "==onCreate=="

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    invoke-virtual {p0, v2}, Lcn/uc/gamesdk/SdkActivity;->requestWindowFeature(I)Z

    invoke-virtual {p0}, Lcn/uc/gamesdk/SdkActivity;->getWindow()Landroid/view/Window;

    move-result-object v0

    const/16 v1, 0x10

    invoke-virtual {v0, v1}, Landroid/view/Window;->setSoftInputMode(I)V

    invoke-virtual {p0}, Lcn/uc/gamesdk/SdkActivity;->getWindow()Landroid/view/Window;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v2}, Landroid/view/View;->setDrawingCacheEnabled(Z)V

    if-nez p1, :cond_1

    invoke-virtual {p0}, Lcn/uc/gamesdk/SdkActivity;->getIntent()Landroid/content/Intent;

    move-result-object v0

    const-string v1, "data"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->getBundleExtra(Ljava/lang/String;)Landroid/os/Bundle;

    move-result-object v0

    const-string v1, "from"

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-static {}, Lcn/uc/gamesdk/b/a;->a()Lcn/uc/gamesdk/b/a;

    move-result-object v2

    invoke-virtual {v2, v1}, Lcn/uc/gamesdk/b/a;->a(Ljava/lang/String;)Lcn/uc/gamesdk/iface/IDispatcher;

    move-result-object v1

    if-eqz v1, :cond_0

    sget-object v2, Lcn/uc/gamesdk/iface/Commands;->ActivityCallback:Lcn/uc/gamesdk/iface/Commands;

    const/4 v3, 0x0

    invoke-interface {v1, v2, v0, p0, v3}, Lcn/uc/gamesdk/iface/IDispatcher;->invoke(Lcn/uc/gamesdk/iface/Commands;Landroid/os/Bundle;Landroid/app/Activity;Lcn/uc/gamesdk/UCCallbackListener;)Landroid/os/Bundle;

    :goto_0
    return-void

    :cond_0
    const-string v0, "SdkActivity"

    const-string v1, "onCreate"

    const-string v2, "\u4e0d\u80fd\u83b7\u53d6\u5165\u53e3\u5b9e\u4f8b\uff0c\u9700\u8981\u91cd\u65b0\u521d\u59cb\u5316"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {p0}, Lcn/uc/gamesdk/SdkActivity;->finish()V

    goto :goto_0

    :cond_1
    const-string v0, "SdkActivity"

    const-string v1, "onCreate"

    const-string v2, "SdkActivity\u88ab\u9500\u6bc1,\u9700\u8981\u91cd\u65b0\u521d\u59cb\u5316"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {p0}, Lcn/uc/gamesdk/SdkActivity;->finish()V

    goto :goto_0
.end method

.method protected onDestroy()V
    .locals 2

    const-string v0, "SdkActivity"

    const-string v1, "==onDestroy=="

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    invoke-super {p0}, Landroid/app/Activity;->onDestroy()V

    return-void
.end method

.method public onKeyDown(ILandroid/view/KeyEvent;)Z
    .locals 3

    const-string v0, "SdkActivity"

    const-string v1, "==onKeyDown=="

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    iget-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    if-eqz v0, :cond_0

    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    const-string v1, "keyCode"

    invoke-virtual {v0, v1, p1}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    const-string v1, "keyEvent"

    invoke-virtual {v0, v1, p2}, Landroid/os/Bundle;->putParcelable(Ljava/lang/String;Landroid/os/Parcelable;)V

    iget-object v1, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    const/16 v2, 0xb

    invoke-interface {v1, v2, v0}, Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;->callback(ILjava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    :goto_0
    return v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public onLowMemory()V
    .locals 3

    const-string v0, "SdkActivity"

    const-string v1, "==onLowMemory=="

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    invoke-super {p0}, Landroid/app/Activity;->onLowMemory()V

    iget-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    const/4 v1, 0x7

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;->callback(ILjava/lang/Object;)Ljava/lang/Object;

    :cond_0
    return-void
.end method

.method protected onNewIntent(Landroid/content/Intent;)V
    .locals 3

    const-string v0, "SdkActivity"

    const-string v1, "==onNewIntent=="

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    iget-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    if-eqz v0, :cond_0

    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    const-string v1, "intent"

    invoke-virtual {v0, v1, p1}, Landroid/os/Bundle;->putParcelable(Ljava/lang/String;Landroid/os/Parcelable;)V

    iget-object v1, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    const/4 v2, 0x3

    invoke-interface {v1, v2, v0}, Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;->callback(ILjava/lang/Object;)Ljava/lang/Object;

    :cond_0
    invoke-super {p0, p1}, Landroid/app/Activity;->onNewIntent(Landroid/content/Intent;)V

    return-void
.end method

.method protected onPause()V
    .locals 3

    const-string v0, "SdkActivity"

    const-string v1, "==onPause=="

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    invoke-super {p0}, Landroid/app/Activity;->onPause()V

    iget-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    const/16 v1, 0xa

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;->callback(ILjava/lang/Object;)Ljava/lang/Object;

    :cond_0
    return-void
.end method

.method protected onRestoreInstanceState(Landroid/os/Bundle;)V
    .locals 2

    const-string v0, "SdkActivity"

    const-string v1, "==onRestoreInstanceState=="

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    invoke-super {p0, p1}, Landroid/app/Activity;->onRestoreInstanceState(Landroid/os/Bundle;)V

    iget-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    const/4 v1, 0x5

    invoke-interface {v0, v1, p1}, Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;->callback(ILjava/lang/Object;)Ljava/lang/Object;

    :cond_0
    return-void
.end method

.method protected onResume()V
    .locals 3

    const-string v0, "SdkActivity"

    const-string v1, "==onResume=="

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    iget-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    const/16 v1, 0x9

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;->callback(ILjava/lang/Object;)Ljava/lang/Object;

    :cond_0
    invoke-super {p0}, Landroid/app/Activity;->onResume()V

    return-void
.end method

.method protected onSaveInstanceState(Landroid/os/Bundle;)V
    .locals 2

    const-string v0, "SdkActivity"

    const-string v1, "==onSaveInstanceState=="

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    invoke-super {p0, p1}, Landroid/app/Activity;->onSaveInstanceState(Landroid/os/Bundle;)V

    iget-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    const/4 v1, 0x4

    invoke-interface {v0, v1, p1}, Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;->callback(ILjava/lang/Object;)Ljava/lang/Object;

    :cond_0
    return-void
.end method

.method protected onStart()V
    .locals 3

    const-string v0, "SdkActivity"

    const-string v1, "==onStart=="

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    invoke-super {p0}, Landroid/app/Activity;->onStart()V

    iget-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    const/4 v1, 0x1

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;->callback(ILjava/lang/Object;)Ljava/lang/Object;

    :cond_0
    return-void
.end method

.method protected onStop()V
    .locals 3

    const-string v0, "SdkActivity"

    const-string v1, "==onStop=="

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    invoke-super {p0}, Landroid/app/Activity;->onStop()V

    iget-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    const/16 v1, 0x8

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;->callback(ILjava/lang/Object;)Ljava/lang/Object;

    :cond_0
    return-void
.end method

.method public setListener(Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener",
            "<",
            "Ljava/lang/Boolean;",
            "Landroid/os/Bundle;",
            ">;)V"
        }
    .end annotation

    iput-object p1, p0, Lcn/uc/gamesdk/SdkActivity;->listener:Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;

    return-void
.end method
