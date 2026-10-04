.class public interface abstract Lcn/uc/gamesdk/iface/IActivityControl;
.super Ljava/lang/Object;


# virtual methods
.method public abstract finish()V
.end method

.method public abstract getAssets()Landroid/content/res/AssetManager;
.end method

.method public abstract getContentResolver()Landroid/content/ContentResolver;
.end method

.method public abstract getPackageName()Ljava/lang/String;
.end method

.method public abstract getSystemService(Ljava/lang/String;)Ljava/lang/Object;
.end method

.method public abstract isFinishing()Z
.end method

.method public abstract managedQuery(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;
.end method

.method public abstract registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;
.end method

.method public abstract runOnUiThread(Ljava/lang/Runnable;)V
.end method

.method public abstract setListener(Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;)V
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
.end method

.method public abstract unregisterReceiver(Landroid/content/BroadcastReceiver;)V
.end method
