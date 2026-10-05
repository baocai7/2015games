.class Lcom/dygame/open/dayu/DYAlipayHelper$3;
.super Ljava/lang/Object;
.source "DYAlipayHelper.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/dygame/open/dayu/DYAlipayHelper;->pay(Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/dygame/open/dayu/DYAlipayHelper;

.field final synthetic val$payInfo:Ljava/lang/String;


# direct methods
.method constructor <init>(Lcom/dygame/open/dayu/DYAlipayHelper;Ljava/lang/String;)V
    .locals 0
    .param p1, "this$0"    # Lcom/dygame/open/dayu/DYAlipayHelper;

    .prologue
    .line 155
    iput-object p1, p0, Lcom/dygame/open/dayu/DYAlipayHelper$3;->this$0:Lcom/dygame/open/dayu/DYAlipayHelper;

    iput-object p2, p0, Lcom/dygame/open/dayu/DYAlipayHelper$3;->val$payInfo:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    .prologue
    .line 160
    new-instance v0, Lcom/alipay/sdk/app/PayTask;

    sget-object v3, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    invoke-direct {v0, v3}, Lcom/alipay/sdk/app/PayTask;-><init>(Landroid/app/Activity;)V

    .line 162
    .local v0, "alipay":Lcom/alipay/sdk/app/PayTask;
    iget-object v3, p0, Lcom/dygame/open/dayu/DYAlipayHelper$3;->val$payInfo:Ljava/lang/String;

    invoke-virtual {v0, v3}, Lcom/alipay/sdk/app/PayTask;->pay(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 164
    .local v2, "result":Ljava/lang/String;
    new-instance v1, Landroid/os/Message;

    invoke-direct {v1}, Landroid/os/Message;-><init>()V

    .line 165
    .local v1, "msg":Landroid/os/Message;
    const/4 v3, 0x1

    iput v3, v1, Landroid/os/Message;->what:I

    .line 166
    iput-object v2, v1, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 167
    iget-object v3, p0, Lcom/dygame/open/dayu/DYAlipayHelper$3;->this$0:Lcom/dygame/open/dayu/DYAlipayHelper;

    invoke-static {v3}, Lcom/dygame/open/dayu/DYAlipayHelper;->access$000(Lcom/dygame/open/dayu/DYAlipayHelper;)Landroid/os/Handler;

    move-result-object v3

    invoke-virtual {v3, v1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    .line 168
    return-void
.end method
