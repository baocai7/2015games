.class public Lcom/baidu/android/pushservice/apiproxy/BridgeReceiver;
.super Ljava/lang/Object;


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static PushServiceReceiverOnReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/baidu/android/pushservice/internal/PushServiceReceiver;->onReceive(Landroid/content/Context;Landroid/content/Intent;)V

    return-void
.end method

.method public static RegistrationReceiverOnReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/baidu/android/pushservice/internal/RegistrationReceiver;->onReceive(Landroid/content/Context;Landroid/content/Intent;)V

    return-void
.end method
