.class Lcom/baidu/android/pushservice/PushServiceReceiver$1;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/baidu/android/pushservice/PushServiceReceiver;->onReceive(Landroid/content/Context;Landroid/content/Intent;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic a:Landroid/content/Context;

.field final synthetic b:Landroid/content/Intent;

.field final synthetic c:Lcom/baidu/android/pushservice/PushServiceReceiver;


# direct methods
.method constructor <init>(Lcom/baidu/android/pushservice/PushServiceReceiver;Landroid/content/Context;Landroid/content/Intent;)V
    .locals 0

    iput-object p1, p0, Lcom/baidu/android/pushservice/PushServiceReceiver$1;->c:Lcom/baidu/android/pushservice/PushServiceReceiver;

    iput-object p2, p0, Lcom/baidu/android/pushservice/PushServiceReceiver$1;->a:Landroid/content/Context;

    iput-object p3, p0, Lcom/baidu/android/pushservice/PushServiceReceiver$1;->b:Landroid/content/Intent;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    iget-object v0, p0, Lcom/baidu/android/pushservice/PushServiceReceiver$1;->a:Landroid/content/Context;

    iget-object v1, p0, Lcom/baidu/android/pushservice/PushServiceReceiver$1;->b:Landroid/content/Intent;

    invoke-static {v0, v1}, Lcom/baidu/android/pushservice/apiproxy/BridgeReceiver;->PushServiceReceiverOnReceive(Landroid/content/Context;Landroid/content/Intent;)V

    return-void
.end method
