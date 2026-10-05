.class Lcom/dygame/open/dayu/DYAlipayHelper$4;
.super Ljava/lang/Object;
.source "DYAlipayHelper.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/dygame/open/dayu/DYAlipayHelper;->check(Landroid/view/View;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/dygame/open/dayu/DYAlipayHelper;


# direct methods
.method constructor <init>(Lcom/dygame/open/dayu/DYAlipayHelper;)V
    .locals 0
    .param p1, "this$0"    # Lcom/dygame/open/dayu/DYAlipayHelper;

    .prologue
    .line 182
    iput-object p1, p0, Lcom/dygame/open/dayu/DYAlipayHelper$4;->this$0:Lcom/dygame/open/dayu/DYAlipayHelper;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    .prologue
    .line 187
    new-instance v2, Lcom/alipay/sdk/app/PayTask;

    sget-object v3, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    invoke-direct {v2, v3}, Lcom/alipay/sdk/app/PayTask;-><init>(Landroid/app/Activity;)V

    .line 189
    .local v2, "payTask":Lcom/alipay/sdk/app/PayTask;
    invoke-virtual {v2}, Lcom/alipay/sdk/app/PayTask;->checkAccountIfExist()Z

    move-result v0

    .line 191
    .local v0, "isExist":Z
    new-instance v1, Landroid/os/Message;

    invoke-direct {v1}, Landroid/os/Message;-><init>()V

    .line 192
    .local v1, "msg":Landroid/os/Message;
    const/4 v3, 0x2

    iput v3, v1, Landroid/os/Message;->what:I

    .line 193
    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v3

    iput-object v3, v1, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 194
    iget-object v3, p0, Lcom/dygame/open/dayu/DYAlipayHelper$4;->this$0:Lcom/dygame/open/dayu/DYAlipayHelper;

    invoke-static {v3}, Lcom/dygame/open/dayu/DYAlipayHelper;->access$000(Lcom/dygame/open/dayu/DYAlipayHelper;)Landroid/os/Handler;

    move-result-object v3

    invoke-virtual {v3, v1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    .line 195
    return-void
.end method
