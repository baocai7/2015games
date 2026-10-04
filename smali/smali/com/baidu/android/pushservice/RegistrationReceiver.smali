.class public Lcom/baidu/android/pushservice/RegistrationReceiver;
.super Landroid/content/BroadcastReceiver;


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 1

    new-instance v0, Lcom/baidu/android/pushservice/RegistrationReceiver$1;

    invoke-direct {v0, p0, p1, p2}, Lcom/baidu/android/pushservice/RegistrationReceiver$1;-><init>(Lcom/baidu/android/pushservice/RegistrationReceiver;Landroid/content/Context;Landroid/content/Intent;)V

    invoke-static {v0, p1}, Lcom/baidu/android/pushservice/LoadExecutor;->excuteMethod(Ljava/lang/Runnable;Landroid/content/Context;)V

    return-void
.end method
