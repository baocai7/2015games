.class Lcom/dygame/dysdk/UserRegDlg$1;
.super Landroid/os/Handler;
.source "UserRegDlg.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/dygame/dysdk/UserRegDlg;->initWidgets()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/dygame/dysdk/UserRegDlg;


# direct methods
.method constructor <init>(Lcom/dygame/dysdk/UserRegDlg;)V
    .locals 0
    .param p1, "this$0"    # Lcom/dygame/dysdk/UserRegDlg;

    .prologue
    .line 63
    iput-object p1, p0, Lcom/dygame/dysdk/UserRegDlg$1;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 8
    .param p1, "msg"    # Landroid/os/Message;

    .prologue
    const/4 v7, 0x1

    const/4 v6, 0x0

    .line 66
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->leftTickForGetVerify()J

    move-result-wide v0

    .line 67
    .local v0, "left":J
    const-wide/16 v4, 0x0

    cmp-long v3, v0, v4

    if-lez v3, :cond_0

    .line 68
    iget-object v3, p0, Lcom/dygame/dysdk/UserRegDlg$1;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    iget-object v3, v3, Lcom/dygame/dysdk/UserRegDlg;->mBtnVerify:Landroid/widget/Button;

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 69
    iget-object v3, p0, Lcom/dygame/dysdk/UserRegDlg$1;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    iget-object v3, v3, Lcom/dygame/dysdk/UserRegDlg;->mBtnVerify:Landroid/widget/Button;

    sget v4, Lcom/dygame/dysdk/R$drawable;->dysdk_btn_code_02:I

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setBackgroundResource(I)V

    .line 70
    iget-object v3, p0, Lcom/dygame/dysdk/UserRegDlg$1;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    iget-object v3, v3, Lcom/dygame/dysdk/UserRegDlg;->mBtnVerify:Landroid/widget/Button;

    iget-object v4, p0, Lcom/dygame/dysdk/UserRegDlg$1;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    invoke-virtual {v4}, Lcom/dygame/dysdk/UserRegDlg;->getContext()Landroid/content/Context;

    move-result-object v4

    invoke-virtual {v4}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v4

    sget v5, Lcom/dygame/dysdk/R$color;->dysdk_verify_disable:I

    invoke-virtual {v4, v5}, Landroid/content/res/Resources;->getColor(I)I

    move-result v4

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setTextColor(I)V

    .line 71
    iget-object v3, p0, Lcom/dygame/dysdk/UserRegDlg$1;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    invoke-virtual {v3}, Lcom/dygame/dysdk/UserRegDlg;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    sget v4, Lcom/dygame/dysdk/R$string;->dysdk_get_verify_again:I

    .line 72
    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v2

    .line 73
    .local v2, "str":Ljava/lang/String;
    new-array v3, v7, [Ljava/lang/Object;

    const-wide/16 v4, 0x3e8

    div-long v4, v0, v4

    long-to-double v4, v4

    invoke-static {v4, v5}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v4

    double-to-int v4, v4

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v3, v6

    invoke-static {v2, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    .line 74
    iget-object v3, p0, Lcom/dygame/dysdk/UserRegDlg$1;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    iget-object v3, v3, Lcom/dygame/dysdk/UserRegDlg;->mBtnVerify:Landroid/widget/Button;

    invoke-virtual {v3, v2}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 75
    const-wide/16 v4, 0x1f4

    invoke-virtual {p0, v6, v4, v5}, Lcom/dygame/dysdk/UserRegDlg$1;->sendEmptyMessageDelayed(IJ)Z

    .line 76
    iget-object v3, p0, Lcom/dygame/dysdk/UserRegDlg$1;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    iget-object v3, v3, Lcom/dygame/dysdk/UserRegDlg;->mBtnVerify:Landroid/widget/Button;

    invoke-virtual {v3, v6}, Landroid/widget/Button;->setEnabled(Z)V

    .line 84
    .end local v2    # "str":Ljava/lang/String;
    :goto_0
    return-void

    .line 79
    :cond_0
    iget-object v3, p0, Lcom/dygame/dysdk/UserRegDlg$1;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    iget-object v3, v3, Lcom/dygame/dysdk/UserRegDlg;->mBtnVerify:Landroid/widget/Button;

    iget-object v4, p0, Lcom/dygame/dysdk/UserRegDlg$1;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 80
    iget-object v3, p0, Lcom/dygame/dysdk/UserRegDlg$1;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    iget-object v3, v3, Lcom/dygame/dysdk/UserRegDlg;->mBtnVerify:Landroid/widget/Button;

    sget v4, Lcom/dygame/dysdk/R$drawable;->dysdk_btn_code_01:I

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setBackgroundResource(I)V

    .line 81
    iget-object v3, p0, Lcom/dygame/dysdk/UserRegDlg$1;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    iget-object v3, v3, Lcom/dygame/dysdk/UserRegDlg;->mBtnVerify:Landroid/widget/Button;

    iget-object v4, p0, Lcom/dygame/dysdk/UserRegDlg$1;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    invoke-virtual {v4}, Lcom/dygame/dysdk/UserRegDlg;->getContext()Landroid/content/Context;

    move-result-object v4

    invoke-virtual {v4}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v4

    sget v5, Lcom/dygame/dysdk/R$color;->dysdk_verify_enable:I

    invoke-virtual {v4, v5}, Landroid/content/res/Resources;->getColor(I)I

    move-result v4

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setTextColor(I)V

    .line 82
    iget-object v3, p0, Lcom/dygame/dysdk/UserRegDlg$1;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    iget-object v3, v3, Lcom/dygame/dysdk/UserRegDlg;->mBtnVerify:Landroid/widget/Button;

    sget v4, Lcom/dygame/dysdk/R$string;->dysdk_get_verify:I

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(I)V

    .line 83
    iget-object v3, p0, Lcom/dygame/dysdk/UserRegDlg$1;->this$0:Lcom/dygame/dysdk/UserRegDlg;

    iget-object v3, v3, Lcom/dygame/dysdk/UserRegDlg;->mBtnVerify:Landroid/widget/Button;

    invoke-virtual {v3, v7}, Landroid/widget/Button;->setEnabled(Z)V

    goto :goto_0
.end method
