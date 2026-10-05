.class Lcom/dygame/open/dayu/DYAlipayHelper$1;
.super Landroid/os/Handler;
.source "DYAlipayHelper.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/dygame/open/dayu/DYAlipayHelper;
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
    .line 47
    iput-object p1, p0, Lcom/dygame/open/dayu/DYAlipayHelper$1;->this$0:Lcom/dygame/open/dayu/DYAlipayHelper;

    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 6
    .param p1, "msg"    # Landroid/os/Message;

    .prologue
    const/4 v5, 0x0

    .line 49
    iget v2, p1, Landroid/os/Message;->what:I

    packed-switch v2, :pswitch_data_0

    .line 85
    :goto_0
    return-void

    .line 51
    :pswitch_0
    new-instance v0, Lcom/dygame/open/dayu/PayResult;

    iget-object v2, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast v2, Ljava/lang/String;

    invoke-direct {v0, v2}, Lcom/dygame/open/dayu/PayResult;-><init>(Ljava/lang/String;)V

    .line 56
    .local v0, "payResult":Lcom/dygame/open/dayu/PayResult;
    invoke-virtual {v0}, Lcom/dygame/open/dayu/PayResult;->getResultStatus()Ljava/lang/String;

    move-result-object v1

    .line 59
    .local v1, "resultStatus":Ljava/lang/String;
    const-string v2, "9000"

    invoke-static {v1, v2}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 60
    sget-object v2, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    const-string v3, "\u652f\u4ed8\u6210\u529f"

    invoke-static {v2, v3, v5}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v2

    invoke-virtual {v2}, Landroid/widget/Toast;->show()V

    .line 61
    invoke-static {}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->getInstance()Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    move-result-object v2

    const/4 v3, 0x1

    invoke-virtual {v2, v3}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->afterPay(Z)V

    goto :goto_0

    .line 65
    :cond_0
    const-string v2, "8000"

    invoke-static {v1, v2}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 66
    sget-object v2, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    const-string v3, "\u652f\u4ed8\u7ed3\u679c\u786e\u8ba4\u4e2d"

    invoke-static {v2, v3, v5}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v2

    invoke-virtual {v2}, Landroid/widget/Toast;->show()V

    .line 74
    :goto_1
    invoke-static {}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->getInstance()Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    move-result-object v2

    invoke-virtual {v2, v5}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->afterPay(Z)V

    goto :goto_0

    .line 71
    :cond_1
    sget-object v2, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    const-string v3, "\u652f\u4ed8\u5931\u8d25"

    invoke-static {v2, v3, v5}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v2

    invoke-virtual {v2}, Landroid/widget/Toast;->show()V

    goto :goto_1

    .line 79
    .end local v0    # "payResult":Lcom/dygame/open/dayu/PayResult;
    .end local v1    # "resultStatus":Ljava/lang/String;
    :pswitch_1
    sget-object v2, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "\u68c0\u67e5\u7ed3\u679c\u4e3a\uff1a"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget-object v4, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3, v5}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v2

    invoke-virtual {v2}, Landroid/widget/Toast;->show()V

    goto :goto_0

    .line 49
    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method
