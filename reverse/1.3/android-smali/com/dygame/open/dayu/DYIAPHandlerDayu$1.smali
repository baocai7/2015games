.class Lcom/dygame/open/dayu/DYIAPHandlerDayu$1;
.super Landroid/os/Handler;
.source "DYIAPHandlerDayu.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/dygame/open/dayu/DYIAPHandlerDayu;->afterPay(Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/dygame/open/dayu/DYIAPHandlerDayu;

.field final synthetic val$bSucc:Z


# direct methods
.method constructor <init>(Lcom/dygame/open/dayu/DYIAPHandlerDayu;Z)V
    .locals 0
    .param p1, "this$0"    # Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    .prologue
    .line 78
    iput-object p1, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu$1;->this$0:Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    iput-boolean p2, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu$1;->val$bSucc:Z

    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 2
    .param p1, "msg"    # Landroid/os/Message;

    .prologue
    .line 81
    iget-boolean v0, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu$1;->val$bSucc:Z

    if-eqz v0, :cond_0

    .line 82
    iget-object v0, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu$1;->this$0:Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    invoke-static {v0}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->access$000(Lcom/dygame/open/dayu/DYIAPHandlerDayu;)Ljava/lang/String;

    move-result-object v0

    iget-object v1, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu$1;->this$0:Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    invoke-static {v1}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->access$100(Lcom/dygame/open/dayu/DYIAPHandlerDayu;)I

    move-result v1

    invoke-static {v0, v1}, Lcom/dygame/common/DYIAPMgr;->onPaySucc(Ljava/lang/String;I)V

    .line 87
    :goto_0
    iget-object v0, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu$1;->this$0:Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    const/4 v1, -0x1

    invoke-static {v0, v1}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->access$102(Lcom/dygame/open/dayu/DYIAPHandlerDayu;I)I

    .line 88
    return-void

    .line 85
    :cond_0
    iget-object v0, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu$1;->this$0:Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    invoke-static {v0}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->access$000(Lcom/dygame/open/dayu/DYIAPHandlerDayu;)Ljava/lang/String;

    move-result-object v0

    iget-object v1, p0, Lcom/dygame/open/dayu/DYIAPHandlerDayu$1;->this$0:Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    invoke-static {v1}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->access$100(Lcom/dygame/open/dayu/DYIAPHandlerDayu;)I

    move-result v1

    invoke-static {v0, v1}, Lcom/dygame/common/DYIAPMgr;->onPayFail(Ljava/lang/String;I)V

    goto :goto_0
.end method
